package model
{
	import model.dao.HTTPDelegate;
	import model.vo.ReceiveConfigVO;
	import model.vo.ReceivePostVO;
	import model.vo.SendPostVO;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import type.ErrorType;

	public class PostProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'PostProxy';
		
		public function PostProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function send($vo:SendPostVO):void
		{
			var __postURL:String = ReceiveConfigVO( ConfigProxy( facade.retrieveProxy(ConfigProxy.NAME) ).getData() ).post_url;
			var __delegate:HTTPDelegate = new HTTPDelegate(this);
			__delegate.send(__postURL, $vo);
			trace('当打字结束的时候提交到服务器，提交的网址__postURL:', __postURL);
		}
		
		public function result($data:Object):void
		{
			var __vo:ReceivePostVO = new ReceivePostVO($data.result);
			trace(__vo);
			if(__vo.is_error)
			{
				sendNotification(ApplicationFacade.ERROR, '保存打字结果失败！', ErrorType.ERROR);
			}
			else
			{
				setData(__vo);
				sendNotification(ApplicationFacade.RECEIVE_POST, __vo);
			}
		}
		
		public function fault($info:Object):void
		{
			trace($info.fault);
			sendNotification(ApplicationFacade.ERROR, $info.fault);
		}
	}
}