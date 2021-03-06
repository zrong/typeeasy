package model
{
	import model.dao.HTTPDelegate;
	import model.vo.ReceiveConfigVO;
	import model.vo.ReceiveStartVO;
	import model.vo.SendStartVO;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import type.ErrorType;
	import type.PostType;

	public class StartProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'StartProxy';
		
		public function StartProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function send():void
		{
			
			var __vo:SendStartVO = new SendStartVO(true, PostType.START);
			var __checkURL:String = ReceiveConfigVO(OperationProxy(facade.retrieveProxy(OperationProxy.NAME)).getData()).check_url;
			var __delegate:HTTPDelegate = new HTTPDelegate(this);
			__delegate.send(__checkURL, __vo);
			trace('当打字开始的时候提交到服务器，提交的网址__checkURL:', __checkURL);
		}
		
		public function result($data:Object):void
		{
			var __vo:ReceiveStartVO = new ReceiveStartVO($data.result);
			trace(__vo);
			if(__vo.is_error)
			{
				sendNotification(AppFacade.ERROR, '计时失败！', ErrorType.ERROR);
			}
			else
			{
				setData(__vo);
				sendNotification(AppFacade.RECEIVE_START, __vo);
			}
		}
		
		public function fault($info:Object):void
		{
			trace('startProxy调用失败', $info.fault);
//			sendNotification(ApplicationFacade.ERROR, $info.fault, ErrorType.ERROR);
		}
		
	}
}