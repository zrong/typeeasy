package model.vo
{
	public class ReceiveConfigVO extends PHPVO
	{
		public var is_error:String;		//是否出错
		public var article:String;		//文章内容
		public var time_limit:String;	//时间限制
		public var check_url:String;	//中间确认页面地址
		public var post_url:String;		//提交页面地址
		public var remain_total_time:String;	//剩余的总考试时间。如果用户考试的时侯速度很慢，可能打字快跑开始的时候，剩余的总时间已经小于打字快跑模块的时间，因此要进行计时，总时间如果过完了，即使打字快跑模块的时间没有完，也要强制提交打字快跑成绩。 
	}
}