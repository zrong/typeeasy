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
		<strong>�����������֧��JavaScript��������������JavaScript��</strong>
		�������������JavaScript֧�֡�<br>
	�����ȷ��������JavaScript����ʹ���������������Flash Player�����°汾<br>
	<a href="http://www.adobe.com/go/getflash/">��װ���µ�Flash Player���</a>
	 <script language="javascript" type="text/javascript">
	function delFlash(show_msg,next_link)
	{
		alert("ʱ�䵽!!�����������ĳɼ�!");
		document.getElementById('flashcontent').innerHTML = '<b>'+show_msg+'</b>';
		if(next_link){
			document.getElementById('flashcontent').innerHTML +='<br><a href='+next_link+'>��һ��</a>';
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