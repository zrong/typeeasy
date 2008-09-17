package controller
{
	import model.TimerProxy;
	import model.vo.InputVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class InputCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __vo:InputVO = notification.getBody() as InputVO;
			var __timer:TimerProxy = facade.retrieveProxy(TimerProxy.NAME) as TimerProxy;
			
			__timer.refresh(__vo);
		}
	}
}