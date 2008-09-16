package model.vo
{
	public class ReceiveConfigVO extends PHPVO
	{
		public var is_error:Boolean;		//是否出错
		public var article:String;		//文章内容
		public var time_limit:Number;	//时间限制
		public var check_url:String;	//中间确认页面地址
		public var post_url:String;		//提交页面地址
		public var remain_total_time:Number;	//剩余的总考试时间。如果用户考试的时侯速度很慢，可能打字快跑开始的时候，剩余的总时间已经小于打字快跑模块的时间，因此要进行计时，总时间如果过完了，即使打字快跑模块的时间没有完，也要强制提交打字快跑成绩。
		
		public function ReceiveConfigVO($xml:XML)
		{
			is_error = ($xml.is_error == 'true');
			type = $xml.type;
			project_id = $xml.project_id;
			competition_id = $xml.competition_id;
			module_id = $xml.module_id;
			article_id	= $xml.article_id;
			right_per = $xml.right_per; 
			speed = $xml.speed;
			time_limit = Number($xml.time_limit);
			check_url = $xml.check_url;
			post_url = $xml.post_url;
			remain_total_time = Number($xml.remain_total_time);	
			article = $xml.article;	
		}
		
		override public function toString():String
		{
			return "model.vo.ReceiveConfigVO {" + super.toString() +
					', is_error:' + is_error +
					', article:' + article +
					', time_limit:' + time_limit +
					', check_url:' + check_url +
					', post_url:' + post_url +
					', remain_total_time:' + remain_total_time + '}';
		}	
	}
}