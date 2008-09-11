package model.dao
{
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
		}
		
//		public function sendStart($url:String, $param:*):void
//		{
//			_service.url = $url;
//			var __token:AsyncToken = _service.send($param);
//			__token.addResponder(_responder);
//		}
//		
//		public function sendPost($url:String, $param:*):void
//		{
//			_service.url = $url;
//			var __token:AsyncToken = _service.send($param);
//			__token.addResponder(_responder);
//		}

	}
}