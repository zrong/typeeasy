<style type="text/css">
<!--
body {
	background-color: #FFFFFF;
}
-->
</style>


	<TABLE width="98%" height="700" bgcolor="#FFFFFF">
		<TR>
			<TD bgColor=#EEF4E6 id="flashcontent">
		<strong>您的浏览器不支持JavaScript，或者您禁用了JavaScript。</strong>
		请启用浏览器的JavaScript支持。<br>
	如果您确认启用了JavaScript，请使用下面的链接升级Flash Player到最新版本<br>
	<a href="http://www.adobe.com/go/getflash/">安装最新的Flash Player插件</a>
	 <script language="javascript" type="text/javascript">
	function delFlash(show_msg,next_link)
	{
		alert("时间到!!马上来看您的成绩!");
		document.getElementById('flashcontent').innerHTML = '<b>'+show_msg+'</b>';
		if(next_link){
			document.getElementById('flashcontent').innerHTML +='<br><a href='+next_link+'>下一步</a>';
		}
	}
</script>
	 <script language="JavaScript" type="text/javascript" src="flash/swfobject.js"></script>
	<script language="JavaScript" type="text/javascript">
		// <![CDATA
		var so = new SWFObject("<?=$typed_run_folder?>/type.swf", "type", "100%", "100%", "9", "#ffffff");
		so.addVariable("config", "js_type_run_deal.php");
		so.addVariable("type", "config");
		so.addVariable("op_id",<?=$iTypeRunId?>);
		so.addVariable("is_error", "false");
		so.addVariable("project_id", "<?=$aModule["project_id"]?>");
		so.addVariable("competition_id", "<?=$aModule["competition_id"]?>");
		so.addVariable("module_id","<?=$aModule["id"]?>");
		so.addVariable("time_limit","<?=$testModuleDuringTime?>");
		//so.addParam('base', 'swf');
		so.addParam('menu', 'false');
		so.addParam('wmode','transparent');
		so.useExpressInstall('flash/playerProductInstall.swf');
		so.write("flashcontent");
		// ]]>
	</script>
						   </TD>
                      </TR>
					</TABLE>