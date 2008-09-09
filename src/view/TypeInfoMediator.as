package view
{
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
	}
}