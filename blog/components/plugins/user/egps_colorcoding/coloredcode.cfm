<!--- 
	Licensed under the Creative Commons License, Version 3.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	http://creativecommons.org/licenses/by-sa/3.0/us/
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

	Created By Russell Brown : EmpireGP Servces
	http://www.EmpireGPServices.com
 --->

<!--- Initialize attribute values --->
<cfparam name="attributes.data" default="">

<!--- mod by ray --->
<cfparam name="attributes.type" default="default">
<cfparam name="attributes.r_result" default="result">

<!--- Abort if no data was sent ---> 
<cfif not len(attributes.data)>
	 <cfset caller[attributes.r_result] = attributes.data>
</cfif>

<cfscript>
	if (attributes.type NEQ "properties") {
		/* Identify Basic HTML Tags */
		findExpression = "«(/?)((!d|!br|!cf|html|body|head|p|span|div|strong|b|hr))([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_html_basic'#chr(62)#«\1\2\4»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	
		/* Identify Basic Table Tags */
		findExpression = "«(/?)((table|tr|td|th))([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_html_basic'#chr(62)#«\1\2\4»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	
		/* Identify Basic Form Tags */
		findExpression = "«(/?)((form|input|textarea))([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_html_form'#chr(62)#«\1\2\4»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	
		/* Identify Basic Form Tags */
		findExpression = "«(/?)((a))([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_anchor'#chr(62)#«\1\2\4»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		/* Convert all inline "//" comments to gray (revised) */
		findExpression = "([^:/]\/{2,2})([^[:cntrl:]]+)($|[[:cntrl:]])";
		replaceExpression = "#chr(60)#span class='cc_comment'#chr(62)#\1\2#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		/* Convert all multi-line script comments to gray */
		findExpression = "(\/\*[^\*]*\*\/)";
		replaceExpression = "#chr(60)#span class='cc_comment'#chr(62)#\1#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	}

	if (attributes.type EQ "as3") {
		/* Identify functions */
		findExpression = "(public|private|protected)[[:space:]]*(function)[[:space:]]*([^ (]*)";
		replaceExpression = "#chr(60)#span class='cc_as3_accessType'#chr(62)#\1#chr(60)#/span#chr(62)# #chr(60)#span class='cc_as3_functionDeclaration'#chr(62)#\2#chr(60)#/span#chr(62)# #chr(60)#span class='cc_as3_functionName'#chr(62)#\3#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		/* Identify variables */
		findExpression = "(public|private|protected)[[:space:]]*(var)[[:space:]]*([^ :]*)";
		replaceExpression = "#chr(60)#span class='cc_as3_accessType'#chr(62)#\1#chr(60)#/span#chr(62)# #chr(60)#span class='cc_as3_varDeclaration'#chr(62)#\2#chr(60)#/span#chr(62)# #chr(60)#span class='cc_as3_varName'#chr(62)#\3#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		/* Identify metadata */
		findExpression = "\[([^\]\(]*)([^\]]*)\]";
		replaceExpression = "[#chr(60)#span class='cc_as3_metadataName'#chr(62)#\1#chr(60)#/span#chr(62)#\2]";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	} else if (attributes.type EQ "coldfusion") {
		/* Identify all Tag Based VAR Scoping */
		findExpression = "(«cfset[[:space:]]*)(var) ";
		replaceExpression = "\1#chr(60)#span class='cc_cf_varDeclaration'#chr(62)#\2#chr(60)#/span#chr(62)# ";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		/* Identify all CFTAGS */
		findExpression = "«(.?cf[^»]*)»";
		replaceExpression = "<span class='cc_cf_cftag'>«\1»</span>";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		sqlKeyWords = "SELECT,FROM,WHERE,ORDER BY,GROUP BY,LEFT JOIN,RIGHT JOIN,INNER JOIN,JOIN,ON,LIKE,BETWEEN,AND,OR";

		for (i=1; i LTE listLen(sqlKeyWords); i=i+1) {
			/* Identify all CFSQLKeyWords */
			keyWord = listGetAt(sqlKeyWords, i);
			findExpression = "(«.?cfquery[^»]*»)([^«]*)(#keyWord#)([^«]*)(«/cfquery»)";
			replaceExpression = "\1\2#chr(60)#span class='cc_cf_sql'#chr(62)#\3#chr(60)#/span#chr(62)#\4\5";
			attributes.data = ReReplace(attributes.data, findExpression, replaceExpression, "ALL");
		}
	} else if (attributes.type EQ "mxml") {
		/* Identify all Tag Based VAR Scoping */
		findExpression = "«([^:]*):([^ ]*)([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_mx_tag'#chr(62)#«\1:#chr(60)#span class='cc_mx_component'#chr(62)#\2#chr(60)#/span#chr(62)#\3»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	} else if (attributes.type EQ "xml") {
		/* Identify all XML Nodes */
		findExpression = "«([^»]*)»";
		replaceExpression = "#chr(60)#span class='cc_xml_node'#chr(62)#«\1»#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");
	} else if (attributes.type EQ "properties") {
		findExpression = "<br[^>]*>";
		replaceExpression = chr(13) & chr(10);
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		findExpression = "(\A|\n)([^##//= ]*)( ?= ?)([[:print:]]*)";
		replaceExpression = "\1#chr(60)#span class='cc_properties_property'#chr(62)#\2#chr(60)#/span#chr(62)# = #chr(60)#span class='cc_properties_value'#chr(62)#\4#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		findExpression = "(\A|\n)(##|//)([[:print:]]*)";
		replaceExpression = "\1#chr(60)#span class='cc_properties_comment'#chr(62)#\2\3#chr(60)#/span#chr(62)#";
		attributes.data = ReReplaceNoCase(attributes.data, findExpression, replaceExpression, "ALL");

		attributes.data = replace(attributes.data, chr(13), "#chr(60)#br /#chr(62)#", "all");
	}

	/* Convert all HTML and ColdFusion comments to gray */	
	EOF = 0; BOF = 1;
	while(NOT EOF) {
		Match = REFindNoCase("#chr(60)#!---?([^-]*)-?--#chr(62)#", attributes.data, BOF, True);
		if (Match.pos[1]) {
			Orig = Mid(attributes.data, Match.pos[1], Match.len[1]);
			Chunk = ReReplaceNoCase(Orig, "#chr(60)#(/?[^#chr(62)#]*)#chr(62)#", "", "ALL");
			BOF = ((Match.pos[1] + Len(Chunk)) + 31); // 31 is the length of the FONT tags in the next line
			attributes.data = Replace(attributes.data, Orig, "#chr(60)#span class='comment'#chr(62)##Chunk##chr(60)#/span#chr(62)#");
		} else EOF = 1;
	}

	/* Identify all quoted values */
	attributes.data = ReReplaceNoCase(attributes.data, """([^""]*)""", "#chr(60)#span class='cc_value'#chr(62)#""\1""#chr(60)#/span#chr(62)#", "ALL");

</CFSCRIPT>

<cfset caller[attributes.r_result] = attributes.data>


