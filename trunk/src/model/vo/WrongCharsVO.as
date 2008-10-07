//保存输入的文字与正确的文字比较后的错误文字相对索引数组与对应的布尔值数组
package model.vo
{
	public class WrongCharsVO
	{
		public var wrongIndexList:Array;	//如果比较的时候有错误，将错误的文字的相对索引保存在此数组中
		public var boolList:Array;	//将比较时错误与正确的情况转换成布尔值保存在此数组中，如果是正确的，布尔值为true
		public function WrongCharsVO($wrongIndexList:Array, $boolList:Array)
		{
			wrongIndexList = $wrongIndexList;
			boolList = $boolList;
		}
	}
}