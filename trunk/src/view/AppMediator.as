package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AppMediator extends Mediator
	{
		public static const NAME:String = 'AppMediator';
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get _view():TypeEasy
		{
			return viewComponent as TypeEasy;
		}
	}
}