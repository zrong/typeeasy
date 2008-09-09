package model
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class TypeDoneProxy extends Proxy
	{
		public static const NAME:String = 'TypeDoneProxy';
		
		public function TypeDoneProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}