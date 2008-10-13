package view
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import model.PostProxy;
	import model.TimerProxy;
	import model.vo.ReceivePostVO;
	import model.vo.SendPostVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import type.PostType;

	public class AppMediator extends Mediator
	{
		public static const NAME:String = 'AppMediator';
		private static const CALL_BACK_FUN_NAME:String = 'getSpeed';
		 
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view.addEventListener(TypeEasy.NAVIGATE_CLICK, _navigateClick);
			//让JavaScript能够调用Flash中的打字成绩信息
			if(ExternalInterface.available)	ExternalInterface.addCallback(CALL_BACK_FUN_NAME, _getSendPostVO);
		}
		
		//将打字成绩信息返回给JavaScript
		private function _getSendPostVO():SendPostVO
		{
			var __timerProxy:TimerProxy = facade.retrieveProxy(TimerProxy.NAME) as TimerProxy;
			return __timerProxy.getSendPostVO(PostType.TOTAL_TIMER_DONE);
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