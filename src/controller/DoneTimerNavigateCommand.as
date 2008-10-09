package controller
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import model.PostProxy;
	import model.vo.ReceivePostVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class DoneTimerNavigateCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __receivePostVO:ReceivePostVO = (facade.retrieveProxy(PostProxy.NAME) as PostProxy).vo;
			navigateToURL(new URLRequest(__receivePostVO.next_url), "_self");
		}		
	}
}