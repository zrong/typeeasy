package model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import model.vo.InputVO;
	import model.vo.TimerRefreshVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class TimerProxy extends Proxy
	{
		
		public static const NAME:String = 'TimerProxy';
		
		private static const DELAY:Number = 100;
		
		private var _time:int = 60000;				//限制的时间
		private var _spareTime:Number = _time;		//剩余时间
		private var _rightRatio:Number = 0;			//正确率
		private var _percent:Number = 0;			//剩余百分比
		private var _speed:Number = 0;				//打字速度
		
		private var _rightChars:int;
		private var _curIndex:int;
		private var _articleLength:int;
		
		public function TimerProxy(data:Object=null)
		{
			super(NAME, new Timer(DELAY));
		}
		
		public function get running():Boolean
		{
			return Timer(getData()).running;
		}
		
		public function startTimer():void
		{
			Timer(getData()).start();
		}
		
		override public function onRemove():void
		{
			Timer(getData()).stop();
			Timer(getData()).reset();
		}
		
		public function initTimer($time:Number):void
		{
			_time = $time;
			_spareTime = _time;
			_rightRatio = 0;
			_speed = 0;
			_percent = 0;
			setData(new Timer(DELAY, _time));
			Timer(getData()).addEventListener(TimerEvent.TIMER.TIMER, _timerHandler);
		}
		
		public function start():void
		{
			Timer(getData()).start();
		}
		
		//刷新速率
		public function refresh($vo:InputVO):void
		{
			_rightChars = $vo.rightChars;
			_curIndex = $vo.curIndex;
			_articleLength = $vo.articleLength;
			_calculate();
		}
		
		private function _calculate():void
		{
			_rightRatio = Math.floor(_rightChars/_curIndex*1000)/10;
			_percent = Math.floor(_curIndex/_articleLength*100);
			//_speed = Math.floor(inputTA.length/((time - spareTime)/1000/60));	//瞬时速度
			_speed = Math.floor(_curIndex/(_time/1000/60));	//真实速度
			sendNotification(ApplicationFacade.TIMER_REFRESH, _getTimerRefreshVO());
		}
		
		private function _getTimerRefreshVO():TimerRefreshVO
		{
			return new TimerRefreshVO(_rightRatio, _speed, _percent, _spareTime);
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
		/**
		 * 时间到的时侯提交
		 * */
		private function _timerHandler(evt:TimerEvent):void
		{
			_spareTime -= DELAY;
			//trace('还剩时间：',spareTime/1000);
			//如果时间到，就提交用户数据给服务器保存
			if(_spareTime <= 0)
			{
				Timer(getData()).stop();
				sendNotification(ApplicationFacade.SEND_POST, _getTimerRefreshVO());
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
				//reset();		
			}
			_calculate();
		}
		
		
	}
}