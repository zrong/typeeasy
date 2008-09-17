package
{
	import controller.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String = 'startup';
		public static const ERROR:String = 'error';
		
		public static const RECEIVE_CONFIG:String = 'receiveConfig';
		public static const RECEIVE_START:String = 'receiveStart';
		public static const RECEIVE_POST:String = 'receivePOST';
		
		public static const SEND_START:String = 'sendStart';
		public static const SEND_POST:String = 'sendPost';
		
		public static const INPUT:String = 'inputChange';
		
		public static const TIMER_REFRESH:String = 'timerRefresh';
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
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