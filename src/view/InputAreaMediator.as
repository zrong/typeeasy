package view
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import model.vo.InputVO;
	import model.vo.ReceiveConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import type.PostType;
	
	import view.components.InputArea;

	public class InputAreaMediator extends Mediator
	{
		public static const NAME:String = 'InputAreaMediator';
		
		private var _rightArticle:String;	//待输入的文本，也就是从PHP获取的文章字符串
		private var _curChar:String;		//当前输入的字符
		private var _inputRight:Boolean;	//当前的字符是否输入正确
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
				_addText(__curIndex);
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
		private function _addText($curIndex:int):void
		{
			trace('增加字符，当前索引：',$curIndex);
			var __rightChar:String = _rightArticle.substr(_inputLength, _curChar.length);	//根据索引得出的正确的字符
			trace('_curChar:', _curChar, '_rightChar:', __rightChar);
			if(_curChar == __rightChar)
			{
				_inputRight = true;
			}
			else
			{
				_inputRight = false;
				_inputWrongChars.push($curIndex);
//				trace('错误索引：',_inputWrongChars);
			} 
			_view.setFormat($curIndex, _inputRight);	//设置文字的样式显示输入正确或错误
		}
		
		//删除文字时候的操作
		private function _delText($curIndex:int):void
		{
			_inputRight = true;
//			trace('删除字符，当前索引：',__curIndex);
//			trace('列表中的最后一个索引：',_inputWrongChars[_inputWrongChars.length-1]);
			var _wrongLength:int = _inputWrongChars.length;
			if((_wrongLength != 0) && (($curIndex+1) == _inputWrongChars[_wrongLength-1]))
			{
					
				_inputWrongChars.pop();
			}
			trace('删除之后的错误索引：',_inputWrongChars)
		}
		
		private function _calculateWrong():Array
		{
			
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
			_inputRight = false;
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