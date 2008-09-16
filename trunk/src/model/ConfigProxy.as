package model
{
	import flash.net.URLVariables;
	
	import model.dao.HTTPDelegate;
	import model.vo.ReceiveConfigVO;
	
	import mx.core.Application;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import type.ErrorType;
	import type.PostType;

	public class ConfigProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'ConfigProxy';
		
		public static var CONFIG_URL:String;
		
		public function ConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function getParam():void
		{
			var __param:Object = Application.application.parameters;
			if(__param.config == null)
			{
				throw new Error('非法调用！');
			}
			CONFIG_URL = __param.config;
			var __delegate:HTTPDelegate = new HTTPDelegate(this);
			__delegate.send(CONFIG_URL, buildVariable(__param));
		}
		
		/**
		 * 从flashVar中获取变量值，然后提交给PHP
		 * */
		private function buildVariable($param:*):URLVariables
		{
			var __var:URLVariables = new URLVariables();
			__var.type = PostType.CONFIG;
			//把除config之外的参数放在var中
			for(var i:String in $param)
			{
				if(i != PostType.CONFIG)
				{
					__var[i] = $param[i];
				}
			}
			trace('LoadConfigProxy.buildVariable:', __var);
			return __var;
		}
		
		public function result($data:Object):void
		{
			var __vo:ReceiveConfigVO = new ReceiveConfigVO($data.result);
			trace(__vo);
			if(__vo.is_error)
			{
				sendNotification(ApplicationFacade.ERROR, '读取试卷信息错误！', ErrorType.ERROR);
			}
			else
			{
				setData(__vo);
				sendNotification(ApplicationFacade.RECEIVE_CONFIG, __vo);
			}
		}
		
		public function fault($info:Object):void
		{
			trace($info.fault);
			sendNotification(ApplicationFacade.ERROR, $info.fault);
		}		
	}
}