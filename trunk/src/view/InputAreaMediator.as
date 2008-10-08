package view
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import model.vo.InputVO;
	import model.vo.ReceiveConfigVO;
	import model.vo.WrongCharsVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import type.PostType;
	
	import view.components.InputArea;

	public class InputAreaMediator extends Mediator
	{
		public static const NAME:String = 'InputAreaMediator';
		
		private var _rightArticle:String;	//待输入的文本，也就是从PHP获取的文章字符串
		private var _curChar:String;		//当前输入的字符
		private var _inputRight:Array;	//当前的字符是否输入正确
		private var _inputWrongChars:Array;	//输入错误的字符索引(1基)数组
		private var _inputLength:int;		//已经输入的字符的数量，此数量与下一次打字的时候进行比对，看用户是否是粘贴内容
		
		public function InputAreaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view.addEventListener(TextEvent.TEXT_INPUT, _textInputHandler);
			_view.addEventListener(Event.CHANGE, _changeHandler);
			_reset();
		}
		
		private function get _view():InputArea
		{
			return viewComponent as InputArea;
		}
		
		
		private function _textInputHandler(evt:TextEvent):void
		{
			//保存当前输入的字符
			_curChar = evt.text;
			//当文字内容为空的时候，说明是第一次输入文字，发送开始时间到服务器
			if(_view.length == 0)
			{
				sendNotification(ApplicationFacade.SEND_START);
			}
		}
		
		private function _changeHandler(evt:Event):void
		{
			var __curIndex:int = _view.length;	//已经输入的字符的索引（1基）
			trace('已输入：', _inputLength, '，当前索引：', __curIndex);
//			trace('=================');
//			trace('__curIndex:',__curIndex);
//			trace('_inputLength:',_inputLength);
			if(__curIndex >= _inputLength)
			//如果字符索引大于上次输入的字符，说明是输入字符
			{
				_addText();
			}
			else
			//否则就是删除字符，不必设置文字样式
			{
				_delText(__curIndex);
			}
			//更新已经输入的文字数量
			_inputLength = _view.length;
			//如果输入的文字与正确的文字数量相等，说明输入完毕，禁止再输入
			if(__curIndex >= _rightArticle.length)
			{
				_view.editable = false;
				sendNotification(ApplicationFacade.SEND_POST, PostType.INPUT_DONE);
				return;	
			}			
			//发布文字改变的信息;
			_refresh();				
		}
		
		//输入文字时候的操作
		private function _addText():void
		{
			_inputRight = [];
			var __rightChar:String = _rightArticle.substr(_inputLength, _curChar.length);	//根据索引得出的正确的字符
			trace('_curChar:', _curChar, '_rightChar:', __rightChar);
			if(_curChar == __rightChar)
			{
				for(var i:int=0; i<_curChar.length; i++)
				{
					_inputRight.push(true);
				}				
			}
			else
			{
				if(_curChar.length > 1)
				{
					//输入的是多个文字，要获取多个文字中错误文字的数量和布尔值转换
					var __wrongChars:WrongCharsVO = _calculateWrong(_curChar, __rightChar);
					_inputRight = __wrongChars.boolList;
					//取得错误的文字的相对索引，转换成绝对索引后存入错误索引总数组中
					for(var j:int=0; j<__wrongChars.wrongIndexList.length; j++)
					{
						_inputWrongChars.push(_inputLength + __wrongChars.wrongIndexList[j]);
					}
				}
				else
				{
					//输入的是单个文字
					_inputWrongChars.push(_inputLength);
					_inputRight = [false];
				}				
				trace('错误索引：',_inputWrongChars);
			} 
			_view.setFormat(_inputLength, _inputRight);	//设置文字的样式显示输入正确或错误
		}
		
		//删除文字时候的操作
		private function _delText($curIndex:int):void
		{
			var __caretIndex:int = _view.caretIndex;
			_inputRight = [];
			trace('删除字符，删除前的已输入文字索引：'+_inputLength, '最终输入文字索引：'+$curIndex,'光标所在的索引：'+__caretIndex);
			//删除文字有三种情况：1、从最后面按“回退”键删除；2、从文字中间按“回退”或“删除”键删除；3、选中一段文字然后删除。
			trace('删除前的错误索引：',_inputWrongChars);
			//如果光标所在位置与最终文字索引相等，并且删除前已经输入的文字仅比删除后的文字多1个，说明是第1种情况
			//如果在光标所在位置与最终文字索引相等的前提下，删除前已经输入的文字比删除后的文字多了超过一个，是第3种情况的一种特殊表现，就是从输入文字的末尾选择一段文字删除。		
			if(__caretIndex == $curIndex && (_inputLength - $curIndex) == 1)
			{
				if(_inputWrongChars.length == 0) return;
				trace('错误索引列表中的最后一个索引：', _inputWrongChars[_inputWrongChars.length-1]);
				if(_inputWrongChars[_inputWrongChars.length-1] == $curIndex)
				{
					_inputWrongChars.pop();
				}
			}
			//否则就是第2、3种情况
			else
			{
				//删除错误索引列表中，光标所在位置索引之后的所有错误索引。因为从中间删除文字后，由于文字顺序的改变，后面的文字都应该算错误。
				//虽然有可能会有相同的文字因为出现在不同的顺序，碰巧对了（很有可能这样），但由于不是用户自行输入的，也不能算对
				//因此光标之后的所有文字，都应该算错误文字，将这些文字的索引重新写入到错误索引列表中
				for(var __index:int=0; __index<_inputWrongChars.length; __index++)
				{
					if(_inputWrongChars[__index] >= __caretIndex)
					{
						_inputWrongChars.splice(__index);
						break;
					}
				}
				//将光标后面的所有文字都算做错误文字，将他们的索引写入错误索引列表
				for(var __wrongIndex:int=__caretIndex; __wrongIndex<$curIndex; __wrongIndex++)
				{
					_inputWrongChars.push(__wrongIndex);
					_inputRight.push(false);
				}
				_view.setFormat(__caretIndex, _inputRight);	//设置文字的样式显示输入正确或错误
			}
			trace('删除后的错误索引：',_inputWrongChars);
		}
		
		//计算输入文字中哪些是错误的，并返回这些错误相对于输入的文字串的索引。
		private function _calculateWrong($curChar:String, $rightChar:String):WrongCharsVO
		{
			if($curChar.length != $rightChar.length) throw new Error('输入的字符串和用于比较的字符串长度不同！');
			var __wrongIndex:Array = [];
			var __boolList:Array = [];
			//逐个检查输入的字符串和待比较的字符串的每个文字是否相同
			for(var i:int=0; i<$curChar.length; i++)
			{
				if($curChar.charAt(i) != $rightChar.charAt(i))
				{
					__wrongIndex.push(i);
					__boolList.push(false);						
				} 
				else
				{
					__boolList.push(true);
				}
			}
			if(__wrongIndex.length == 0) throw new Error('输入的字符串与待比较字符串完全相同！');
			trace('检测出的错误索引：', __wrongIndex,'bool列表:', __boolList);
			return new WrongCharsVO(__wrongIndex, __boolList);
		}
		//发送更新文字信息
		private function _refresh():void
		{
			var __vo:InputVO = new InputVO(	_inputLength, 
											_inputRight, 
											_inputLength-_inputWrongChars.length, 
											_rightArticle.length);											
			sendNotification(ApplicationFacade.INPUT, __vo);
		}
		
		private function _reset():void
		{
			_view.text = '';
			_view.editable = true;
			_inputWrongChars = new Array();
			_inputLength = 0;
			_inputRight = [];
			_view.enabled = true;
			_view.editable = true;
			_view.setFocus();
		}
		
//		private function _refresh():void
//		{
//			_rightRatio = Math.floor(inputTA.rightChars/inputTA.length*1000)/10;
//			_percent = Math.floor(inputTA.length/article.length*100);
//			//_speed = Math.floor(inputTA.length/((time - spareTime)/1000/60));	//瞬时速度
//			_speed = Math.floor(inputTA.length/(time/1000/60));	//真实速度
//		}
		
		override public function listNotificationInterests():Array
		{
			return	[	ApplicationFacade.RECEIVE_CONFIG	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RECEIVE_CONFIG:
					var __config:ReceiveConfigVO = ReceiveConfigVO(notification.getBody());
					_rightArticle = __config.article;
					break;
			}
		}
	}
}