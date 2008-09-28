package type
{
	public class PostType
	{
		public static const CONFIG:String = 'config';	//这次提交是获取配置
		public static const START:String = 'start';	//这次提交是开始计时
		public static const POST:String = 'post';		//这次提交时打字完成
		
		public static const INPUT_DONE:String = 'inputDone';	//由于输入完毕提交
		public static const TIMER_DONE:String = 'timerDone';	//由于时间到了提交
		public static const TOTAL_TIMER_DONE:String = 'totalTimerDone';	//由于总时间到了提交
	}
}