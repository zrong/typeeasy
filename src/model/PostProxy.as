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
		private var _doneType:String;
		
		public function PostProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get vo():ReceivePostVO
		{
			return getData() as ReceivePostVO;
		}
		
		public function send($vo:SendPostVO):void
		{
			_doneType = $vo.done_type;
			var __configVO:ReceiveConfigVO = ReceiveConfigVO( OperationProxy( facade.retrieveProxy(OperationProxy.NAME) ).getData() ); 
			var __postURL:String = __configVO.post_url;
			var __delegate:HTTPDelegate = new HTTPDelegate(this);
			__delegate.send(__postURL, $vo);
			trace('当打字结束的时候提交到服务器，提交的网址__postURL:', __postURL, ',SendPostVO:', $vo);
		}
		
		public function result($data:Object):void
		{
			var __vo:ReceivePostVO = new ReceivePostVO($data.result);
			trace('打字完成结果返回：', __vo);
			if(__vo.is_error)
			{
				sendNotification(AppFacade.ERROR, '保存打字结果失败！', ErrorType.ERROR);
			}
			else
			{
				setData(__vo);
				sendNotification(AppFacade.RECEIVE_POST, __vo, _doneType);
			}
		}
		
		public function fault($info:Object):void
		{
			trace($info.fault);
			sendNotification(AppFacade.ERROR, $info.fault, ErrorType.ERROR);
		}
	}
}