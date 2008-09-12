package model.vo
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class TimerProxy extends Proxy
	{
		
		public static const NAME:String = 'TimerProxy';
		
		private static const DELAY:Number = 100;
		
		private var _time:int = 60000;	//限制的时间
		private var _spareTime:Number = _time;
		private var _rightRatio:Number;
		private var _percent:Number;
		private var _speed:Number;
		
		public function TimerProxy(data:Object=null)
		{
			super(NAME, new Timer(DELAY, _time));
		}
		
//		private function initTimer():void
//		{
//			setData(new Timer(DELAY, time));
//			Timer(getData()).addEventListener(TimerEvent.TIMER.TIMER, _timerHandler);
//		}
//		
//		private function reset():void
//		{
//			spareTime = time;
//			rightRatio = 0;
//			percent = 0;
//			speed = 0;
//			inputTA.reset();
//			sourceTA.reset();
//			inputTA.setFocus();
//			inputTimer.stop();
//			inputTimer.reset();
//			inputTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
//		}
//		
//		/**
//		 * 时间到的时侯提交
//		 * */
//		private function _timerHandler(evt:TimerEvent):void
//		{
//			spareTime -= DELAY;
//			//trace('还剩时间：',spareTime/1000);
//			//如果时间到，就提交用户数据给服务器保存
//			if(spareTime <= 0)
//			{
//				inputTimer.stop();
//				inputTA.editable = false;
//				var _urlvar:URLVariables = new URLVariables();
//				_urlvar.competition_id = configXML.competition_id.toString();
//				_urlvar.module_id = configXML.module_id.toString();
//				_urlvar.article_id = configXML.article_id.toString();
//				_urlvar.project_id = configXML.project_id.toString();
//				_urlvar.right_per = rightRatio;
//				_urlvar.speed = speed;
//				_urlvar.type = 'post';		
//				var _request:URLRequest = new URLRequest(postURL);
//				_request.data = _urlvar;
//				load(_request);
//				//reset();		
//			}
//			refresh();
//		}
		
		
	}
}