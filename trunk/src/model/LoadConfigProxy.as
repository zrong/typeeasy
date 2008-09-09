package model
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class LoadConfigProxy extends Proxy
	{
		public static const NAME:String = 'LoadConfigProxy';
		
		public function LoadConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}