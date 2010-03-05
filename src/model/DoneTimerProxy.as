package model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DoneTimerProxy extends Proxy
	{
		
		public static const NAME:String = 'DoneTimerProxy';
		
		private static const DELAY:Number = 1000;
		private static const TIME:int = 5;
		
		public function DoneTimerProxy(data:Object=null)
		{
			super(NAME, new Timer(DELAY, TIME));
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, _timerCompleteHandler);
			timer.addEventListener(TimerEvent.TIMER, _timerHandler);
		}
		
		public function get timer():Timer
		{
			return getData() as Timer;
		}
		
		public function get running():Boolean
		{
			return timer.running;
		}
		
		override public function onRemove():void
		{
			trace('移除DoneTimerProxy并停止计时');
			timer.stop();
			timer.reset();
		}
		
		public function start():void
		{
			timer.start();
			sendNotification(AppFacade.DONE_TIMER, TIME);
			trace('DoneTimerProxy开始计时');
		}
		
		private function _timerHandler(evt:TimerEvent):void
		{
			sendNotification(AppFacade.DONE_TIMER, TIME-timer.currentCount);
		}
		
		/**
		 * 时间到的时侯提交
		 * */
		private function _timerCompleteHandler(evt:TimerEvent):void
		{
			trace('跳转时间到！');
			timer.stop();
			//在剩余的全部时间到了之后，不管打字的时间到没到，强制提交
			sendNotification(AppFacade.DONE_TIMER_NAVIGATE);
		}
		
		
	}
}