package controller
{	
	import model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.*;
	
	public class StartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new LoadConfigProxy());
			facade.registerProxy(new TypeStartProxy());
			facade.registerProxy(new TypeDoneProxy());
			TypeError
				
			var __app:TypeEasy = notification.getBody() as TypeEasy;
			facade.registerMediator(new AppMediator(__app));
			facade.registerMediator(new TypeInfo(__app.typeInfo));
			facade.registerMediator(new InputAreaMediator(__app.inputTA));
			facade.registerMediator(new SourceAreaMediator(__app.sourceTA));
		}
	}
}