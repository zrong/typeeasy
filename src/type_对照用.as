// ActionScript file
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.TextEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.utils.Timer;

import mx.core.Application;

import net.zengrong.logging.Logger;

private var loader:URLLoader;
private var time:int = 60000;	//限制的时间
private const DELAY:Number = 100;
private var inputTimer:Timer;
private var postURL:String;	//提交数据的php地址
private var checkURL:String;	//检测时间开始的php地址
private var configXML:XML;	//保存第一次获取的XML

[Bindable]
private var article:String = '正在载入文章......';
[Bindable]
private var spareTime:Number = time;	//剩余时间
[Bindable]
private var rightRatio:Number = 0;	//正确率
[Bindable]
private var percent:Number =0;	//完成度
[Bindable]
private var speed:Number =0;	//打字速度

private function init():void
{
	Logger.includeLevel = true;
	loader = new URLLoader();
	loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
	loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);	
	initNet();
}

//===========================================
//
//	实例方法 侦听器类
//
//==========================================

//===========================================
//	loadCompleteHandler()
//===========================================

private function loadCompleteHandler(evt:Event):void
{
	Logger.info('loadCompleteHandler:'+evt.toString());
	Logger.info('evt.target.data:'+evt.target.data);
	try
	{
		var _xml:XML = XML(evt.target.data);
		try
		{
			loadTest(_xml);
		}
		catch(err:Error)
		{
			alert(err.toString());
		}
	}
	catch(err:Error)
	{
		alert('无法转换成XML类型:'+err.toString());
		//reset();
	}	
	Logger.info('_xml:'+_xml.toString());
	switch(_xml.type.toString())
	{
		case 'config':
			configXML = _xml; 
			loadConfig(_xml);
			break;
		case 'start':
			loadStart(_xml);
			break;
		case 'post':
			loadPost(_xml);
			break;
	}
}

//===========================================
//	httpStatusHandler()
//===========================================

private function httpStatusHandler(evt:HTTPStatusEvent):void
{
	Logger.info('HTTPStatusHandler:'+evt.toString());
	Logger.info(evt.status);
}

//===========================================
//	ioErrorHandler()
//===========================================

private function ioErrorHandler(evt:IOErrorEvent):void
{
	Logger.error('ioErrorhandler:'+ evt.toString());
	Logger.info(evt.text);	
}


//===========================================
//	timerHandler()
//===========================================

/**
 * 时间到的时侯提交
 * */
private function timerHandler(evt:TimerEvent):void
{
	spareTime -= DELAY;
	//trace('还剩时间：',spareTime/1000);
	//如果时间到，就提交用户数据给服务器保存
	if(spareTime <= 0)
	{
		inputTimer.stop();
		inputTA.editable = false;
		var _urlvar:URLVariables = new URLVariables();
		_urlvar.competition_id = configXML.competition_id.toString();
		_urlvar.module_id = configXML.module_id.toString();
		_urlvar.article_id = configXML.article_id.toString();
		_urlvar.project_id = configXML.project_id.toString();
		_urlvar.right_per = rightRatio;
		_urlvar.speed = speed;
		_urlvar.type = 'post';		
		var _request:URLRequest = new URLRequest(postURL);
		_request.data = _urlvar;
		load(_request);
		//reset();		
	}
	refresh();
}



//===========================================
//
//	实例方法 其他
//
//===========================================

private function initNet():void
{
	var _param:Object = Application.application.parameters;
	if(_param.config == null)
	{
		article = '非法调用！';
		return;
	}
	var _var:URLVariables = new URLVariables();
	_var.type = 'config';
	//把除config之外的参数放在var中
	for(var i:String in _param)
	{
		if(i != 'config')
		{
			_var[i] = _param[i];
		}
	}
	Logger.info(_param);
	var _request:URLRequest = new URLRequest(_param.config);
	_request.data = _var;
	load(_request);
}

//===========================================
//	initTimer()
//===========================================



//===========================================
//	reset()
//===========================================



//===========================================
//	load()
//===========================================

/**
 * 调用loader的load方法载入外部数据
 **/
private function load($request:URLRequest):void
{
	try{
		loader.load($request);
	}
	catch(err:Error)
	{
		alert('载入外部数据失败：'+err.message);
	}
}

//===========================================
//	testLoad()
//===========================================

/**
 * 测试载入是否有错误
 */
private function loadTest($data:XML):void
{
	var _is_error:String = $data.is_error.toString().toLowerCase();
	if(_is_error == 'true')
	{
		if($data.type == 'config')
		{
			throw new Error('载入文章出错！');
		}
		else if($data.type == 'start')
		{
			throw new Error('计时失败！');
		}
		else if($data.type == 'post')
		{
			throw new Error('保存打字结果失败！');
		}
		else
		{
			throw new Error('错误！无法判断失败类型！');
		}
	}
	else if(_is_error == 'false')
	{
		//返回正常，不操作
	}
	else
	{
		throw new Error('错误！服务器操作失败！');
	}
}

//===========================================
//	loadConfig()
//===========================================

/**
 * 处理第一次载入php数据的值
 **/
private function loadConfig($data:XML):void
{
	Logger.info('loadConfig执行，第一次提交');
	postURL = $data.post_url;
	checkURL = $data.check_url;
	Logger.info('postURL:' + postURL);
	article = $data.article;
	time = parseInt($data.time_limit)*60*1000;
	spareTime = time;
	initTimer();
	inputTA.reset();
}

//===========================================
//	loadStrat()
//===========================================

/**
 * 处理第二次载入php数据的值
 **/
private function loadStart($data:XML):void
{
	Logger.info('loadStart执行，第二次提交返回：\n{1}',$data.toString());
}

//===========================================
//	loadPost()
//===========================================

/**
 * 处理第三次载入php数据的值
 **/
private function loadPost($data:XML):void
{
	Logger.info('loadPost第三次提交返回：');
	Logger.info($data.toString());
	var _str:String = '正确率：'+rightRatio+',速度：'+speed;
	delFlash($data.show_msg, $data.next_url);
}


//===========================================
//	alert()
//===========================================

private function alert($str:String):void
{
	ExternalInterface.call('alert', $str);
}

//===========================================
//	init()
//===========================================

private function delFlash($msg:String, $url:String):void
{
	ExternalInterface.call('delFlash', $msg, $url);
}

