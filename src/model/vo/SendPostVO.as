package model.vo
{
	public class SendPostVO extends PHPVO
	{
		public var done_type:String;	//值若为inputDone，则说明是打字完毕提交;值若为timerDone，则说明是打字游戏的时间限制到了提交;值若为totalTimerDone，则说明是总考试时间到了提交
		
		override public function toString():String
		{
			return "model.vo.SendPostVO {" + super.toString() +
					', done_type:' + done_type + '}';
		}	 
	}
}