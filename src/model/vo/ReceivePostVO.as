package model.vo
{
	public class ReceivePostVO extends AbstractVO
	{
		public var is_error:Boolean;	//写入数据库是否有误true/false  
		public var next_url:Boolean;	//下一步链接
		public var show_msg:Boolean;	//最后显示信息
	}
}