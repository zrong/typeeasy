package view
{
	import cn.e21.ParametersVO;
	
	import flash.text.TextFormat;
	
	import model.vo.InputVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import type.ChangeType;
	
	import view.components.SourceArea;

	public class SourceAreaMediator extends Mediator
	{
		public static const NAME:String = 'SourceAreaMediator';
		private var _curIndex:int = 0;	//保存当前等待输入的字符的索引，1基
		
		public function SourceAreaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view.text = '正在载入文章......';
		}
		
		private function get _view():SourceArea
		{
			return viewComponent as SourceArea;
		}
		
		private function _refresh($type:String, $index:int, $rightBoolList:Array, $caretIndex:int, $articleLength:int):void
		{
			//$index是1基的
			switch($type)
			//如果当前的文字数量大于上次输入的文字数量，说明是在输入文字
			{
				case ChangeType.ADD:
					_addText($index, $rightBoolList, $caretIndex, $articleLength);
					break;
				case ChangeType.DEL_LAST:
					_delLast($index, $rightBoolList, $caretIndex, $articleLength);
					break;
				case ChangeType.DEL_SPECIAL:
					_delSpecial($index, $rightBoolList, $caretIndex, $articleLength);
					break;
				
			}
			_curIndex = $index;
			_view.setScroll($index);
		}
		
		private function _addText($index:int, $rightBoolList:Array, $caretIndex:int, $articleLength:int):void
		{
			for(var i:int=0; i<$rightBoolList.length; i++)
			{
				var _curTF:TextFormat = $rightBoolList[i] ? SourceArea.PASS_TF : SourceArea.WRONG_TF;
				if($index >= _view.length)
				//如果输入的字数与正确的字数相等，就将最后一个文字设置为已输入样式	
				{
					_view.setTextFormat(_curTF, $index+i, $articleLength);
				}
				else
				//否则就按要求设置
				{				
					
					_view.setTextFormat(_curTF, _curIndex, $index + 1);	//将已经输入的文字设置成已输入样式	
					_view.setTextFormat(SourceArea.WAIT_TF, $index, $index + 1);	//将已输入文字的后一个文字设置成待输入样式		
				}
			}
		}
		
		private function _delLast($index:int, $rightBoolList:Array, $caretIndex:int, $articleLength:int):void
		{
			_view.setTextFormat(SourceArea.NORMAL_TF, _curIndex);		//待输入的文字设置成未输入样式	
			_view.setTextFormat(SourceArea.WAIT_TF, $index);	//将删除的文字设置成待输入样式
		}
		
		private function _delSpecial($index:int, $rightBoolList:Array, $caretIndex:int, $articleLength:int):void
		{
			trace('特殊删除，$index:'+$index,'$careIndex:'+$caretIndex);
			_view.setTextFormat(SourceArea.NORMAL_TF, $index, $articleLength);
			if($index>0)_view.setTextFormat(SourceArea.WRONG_TF, $caretIndex, $index);
			_view.setTextFormat(SourceArea.WAIT_TF, $index);	//将删除的文字设置成待输入样式
		}
		override public function listNotificationInterests():Array
		{
			return	[	AppFacade.RECEIVE_CONFIG,
						AppFacade.INPUT	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case AppFacade.RECEIVE_CONFIG:
					var __config:ParametersVO = ParametersVO(notification.getBody());
					_view.text = __config.article;
					break;
				case AppFacade.INPUT:
					var __vo:InputVO = notification.getBody() as InputVO;
					_refresh(notification.getType(), __vo.curIndex, __vo.inputRight, __vo.caretIndex, __vo.articleLength);
					break;
			}
		}
	}
}