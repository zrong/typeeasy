package controller
{
	import flash.external.ExternalInterface;
	
	import model.DoneTimerProxy;
	import model.vo.ReceivePostVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ReceivePostCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __vo:ReceivePostVO = notification.getBody() as ReceivePostVO;
			var __doneTimer:DoneTimerProxy = facade.retrieveProxy(DoneTimerProxy.NAME) as DoneTimerProxy;
			__doneTimer.start();
		}
		
	}
}