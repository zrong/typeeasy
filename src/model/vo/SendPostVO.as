package model.vo
{
	public class SendPostVO extends PHPVO
	{
		public var total_time_done:String;	//剩余的总考试时间用完。如果用户考试的时侯速度很慢，可能打字快跑开始的时候，剩余的总时间已经小于打字快跑模块的时间，因此要进行计时，总时间如果过完了，即使打字快跑模块的时间没有完，也要强制提交打字快跑成绩。
		
		override public function toString():String
		{
			return "model.vo.SendPostVO {" + super.toString() +
					', total_time_done:' + total_time_done + '}';
		}	 
	}
}