package view
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import model.vo.InputVO;
	import model.vo.ReceiveConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.InputArea;

	public class InputAreaMediator extends Mediator
	{
		public static const NAME:String = 'InputAreaMediator';
		
		private var _rightArticle:String;	//待输入的文本，也就是从PHP获取的文章字符串
		private var _curChar:String;		//当前输入的字符
		private var _inputRight:Boolean;	//当前的字符是否输入正确
		private var _inputWrongChars:Array;	//输入错误的字符索引(1基)数组
		private var _inputLength:int;		//已经输入的字符的数量
		
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
		
		private function changeHandler(evt:Event):void
		{
			trace('=================');
			var __curIndex:int = _view.length;	//已经输入的字符的索引（1基）
			var __rightChar:String = _rightArticle.charAt(__curIndex-1);	//根据索引得出的正确的字符
			trace('__curIndex:',__curIndex);
			trace('_inputLength:',_inputLength);
			if(__curIndex >= _inputLength)
			//如果字符索引大于上次输入的字符，说明是输入字符
			{
				trace('增加字符，当前索引：',__curIndex);
				if(_curChar == __rightChar)
				{
					_inputRight = true;
				}
				else
				{
					_inputRight = false;
					_inputWrongChars.push(__curIndex);
					trace('错误索引：',_inputWrongChars);
				} 
				_view.setFormat(__curIndex, _inputRight);	//设置文字的样式显示输入正确或错误
			}
			else
			//否则就是删除字符，不必设置文字样式
			{
				_inputRight = true;
				trace('删除字符，当前索引：',__curIndex);
				trace('列表中的最后一个索引：',_inputWrongChars[_inputWrongChars.length-1]);
				var _wrongLength:int = _inputWrongChars.length;
				if((_wrongLength != 0) && ((__curIndex+1) == _inputWrongChars[_wrongLength-1]))
				{
					
					_inputWrongChars.pop();
				}
				trace('删除之后的错误索引：',_inputWrongChars)
			}
			//如果输入的文字与正确的文字数量相等，说明输入完毕，禁止再输入
			if(__curIndex >= _rightArticle.length)this.editable = false;
			//更新已经输入的文字数量
			_inputLength = _view.length;
			//发布文字改变的信息;
			_refresh();				
		}
		
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
			inputLength = 0;
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
			return	[	ApplicationFacade.RECEIVE_CONFIG,
						ApplicationFacade.TIMER_REFRESH	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RECEIVE_CONFIG:
					var __config:ReceiveConfigVO = ReceiveConfigVO(notification.getBody());
					_rightArticle = __config.article;
					break;
				case ApplicationFacade.TIMER_REFRESH:
					
					break;
			}
		}
	}
}