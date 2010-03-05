package model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import model.vo.InputVO;
	import model.vo.ReceiveConfigVO;
	import model.vo.SendPostVO;
	import model.vo.TimerRefreshVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import type.PostType;

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
			Timer(getData()).addEventListener(TimerEvent.TIMER, _timerHandler);
		}
		
		public function start():void
		{
			Timer(getData()).start();
			trace('TimerProxy开始计时');
		}
		
		//刷新速率
		public function refresh($vo:InputVO):void
		{
			_rightChars = $vo.rightChars;
			_curIndex = $vo.curIndex;
			_articleLength = $vo.articleLength;
//			trace('TimerProxy.refresh:', $vo);
			_calculate();
			trace('TimerProxy.refresh:',_rightChars)
		}
		
		private function _calculate():void
		{
			//_curIndex等于0的时候，也就是没有输入文字的时候，这是除数为0，不能计算，因此直接设置正确率为0
			if(_curIndex == 0)
			{
				_rightRatio = 0;
			}
			else
			{
				_rightRatio = Math.floor(_rightChars/_curIndex*1000)/10;
			}
			_percent = Math.floor(_curIndex/_articleLength*100);
//			_speed = Math.floor(inputTA.length/((time - spareTime)/1000/60));	//瞬时速度
			_speed = Math.floor(_curIndex/(_time/1000/60));	//真实速度
			sendNotification(AppFacade.TIMER_REFRESH, getTimerRefreshVO());
//			trace('TimerProxy._calculate:', getTimerRefreshVO());
		}
		
		public function getTimerRefreshVO():TimerRefreshVO
		{
			return new TimerRefreshVO(_rightRatio, _speed, _percent, _spareTime);
		}
		
		public function getSendPostVO($doneType:String):SendPostVO
		{
			var __configVO:ReceiveConfigVO = (facade.retrieveProxy(OperationProxy.NAME) as OperationProxy).getData() as ReceiveConfigVO;
			var __sendPostVO:SendPostVO = new SendPostVO();
			__sendPostVO.competition_id = __configVO.competition_id;
			__sendPostVO.module_id = __configVO.module_id;
			__sendPostVO.article_id = __configVO.article_id;
			__sendPostVO.project_id = __configVO.project_id;
			__sendPostVO.right_per = _rightRatio.toString();
			__sendPostVO.speed = _speed.toString();
			__sendPostVO.type = PostType.POST;
			__sendPostVO.done_type = $doneType;
			return __sendPostVO;
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
			//trace('还剩时间：',_spareTime/1000);
			//如果时间到，就提交用户数据给服务器保存
			if(_spareTime <= 0)
			{
				Timer(getData()).stop();
				sendNotification(AppFacade.SEND_POST, PostType.TIMER_DONE);
				trace('移除TimerProxy并停止计时!');
			}
			_calculate();
		}
		
		
	}
}