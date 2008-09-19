package controller
{
	import model.TimerProxy;
	import model.TotalTimerProxy;
	import model.vo.ReceiveConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ReceiveConfigCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __vo:ReceiveConfigVO = notification.getBody() as ReceiveConfigVO;
			var __timer:TimerProxy = facade.retrieveProxy(TimerProxy.NAME) as TimerProxy;
			var __totalTimer:TotalTimerProxy = facade.retrieveProxy(TotalTimerProxy.NAME) as TotalTimerProxy;
			__timer.initTimer(__vo.time_limit);
			__totalTimer.initTimer(__vo.remain_total_time);
		}
	}
}