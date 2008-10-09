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
//			_delFlash(__vo.show_msg, __vo.next_url, notification.getType());
			var __doneTimer:DoneTimerProxy = facade.retrieveProxy(DoneTimerProxy.NAME) as DoneTimerProxy;
			__doneTimer.start();
		}
		
		private function _delFlash($msg:String, $url:String, $doneType:String):void
		{
			ExternalInterface.call('delFlash', $msg, $url, $doneType);
		}
	}
}