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
			facade.registerCommand(AppFacade.ERROR, ErrorCommand);
			facade.registerCommand(AppFacade.INPUT, InputCommand);
			
			var __opera:OperationProxy = new OperationProxy(); 
			facade.registerProxy(__opera);
				
			var __app:TypeEasy = notification.getBody() as TypeEasy;
			facade.registerMediator(new AppMediator(__app));
			facade.registerMediator(new TypeInfoMediator(__app.typeInfo));
			facade.registerMediator(new InputAreaMediator(__app.inputTA));
			facade.registerMediator(new SourceAreaMediator(__app.sourceTA));
			
			try
			{
				trace('调用__opera.send');
				__opera.send();
			}
			catch($err:Error)
			{
				sendNotification(AppFacade.ERROR, $err.toString(), ErrorType.ERROR);
				trace($err.getStackTrace());
			}
		}
	}
}