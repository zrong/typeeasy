package view
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import model.vo.ReceiveConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.InputArea;

	public class InputAreaMediator extends Mediator
	{
		public static const NAME:String = 'InputAreaMediator';
		
		private var _rightArticle:String;
		
		public function InputAreaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
//			_view.addEventListener(TextEvent.TEXT_INPUT, _textInputHandler);
//			_view.addEventListener(InputArea.INPUT_CHANGE, _changeHandler);
		}
		
		private function get _view():InputArea
		{
			return viewComponent as InputArea;
		}
		
//		private function _changeHandler(evt:Event):void
//		{
//			var __index:int = inputTA.length;
//			refresh();
//			sourceTA.setFormatFromTypeIndex(__index, inputTA.right);
//		}
//		
//		private function _textInputHandler(evt:TextEvent):void
//		{
//			if(!inputTimer.running && _view.length==0)
//			//在输入文字的时候，当文字内容为空并且记时没有开始的时候才开始记时
//			{
//				inputTimer.start();
//				//在第一次输入的时候通知服务器开始计时
//				Logger.info(postURL);
//				var _var:URLVariables = new URLVariables('is_start=true&type=start');
//				Logger.info(_var.is_start);
//				var _request:URLRequest = new URLRequest(checkURL);
//				_request.data = _var;		
//				load(_request);
//				trace('当打字开始的时候提交到服务器，提交的网址checkURL:', checkURL);
//			}
//		}
//		
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