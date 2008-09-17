/**
 * 发生INPUT事件的时候，用这个vO传递信息
 * */
package model.vo
{
	public class InputVO
	{
		public var curIndex:int;		//当前输入的是第几个字
		public var inputRight:Boolean;	//当前输入的这个字是否正确
		public var rightChars:int;		//已经输入的文字中，输入正确的文字数量
		public var articleLength:int;	//文章所有字数
		
		public function InputVO($curIndex:int, $inputRight:Boolean, $rightChars:int, $articleLength:int)
		{
			curIndex = $curIndex;
			inputRight = $inputRight;
			rightChars = $rightChars;
			articleLength = $articleLength;
		}
		
		public function toString():String
		{
			return "model.vo.InputChangeVO {" +
					', curIndex:' + curIndex +
					', inputRight:' + inputRight +
					', rightChars:' + rightChars +
					', articleLength:' + articleLength + '}';
		}	

	}
}