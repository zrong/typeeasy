/**
 * 发送开始打字信息到PHP，接到PHP返回时候的VO
 * */
package model.vo
{
	public class ReceiveStartVO extends AbstractVO
	{
		public var is_error:Boolean;		//确认开始true/false（服务器记录开始时间） 
	}
}