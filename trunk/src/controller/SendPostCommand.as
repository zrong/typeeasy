package controller
{
	import model.PostProxy;
	import model.TimerProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SendPostCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __timerProxy:TimerProxy = facade.retrieveProxy(TimerProxy.NAME) as TimerProxy;
			var __doneType:String = String(notification.getBody());
			var __post:PostProxy = facade.retrieveProxy(PostProxy.NAME) as PostProxy;
			__post.send(__timerProxy.getSendPostVO( __doneType));
			//发送post之后，就取消TimerProxy的注册
			if(facade.hasProxy(TimerProxy.NAME)) facade.removeProxy(TimerProxy.NAME);
//			if(facade.hasProxy(TotalTimerProxy.NAME)) facade.removeProxy(TotalTimerProxy.NAME);
		}
	}
}