package model
{
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class StartProxy extends Proxy
	{
		public static const NAME:String = 'StartProxy';
		
		public function StartProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}