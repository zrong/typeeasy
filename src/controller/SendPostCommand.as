package controller
{
	import model.ConfigProxy;
	import model.PostProxy;
	import model.vo.ReceiveConfigVO;
	import model.vo.SendPostVO;
	import model.vo.TimerRefreshVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import type.PostType;

	public class SendPostCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __vo:TimerRefreshVO = notification.getBody() as TimerRefreshVO;
			
			var __post:PostProxy = facade.retrieveProxy(PostProxy.NAME) as PostProxy;
			__post.send(_buildVO(__vo));
		}
		
		private function _buildVO($vo:TimerRefreshVO):SendPostVO
		{
			var __configVO:ReceiveConfigVO = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).getData() as ReceiveConfigVO;
			var __sendPostVO:SendPostVO = new SendPostVO();
			__sendPostVO.competition_id = __configVO.competition_id;
			__sendPostVO.module_id = __configVO.module_id;
			__sendPostVO.article_id = __configVO.article_id;
			__sendPostVO.project_id = __configVO.project_id;
			__sendPostVO.right_per = $vo.rightRatio;
			__sendPostVO.speed = $vo.speed;
			__sendPostVO.type = PostType.POST;
		}
	}
}