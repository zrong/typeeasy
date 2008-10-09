package view
{
	import flash.events.Event;
	
	import model.PostProxy;
	import model.vo.ReceivePostVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AppMediator extends Mediator
	{
		public static const NAME:String = 'AppMediator';
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view.addEventListener(TypeEasy.NAVIGATE_CLICK, _navigateClick);
		}
		
		private function get _view():TypeEasy
		{
			return viewComponent as TypeEasy;
		}
		
		private function _navigateClick(evt:Event):void
		{
			sendNotification(ApplicationFacade.DONE_TIMER_NAVIGATE);
		}
		
		override public function listNotificationInterests():Array
		{
			return	[	ApplicationFacade.RECEIVE_POST,
						ApplicationFacade.DONE_TIMER	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RECEIVE_POST:
					var __receivePostVO:ReceivePostVO = (facade.retrieveProxy(PostProxy.NAME) as PostProxy).vo;
					_view.setInfo(__receivePostVO.show_msg);
					break;
				case ApplicationFacade.DONE_TIMER:
					var __count:String = String(notification.getBody());
					_view.setTimerInfo(__count);
					break;
			}
		}
	}
}