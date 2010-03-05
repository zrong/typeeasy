package view
{
	import cn.e21.ParametersVO;
	
	import model.vo.ReceiveConfigVO;
	import model.vo.TimerRefreshVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.TypeInfo;

	public class TypeInfoMediator extends Mediator
	{
		public static const NAME:String = 'TypeInfoMediator';
		public function TypeInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get _view():TypeInfo
		{
			return viewComponent as TypeInfo;
		}
		
		private function _refresh($vo:TimerRefreshVO):void
		{
			_view.spareTime = $vo.spareTime;
			_view.rightRatio = $vo.rightRatio;
			_view.percent = $vo.percent;
			_view.speed = $vo.speed;
		}
		
		
		override public function listNotificationInterests():Array
		{
			return	[	AppFacade.RECEIVE_CONFIG,
						AppFacade.TIMER_REFRESH	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case AppFacade.RECEIVE_CONFIG:
					var __config:ParametersVO = ParametersVO(notification.getBody());
					_view.spareTime = __config.time_limit;
					break;
				case AppFacade.TIMER_REFRESH:
					_refresh(notification.getBody() as TimerRefreshVO);
					break;
			}
		}
	}
}