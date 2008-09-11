package model
{
	import flash.net.URLVariables;
	
	import model.dao.HTTPDelegate;
	import model.vo.AbstractVO;
	import model.vo.ReceiveConfigVO;
	
	import mx.core.Application;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class LoadConfigProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'LoadConfigProxy';
		
		public static var CONFIG_URL:String;
		public static var POST_URL:String;
		public static var CHECK_URL:String;
		
		public function LoadConfigProxy(data:Object=null)
		{
			super(NAME, new ReceiveConfigVO());
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
		
		private function buildVariable($param:*):URLVariables
		{
			var __var:URLVariables = new URLVariables();
			__var.type = AbstractVO.CONFIG;
			//把除config之外的参数放在var中
			for(var i:String in $param)
			{
				if(i != 'config')
				{
					__var[i] = $param[i];
				}
			}
			trace('LoadConfigProxy.buildVariable:', __var);
			return __var;
		}
		
		public function result($data:Object):void
		{
			trace($data.toString());
		}
		
		public function fault($fault:Object):void
		{
			trace($fault.toString());
		}
		
	}
}