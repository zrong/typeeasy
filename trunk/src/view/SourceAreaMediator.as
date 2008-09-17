package view
{
	import model.vo.InputVO;
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
			return	[	ApplicationFacade.RECEIVE_CONFIG,
						ApplicationFacade.INPUT	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RECEIVE_CONFIG:
					var __config:ReceiveConfigVO = ReceiveConfigVO(notification.getBody());
					_view.text = __config.article;
					break;
				case ApplicationFacade.INPUT:
					var __vo:InputVO = notification.getBody() as InputVO;
					_view.setFormatFromTypeIndex(__vo.curIndex, __vo.inputRight);
					break;
			}
		}
	}
}