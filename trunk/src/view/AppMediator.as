package view
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
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
		}
		
		private function get _view():TypeEasy
		{
			return viewComponent as TypeEasy;
		}
		
		
		override public function listNotificationInterests():Array
		{
			return	[		];
		}
		
		override public function handleNotification(notification:INotification):void
		{

		}
	}
}