package view
{
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
	}
}