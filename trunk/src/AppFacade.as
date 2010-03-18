package
{
	import controller.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class AppFacade extends Facade
	{
		public static const STARTUP:String = 'startup';
		public static const ERROR:String = 'error';
		
		public static const RECEIVE_CONFIG:String = 'receiveConfig';	
		
		public static const INPUT:String = 'inputChange';
		
		public static const TIMER_REFRESH:String = 'timerRefresh';
		
		public static function getInstance():AppFacade
		{
			if(instance == null) instance = new AppFacade();
			return instance as AppFacade;
		}
		
		public function startup(app:Object):void
		{
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand( STARTUP, StartupCommand );
		}
		
	}
}