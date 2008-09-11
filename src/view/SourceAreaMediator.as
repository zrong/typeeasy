package view
{
	import model.vo.ReceiveConfigVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.SourceArea;

	public class SourceAreaMediator extends Mediator
	{
		public static const NAME:String = 'SourceAreaMediator';
		
		public function SourceAreaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view.text = '正在载入文章......';
		}
		
		private function get _view():SourceArea
		{
			return viewComponent as SourceArea;
		}
		
		override public function listNotificationInterests():Array
		{
			return	[	ApplicationFacade.RECEIVE_CONFIG	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RECEIVE_CONFIG:
					var __config:ReceiveConfigVO = ReceiveConfigVO(notification.getBody());
					_view.text = __config.article;
					break;
			}
		}
	}
}