package cn.e21
{
	import com.adobe.serialization.json.*;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class Operation
	{
		public static const OPERATE_DONE:String = 'operateDone';
		public static const TIMER_DONE:String = 'timerDone';
		public static const TOTAL_TIMER_DONE:String = 'totalTimerDone';
		
		private var _loader:URLLoader;
		private var _limitTimer:Timer;
		private var _totalTimer:Timer;
		private var _p:ParametersVO;
		
		public var getScore:Function;
		public var showTime:Function;
		
		private static var INSTANCE:Operation;
		
		function Operation($parameters:Object, $single:SingletonClass)
		{
			if($single == null) throw new Error('Operation为单例模式，请使用getInstance方法获取实例。');
			
			_p = new ParametersVO($parameters);
			_limitTimer = new Timer(1000, _p.time_limit);
			_limitTimer.addEventListener(TimerEvent.TIMER, limitTimer_Handler);
			_limitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, limitTimer_completeHandler);
			_totalTimer = new Timer(_p.remain_total_time*1000, 1);
			_totalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, totalTimer_completeHandler);
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			_loader.addEventListener(Event.COMPLETE, submitCompleteHandler);
			trace('外部变量：', _p);
			
			_limitTimer.start();
			_totalTimer.start();
		}
		
		public static function getInstance($parameters:Object):Operation
		{
			if(INSTANCE == null) INSTANCE = new Operation($parameters, new SingletonClass()); 
			return INSTANCE;
		}
		
		public function get parameters():ParametersVO
		{
			return _p; 
		}
		
		private function getJson($doneType:String):String
		{
			var __obj:Object = new Object();
			__obj.type = 'post';
			__obj.score = getScore.call();
			__obj.operation_id = _p.operation_id;
			__obj.project_id = _p.project_id;
			__obj.competition_id = _p.competition_id;
			__obj.module_id = _p.module_id;
			__obj.done_type = $doneType;
			return  JSON.encode(__obj);
		}
		
		public function submit($doneType:String ='operateDone'):void
		{
			try
			{
				trace('Flash提供的参数：', _p);
				trace('限制时间当前count：',_limitTimer.currentCount, ',总限制时间当前conunt：', _totalTimer.currentCount);
				var __var:URLVariables = new URLVariables();
				__var.requestData = getJson($doneType);
				
				var __request:URLRequest = new URLRequest();
				__request.method = 'POST';
				__request.url = _p.post_url;
				__request.data = __var;
				
				_loader.load(__request);
				
				_limitTimer.removeEventListener(TimerEvent.TIMER, limitTimer_Handler);
				_limitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, limitTimer_completeHandler);
				_totalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, totalTimer_completeHandler);
				_limitTimer.stop();
				_totalTimer.stop();
				
				
				trace('提交的地址：' ,__request.url);
				trace('提交的值：' ,__request.data.requestData);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
				alert(err.message);
			}			
		}
		
		private function limitTimer_Handler(evt:TimerEvent):void
		{
			try
			{
				showTime.call(null, _p.time_limit-_limitTimer.currentCount);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
				alert('showTime函数未定义！'+err.message);
			}
		}
		
		private function limitTimer_completeHandler(evt:TimerEvent):void
		{
			submit(TIMER_DONE);
		}
		
		private function totalTimer_completeHandler(evt:TimerEvent):void
		{
			submit(TOTAL_TIMER_DONE);
		}
				
		private function submitCompleteHandler(evt:Event):void
		{
			try
			{
				trace('返回的值：', _loader.data.responseData);
				var __obj:Object = JSON.decode(_loader.data.responseData);
				trace('JSON解析后的is_error值：', __obj.is_error);
				trace('JSON解析后的is_error类型：', typeof(__obj.is_error));
				trace('JSON解析后的show_msg值：', __obj.show_msg);
				trace('JSON解析后的done_url值：', __obj.done_url);
				if(__obj.is_error)
				{
					alert('操作题提交出现错误：'+__obj.show_msg);
					navigateToURL(new URLRequest(__obj.done_url), '_self');
				}
				else
				{
					navigateToURL(new URLRequest(__obj.done_url), "_self");
				}
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
				alert('JSON解析提交返回的结果失败，失败信息：' +err.message+'\r返回的值：'+_loader.data);
			}
			
		}
		
		private function alert($msg:String):void
		{
			ExternalInterface.call('alert',$msg);
		}
	}
}
class SingletonClass{}