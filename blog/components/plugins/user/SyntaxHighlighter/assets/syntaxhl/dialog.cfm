<cfset shLanguages = application.shLanguages />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>{#syntaxhl_dlg.title}</title>
	<script type="text/javascript" src="../../tiny_mce_popup.js"></script>
	<script type="text/javascript" src="js/dialog.js"></script>
	<style type="text/css" media="screen">
		input {
			vertical-align: middle;
		}
		label {
			vertical-align: middle;
		}
		fieldset {
			margin-bottom: 10px;
		}
	</style>
</head>
<body>

<form onsubmit="SyntaxHLDialog.insert(); return false;" action="#">
	<fieldset id="syntaxhl_options">
		<legend>{#syntaxhl_dlg.highlight_options}</legend>
		
		<input type="checkbox" name="syntaxhl_nogutter" id="syntaxhl_nogutter" value="1" /><label for="syntaxhl_nogutter" >{#syntaxhl_dlg.nogutter}</label>
		
		<input type="checkbox" name="syntaxhl_nocontrols" id="syntaxhl_nocontrols" value="1" /><label for="syntaxhl_nocontrols">{#syntaxhl_dlg.nocontrols}</label>
		
		<input type="checkbox" name="syntaxhl_collapse" id="syntaxhl_collapse" value="1" /><label for="syntaxhl_collapse">{#syntaxhl_dlg.collapse}</label>
		
		<input type="checkbox" name="syntaxhl_showcolumns" id="syntaxhl_showcolumns" value="1" /><label for="syntaxhl_showcolumns">{#syntaxhl_dlg.showcolumns}</label><br />
		
		<label for="syntaxhl_language">{#syntaxhl_dlg.choose_lang}:</label>
		<select name="syntaxhl_language" id="syntaxhl_language">
			<option value="cf">ColdFusion</option>
			<cfif listFindNoCase(shLanguages,"as3")>
				<option value="as3">ActionScript 3</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"cpp")>
				<option value="cpp">C++</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"cSharp")>
				<option value="c-sharp">C Sharp</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"css")>
				<option value="css">CSS</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"delphi")>
				<option value="delphi">Delphi</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"java")>
				<option value="java">Java</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"jscript")>
				<option value="javascript">Javascript</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"php")>
				<option value="php">PHP</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"python")>
				<option value="python">Python</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"ruby")>
				<option value="ruby">Ruby</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"sql")>
				<option value="sql">SQL</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"vb")>
				<option value="vb">VB</option>
			</cfif>
			<cfif listFindNoCase(shLanguages,"xml")>
				<option value="xhtml">XML/XHTML</option>
			</cfif>
		</select>
		
		<label for="syntaxhl_firstline" style="margin-left: 15px;">{#syntaxhl_dlg.first_line}:</label>
		<input type="textfield" name="syntaxhl_firstline" id="syntaxhl_firstline" style="width:20px;" />
	
	</fieldset>
	
	<fieldset>
		<legend>{#syntaxhl_dlg.paste}</legend>
	<textarea name="syntaxhl_code" id="syntaxhl_code" rows="15" cols="100" style="width: 100%; height: 100%; font-family: 'Courier New',Courier,mono; font-size: 12px;" class="mceFocus"></textarea>
	</fieldset>
	<div class="mceActionPanel">
		<div style="float: left">
			<input type="submit" id="insert" name="insert" value="{#insert}" />
		</div>

		<div style="float: right">
			<input type="button" id="cancel" name="cancel" value="{#cancel}" onclick="tinyMCEPopup.close();" />
		</div>
	</div>
</form>

</body>
</html>
