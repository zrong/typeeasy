package model.vo
{
	public class ReceivePostVO extends AbstractVO
	{
		public var is_error:Boolean;	//写入数据库是否有误true/false  
		public var next_url:String;	//下一步链接
		public var show_msg:String;	//最后显示信息
		
		public function ReceivePostVO($xml:XML)
		{
			is_error = ($xml.is_error == 'true');
			next_url = $xml.next_url;
			show_msg = $xml.show_msg;
		}
		
		override public function toString():String
		{
			return "model.vo.ReceivePostVO {" + super.toString() +
					', is_error:' + is_error +
					', next_url:' + next_url +
					', show_msg:' + show_msg + '}';
		}	
	}
}