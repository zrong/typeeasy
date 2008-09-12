package controller
{	
	import model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import type.ErrorType;
	
	import view.*;
	
	public class StartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(ApplicationFacade.ERROR, ErrorCommand);
			
			var __load:ConfigProxy = new ConfigProxy(); 
			facade.registerProxy(__load);
			facade.registerProxy(new StartProxy());
			facade.registerProxy(new PostProxy());
				
			var __app:TypeEasy = notification.getBody() as TypeEasy;
			facade.registerMediator(new AppMediator(__app));
			facade.registerMediator(new TypeInfoMediator(__app.typeInfo));
			facade.registerMediator(new InputAreaMediator(__app.inputTA));
			facade.registerMediator(new SourceAreaMediator(__app.sourceTA));
			
			try
			{
				trace('调用getParam');
				__load.getParam();
			}
			catch($err:Error)
			{
				sendNotification(ApplicationFacade.ERROR, $err.toString(), ErrorType.ERROR);
				trace($err.getStackTrace());
			}
		}
	}
}