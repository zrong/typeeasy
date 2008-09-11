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
			facade.registerCommand(ApplicationFacade.ERROR, ErrorCommand);
			
			var __load:LoadConfigProxy = new LoadConfigProxy(); 
			facade.registerProxy(__load);
			facade.registerProxy(new TypeStartProxy());
			facade.registerProxy(new TypeDoneProxy());
				
			var __app:TypeEasy = notification.getBody() as TypeEasy;
			facade.registerMediator(new AppMediator(__app));
			facade.registerMediator(new TypeInfoMediator(__app.typeInfo));
			facade.registerMediator(new InputAreaMediator(__app.inputTA));
			facade.registerMediator(new SourceAreaMediator(__app.sourceTA));
			
			try
			{
				__load.getParam();
			}
			catch($err:Error)
			{
				sendNotification(ApplicationFacade.ERROR, $err.toString());
				trace($err.getStackTrace());
			}
		}
	}
}