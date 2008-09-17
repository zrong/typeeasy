package controller
{
	import model.StartProxy;
	import model.TimerProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SendStartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __timer:TimerProxy = facade.retrieveProxy(TimerProxy.NAME) as TimerProxy;
			var __start:StartProxy = facade.retrieveProxy(StartProxy.NAME) as StartProxy;
			
			//在第一次输入的时候通知服务器开始计时
			if(!__timer.running)
			{
				__start.send();
				__timer.start();
			}
		}
	}
}