package model.dao
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class HTTPDelegate
	{
		private var _responder:IResponder;
		private var _service:HTTPService;
		
		public function HTTPDelegate($responder:IResponder)
		{
			_responder = $responder;
			_service = new HTTPService();
			_service.method = URLRequestMethod.POST;
			_service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
		}
		
		public function send($url:String, $param:*):void
		{
			_service.url = $url;
			var __token:AsyncToken = _service.send($param);
			__token.addResponder(_responder);
			//词句为调试用
			load($url, $param);
			
		}
		
		private function load($url:String, $param:*):void
		{
			var __loader:URLLoader = new URLLoader();
			__loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			__loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			__loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			var __request:URLRequest = new URLRequest($url);
			__request.data = $param;
			__loader.load(__request);
		}
		
		
		//下面的几个函数，包括loader对象，都是调试的作用，可以删除
		//===========================================
		//	loadCompleteHandler()
		//===========================================

		private function loadCompleteHandler(evt:Event):void
		{
			trace('==调试用loadCompleteHandler:'+evt.toString());
			trace('==调试用evt.target.data:'+evt.target.data);
		}

		//===========================================
		//	httpStatusHandler()
		//===========================================
		
		private function httpStatusHandler(evt:HTTPStatusEvent):void
		{
			trace('==调试用HTTPStatusHandler:'+evt.toString());
			trace(evt.status);
		}
		
		//===========================================
		//	ioErrorHandler()
		//===========================================
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace('==调试用ioErrorhandler:'+ evt.toString());
			trace(evt.text);	
		}

	}
}