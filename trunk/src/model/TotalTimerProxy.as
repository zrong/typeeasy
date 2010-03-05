package model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import type.PostType;

	public class TotalTimerProxy extends Proxy
	{
		
		public static const NAME:String = 'TotalTimerProxy';
		
		private static const DELAY:Number = 1000;
		
		private var _time:int = 60000;				//限制的时间
		
		public function TotalTimerProxy(data:Object=null)
		{
			super(NAME, new Timer(DELAY));
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
			trace('移除TotalTimerProxy并停止计时');
			timer.stop();
			timer.reset();
		}
		
		public function initTimer($time:Number):void
		{
			_time = $time;
			//Flash提交必须在平台总时间到之前提交，因此减去10秒，比平台总时间提前10秒到。
			_time -= 10000;
			setData(new Timer(DELAY));
			timer.addEventListener(TimerEvent.TIMER, _timerHandler);
			start();
		}
		
		public function start():void
		{
			timer.start();
			trace('TotalTimerProxy开始计时，剩余的总时间：', _time);
		}
		
		
		private function _timerHandler(evt:TimerEvent):void
		{
			trace('TotalTimerProxy计时中，剩余的总时间：', _time);
			_time -= DELAY;
			if(_time <= 0)
			{
				timer.stop();
				timer.reset();
				sendNotification(AppFacade.SEND_POST, PostType.TOTAL_TIMER_DONE);
			}
		}
	}
}