package cn.e21
{
	import mx.utils.URLUtil;
	
	public class ParametersVO
	{
		
		public var time_limit:int=-1;
		public var remain_total_time:int=-1;
		public var topic_score:int=-1;
		public var project_id:int=-1;
		public var operation_id:String;
		public var competition_id:int=-1;
		public var module_id:int=-1;
		public var post_url:String;
		public var article:String;
		public var speed:int=-1;
		
		public function ParametersVO($obj:Object=null)
		{
			if($obj != null)
			{
				time_limit = $obj.time_limit;
				remain_total_time = $obj.remain_total_time;
				topic_score = $obj.topic_score;
				project_id = $obj.project_id;
				operation_id = $obj.operation_id;
				competition_id = $obj.competition_id;
				module_id = $obj.module_id;
				post_url = $obj.post_url;
				article = decodeURIComponent($obj.article);
				speed = $obj.speed;
			}
		}
		
		public function get hasNull():Boolean
		{
			if(time_limit == -1) return true;
			if(remain_total_time == -1) return true;
			if(topic_score == -1) return true;
			if(project_id == -1) return true;
			if(operation_id == null) return true;
			if(competition_id == -1) return true;
			if(module_id == -1) return true;
			if(post_url == null) return true;
			if(article == null) return true;
			if(speed == -1) return true;
			return false;
		}
		
		public function toString():String
		{
			return 'cn.e21.ParametersVO:{ ' +
					'time_limit:' + time_limit +
					',remain_total_time:' + remain_total_time +
					',topic_score:' + topic_score +
					',project_id:' + project_id +
					',operation_id:' + operation_id +
					',competition_id:' + competition_id +
					',module_id:' + module_id +
					',post_url:' + post_url +
					',article:' + article +
					',speed:' + speed + ' }';
		}
	}
}