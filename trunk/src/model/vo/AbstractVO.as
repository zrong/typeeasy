/**
 * 提交和返回的VO的抽象父类，只提供一个type属性
 * */
package model.vo
{
	public class AbstractVO
	{
		public static const CONFIG:String = 'config';	//这次提交是获取配置
		public static const START:String = 'start';	//这次提交是开始计时
		public static const POST:String = 'post';		//这次提交时打字完成
		
		public var type:String;
	}
}