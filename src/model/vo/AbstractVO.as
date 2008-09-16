/**
 * 提交和返回的VO的抽象父类，只提供一个type属性
 * */
package model.vo
{
	public class AbstractVO
	{
		public var type:String;
		
		public function toString():String
		{
			return "type:" + type;
		}
	}
}