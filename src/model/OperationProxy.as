package model
{
	import cn.e21.Operation;
	import cn.e21.ParametersVO;
	
	import flash.external.ExternalInterface;
	
	import model.vo.InputVO;
	import model.vo.TimerRefreshVO;
	
	import mx.core.Application;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class OperationProxy extends Proxy
	{
		public static const NAME:String = 'OperationProxy';
		
		private var opera:Operation;
		
		private var _time:int = 60000;				//限制的时间
		private var _spareTime:Number = _time;		//剩余时间
		private var _rightRatio:Number = 0;			//正确率
		private var _percent:Number = 0;			//剩余百分比
		private var _speed:Number = 0;				//打字速度
		
		private var _rightChars:int;
		private var _curIndex:int;
		private var _articleLength:int;
		
		public function OperationProxy()
		{
			opera = Operation.getInstance(Application.application.parameters);
			opera.getScore = getScore;
			opera.showTime = showTime;
			
			super(NAME, opera.parameters);
			
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback('rightClick', function():void{});
			}
		}
		
		public function get dataVO():ParametersVO
		{
			return getData() as ParametersVO;
		}
		
		/*
		用于显示本题还剩多少时间，每秒钟，会调用这个函数一次，以更新剩余的时间，
		$time参数传来的值，就是剩余的秒数，函数内的内容可由题目作者修改
		*/
		public function showTime($time:int):void
		{
			_spareTime = $time;
			calculate();
		}
		
		/*
		用于返回最新的分数，提交的时候和时间到的时候，都会调用这个函数获取最新的得分
		150这个值应该是可变的，对于不同的题目，作者自定的满分值是不同的
		这个150就是本题作者自定的满分，用得分除以自定满分获得本题的得分比例，再乘以本题的真实满分
		获得本地的真实得分
		函数内的内容可由题目制作者修改
		*/
		public function getScore():int
		{
			if( (_rightRatio*_speed/100) >= dataVO.speed ) return dataVO.topic_score;			
			return Math.round( (_rightRatio*_speed/100/dataVO.speed) * dataVO.topic_score);
		}
		
		public function send():void
		{
			if(dataVO.hasNull)
			{
				throw new Error('非法调用！');
			}
			else
			{
				initTimer();
				sendNotification(AppFacade.RECEIVE_CONFIG, dataVO);
			}
		}
		
		private function initTimer():void
		{
			_time = dataVO.time_limit;
			_spareTime = _time;
			_rightRatio = 0;
			_speed = 0;
			_percent = 0;
		}
		
		
		//刷新速率
		public function refresh($vo:InputVO):void
		{
			_rightChars = $vo.rightChars;
			_curIndex = $vo.curIndex;
			_articleLength = $vo.articleLength;
			trace(getProxyName(), '.refresh InputVO:', $vo);
			calculate();
			trace(getProxyName(),'.refresh _rightChars:', _rightChars);
		}
		
		private function calculate():void
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
			_speed = Math.floor(_curIndex/(_time/60));	//真实速度
			sendNotification(AppFacade.TIMER_REFRESH, getTimerRefreshVO());
//			trace('TimerProxy.calculate:', getTimerRefreshVO());
		}
		
		public function getTimerRefreshVO():TimerRefreshVO
		{
			return new TimerRefreshVO(_rightRatio, _speed, _percent, _spareTime);
		}
	}
}