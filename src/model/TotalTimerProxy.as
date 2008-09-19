package model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import model.vo.InputVO;
	import model.vo.TimerRefreshVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class TotalTimerProxy extends Proxy
	{
		
		public static const NAME:String = 'TotalTimerProxy';
		
		private static const DELAY:Number = 1000;
		
		private var _time:int = 60000;				//限制的时间
		private var _spareTime:Number = _time;		//剩余时间
		
		public function TotalTimerProxy(data:Object=null)
		{
			super(NAME, new Timer(DELAY));
		}
		
		public function get running():Boolean
		{
			return Timer(getData()).running;
		}
		
		override public function onRemove():void
		{
			trace('移除TotalTimerProxy并停止计时');
			Timer(getData()).stop();
			Timer(getData()).reset();
		}
		
		public function initTimer($time:Number):void
		{
			_time = $time;
			_spareTime = _time;
			setData(new Timer(DELAY, _time));
			Timer(getData()).addEventListener(TimerEvent.TIMER_COMPLETE, _timerCompleteHandler);
			start();
		}
		
		public function start():void
		{
			Timer(getData()).start();
			trace('TimerProxy开始计时');
		}
		
		/**
		 * 时间到的时侯提交
		 * */
		private function _timerCompleteHandler(evt:TimerEvent):void
		{
			trace('总时间到！');
			Timer(getData()).stop();
			//在剩余的全部时间到了之后，不管打字的时间到没到，强制提交
			sendNotification(ApplicationFacade.SEND_POST, null, 'true');
		}
		
		
	}
}