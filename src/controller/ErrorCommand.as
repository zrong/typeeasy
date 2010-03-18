package controller
{
	import mx.controls.Alert;
	import mx.core.Application;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import type.ErrorType;

	public class ErrorCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getType())
			{
				case ErrorType.ALERT:
					_sendAlert(notification.getBody().toString());
					break;
				case ErrorType.FLASH_ALERT:
					_sendFlashAlert(notification.getBody().toString());
					break;
				case ErrorType.ERROR:
					_sendError(notification.getBody().toString());
					break;
				case ErrorType.FLASH_ERROR:
					_sendFlashError(notification.getBody().toString());
					break;
			}
			
		}
		
		private function _sendFlashAlert($info:String):void
		{
			Alert.show($info, '信息');
		}
		
		private function _sendFlashError($info:String):void
		{
			Application.application.removeAllChildren();
			//sendNotification(ApplicationFacade.VS_CHANGE, VSMediator.ERROR);
			Alert.show($info, '錯誤');
		}
		
		private function _sendAlert($info:String):void
		{
//			JS.alert($info, '信息');
			_sendFlashAlert($info);
		}
		
		private function _sendError($error:String):void
		{
			Application.application.removeAllChildren();
//			JS.alert($error,'錯誤');
			Alert.show($error, '錯誤');
		}
	}
}