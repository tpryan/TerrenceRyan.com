<cfoutput>
<form method="post" action="#cgi.script_name#">
  <span class="oneField">
    <span class="preField">Select Languages for which to include syntax brushes:</span><br />
	<input type="checkbox" name="shLanguages" value="coldfusion" id="coldFusion" checked> <label for="coldFusion">ColdFusion</label><br />
	<input type="checkbox" name="shLanguages" value="as3" id="as3" <cfif listFind(variables.languages,"as3")> checked</cfif>> <label for="as3">ActionScript 3</label><br />
	<input type="checkbox" name="shLanguages" value="cpp" id="cpp" <cfif listFind(variables.languages,"cpp")> checked</cfif>> <label for="cpp">C++</label><br />
	<input type="checkbox" name="shLanguages" value="cSharp" id="cSharp" <cfif listFind(variables.languages,"cSharp")> checked</cfif>> <label for="cSharp">C##</label><br />
	<input type="checkbox" name="shLanguages" value="css" id="css" <cfif listFind(variables.languages,"css")> checked</cfif>> <label for="css">CSS</label><br />
	<input type="checkbox" name="shLanguages" value="delphi" id="delphi" <cfif listFind(variables.languages,"delphi")> checked</cfif>> <label for="delphi">Delphi</label><br />
	<input type="checkbox" name="shLanguages" value="java" id="java" <cfif listFind(variables.languages,"java")> checked</cfif>> <label for="java">Java</label><br />
	<input type="checkbox" name="shLanguages" value="jscript" id="jscript" <cfif listFind(variables.languages,"jscript")> checked</cfif>> <label for="jscript">JavaScript</label><br />
	<input type="checkbox" name="shLanguages" value="php" id="php" <cfif listFind(variables.languages,"php")> checked</cfif>> <label for="php">PHP</label><br />
	<input type="checkbox" name="shLanguages" value="python" id="python" <cfif listFind(variables.languages,"python")> checked</cfif>> <label for="python">Python</label><br />
	<input type="checkbox" name="shLanguages" value="ruby" id="ruby" <cfif listFind(variables.languages,"ruby")> checked</cfif>> <label for="ruby">Ruby</label><br />
	<input type="checkbox" name="shLanguages" value="sql" id="sql" <cfif listFind(variables.languages,"sql")> checked</cfif>> <label for="sql">SQL</label><br />
	<input type="checkbox" name="shLanguages" value="vb" id="vb" <cfif listFind(variables.languages,"vb")> checked</cfif>> <label for="vb">VBScript</label><br />
	<input type="checkbox" name="shLanguages" value="xml" id="xml" <cfif listFind(variables.languages,"xml")> checked</cfif>> <label for="xml">XML/XHTML</label>
  </span>
 
  <div class="actions">
    <input type="submit" class="primaryAction" value="Submit"/>
	<input type="hidden" value="event" name="action" />
	<input type="hidden" value="showSHSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="SyntaxHighlighter" name="selected" />
  </div>

</form>
</cfoutput>