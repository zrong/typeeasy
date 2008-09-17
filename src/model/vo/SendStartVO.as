/**
 * 发送开始打字信息到PHP时候的VO
 * */
package model.vo
{
	public class SendStartVO extends AbstractVO
	{
		public var is_start:String;		//确认开始true/false（服务器记录开始时间） 
		
		public function SendStartVO($is_start:Boolean, $type:String)
		{
			type = $type;
			is_start = $is_start.toString();
		}
		
		override public function toString():String
		{
			return "model.vo.SendStartVO {" + super.toString() +
					', is_start:' + is_start + '}';
		}	
	}
}