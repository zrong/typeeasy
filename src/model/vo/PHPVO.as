/**
 * 要与PHP共享的提交或返回的VO的父类
 * */
package model.vo
{
	public class PHPVO extends AbstractVO
	{
		public var project_id:String;		//项目id
		public var competition_id:String;	//竞赛id 
		public var module_id:String;		//模块id 
		public var article_id:String;		//对应题目id
		public var right_per:String;		//正确率（百分数） 
		public var speed:String;			//速度（字数/分钟）
	}
}