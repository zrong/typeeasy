package model.vo
{
	public class TimerRefreshVO
	{
		public var rightRatio:Number;
		public var percent:Number;
		public var speed:Number;
		public var spareTime:Number;
		
		public function TimerRefreshVO($rightRatio:Number, $speed:Number, $percent:Number, $spareTime:Number)
		{
			rightRatio = $rightRatio;
			speed = $speed;
			percent = $percent;
			spareTime = $spareTime;
		}
		
		public function toString():String
		{
			return "model.vo.TimerRefreshVO {" + 
			' rightRatio:' + rightRatio +
			', percent:' + percent +
			', speed:' + speed +			
			', spareTime:' + spareTime + '}';
		}	

	}
}