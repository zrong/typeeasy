package model
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PostProxy extends Proxy
	{
		public static const NAME:String = 'PostProxy';
		
		public function PostProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
	}
}