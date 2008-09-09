package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.InputArea;

	public class InputAreaMediator extends Mediator
	{
		public static const NAME:String = 'InputAreaMediator';
		public function InputAreaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get _view():InputArea
		{
			return viewComponent as InputArea;
		}
	}
}