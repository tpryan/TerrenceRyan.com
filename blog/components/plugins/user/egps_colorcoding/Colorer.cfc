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

<cfcomponent name="Colorer">
	<cfset variables.name = "EGPS Color Coding">
	<cfset variables.id = "com.empiregpservices.mangoplugins.egps_colorcoding">
	<cfset variables.package = "com/empiregpservices/mangoplugins/egps_colorcoding"/>
	<cfset variables.preferences = structnew() />
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />

		<cfset variables.manager = arguments.mainManager />
		<cfset variables.preferences = arguments.preferences />

		<cfreturn this/>
	</cffunction>

	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>

	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfset variables.package = replace(variables.id,".","/","all") />
	</cffunction>

	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<!--- NOT NEEDED --->
		<cfreturn />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<!--- NOT NEEDED --->
		<cfreturn />
	</cffunction>

	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<!--- NOT NEEDED --->
		<cfreturn />
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

		<cfset var data =  "" />
		<cfset var eventName = arguments.event.name />

		<cfif eventName EQ "commentGetContent">
			<cfset data = arguments.event.accessObject />
			<cfset data.content = colorCode(data.content, "comment", true) />
		<cfelseif eventName EQ "postGetContent" OR eventName EQ "pageGetContent">
			<cfset data = arguments.event.accessObject />
			<cfset data.content = colorCode(data.content, "entry") />
		<cfelseif eventName EQ "postGetExcerpt" OR eventName EQ "pageGetExcerpt">
			<cfset data = arguments.event.accessObject />
			<cfset data.excerpt = colorCode(data.excerpt, "excerpt") />
		<cfelseif eventName EQ "beforeHtmlHeadEnd">
			<cfset data = arguments.event.outputData />
			<cfset data = data &  '<link rel="stylesheet" href="' & variables.manager.getBlog().getBasePath() & 'assets/plugins/egps_colorcoding/style.css" type="text/css" />' />
			<cfset arguments.event.outputData = data />
		</cfif>

		<cfreturn arguments.event />
	</cffunction>

	<cffunction name="colorCode" output="false" returntype="string">
		<cfargument name="bodyArg" required="true" type="string">
		<cfargument name="type" required="true" type="string">
		<cfargument name="debugMode" required="false" type="Boolean" default="false">
	
		<cfset var codeblock = "" />
		<cfset var codePortion = "" />
		<cfset var result = "" />
		<cfset var midStart = 0 />
		<cfset var midEnd = 0 />
		<cfset var codeBlockLen = 0 />
		<cfset var codeBlockStart = 0 />
		<cfset var codeBlockEnd = 0 />
		<cfset var body = arguments.bodyArg />

		<cfset body = replaceList(body, "&lt;,&gt;", "«,»")/>
		<cfset body = reReplace(body, "«(.?)code([^»]*)»", "<\1code\2>", "all") />
		<cfset body = reReplace(body, "\^(.?)code([^\^]*)\^", "&lt;\1code\2&gt;", "all") />

		<cfloop index="codeType" list="coldfusion,as3,mxml,xml,properties">
			<cfif findNoCase('#chr(60)#code class#chr(61)#"#codeType#"', body) and findNoCase("#chr(60)#/code#chr(62)#", body)>
				<cfset codeBlockStart = findNoCase("#chr(60)#code class=""#codeType#""", body) />
				
				<cfloop condition="codeBlockStart gte 1">
					<cfset codeBlockEnd = findNoCase("</code>", body, codeBlockStart + 10) />
					<cfset codeBlockLen = find(chr(62), body, codeBlockStart) - codeBlockStart + 1 />
					<cfset midStart = codeBlockStart + codeBlockLen />
					<cfset midEnd = codeBlockEnd - (codeBlockStart + codeBlockLen) />
	
					<cfif (midEnd) GT 0>
						<cfset codePortion = mid(body, midStart, midEnd) />
						<cfmodule template="coloredcode.cfm" data="#trim(codePortion)#" result="result" type="#codeType#">
						<cfset body = mid(body, 1, midStart-1) & result & mid(body, codeBlockEnd, len(body)-codeBlockEnd+2)>
						<cfset codeBlockStart = codeBlockStart + len(result) + len(codeType) + 22 />
						<cfset codeBlockStart = findNoCase("<code class=""#codeType#""", body, midStart) />
					<cfelse>
						<cfset codeBlockStart = 0 />
					</cfif>
	
				</cfloop>
			</cfif>
		</cfloop>

		<cfif REFindNoCase("#chr(60)#code(#chr(62)#| )(?!class)[^#chr(62)#]*#chr(62)#", body) and findNoCase("</code>", body)>
			<cfset codeBlockStart = REFindNoCase("#chr(60)#code(#chr(62)#| )(?!class)[^#chr(62)#]*#chr(62)#", body) />
			<cfloop condition="codeBlockStart gte 1">
				<cfset codeBlockEnd = findNoCase("</code>", body, codeBlockStart + 6) />
				<cfset codeBlockLen = find(chr(62), body, codeBlockStart) - codeBlockStart + 1 />
				<cfset midStart = codeBlockStart + codeBlockLen />
				<cfset midEnd = codeBlockEnd - (codeBlockStart + codeBlockLen) />

				<cfif (midEnd) GT 0>
					<cfset codePortion = mid(body, midStart, midEnd) />
					<cfmodule template="coloredcode.cfm" data="#trim(codePortion)#" result="result">
					<cfset body = mid(body, 1, midStart-1) & result & mid(body, codeBlockEnd, (len(body)+1)-codeBlockEnd)>
					<cfset codeBlockStart = codeBlockStart + len(result) + 7 />
					<cfset codeBlockStart = REFindNoCase("#chr(60)#code(#chr(62)#| )(?!class)[^#chr(62)#]*#chr(62)#", body, midStart) />
				<cfelse>
					<cfset codeBlockStart = 0 />
				</cfif>
	
			</cfloop>
		</cfif>

		<cfset body = REReplaceNoCase(body, "«([^»]*)»", "&lt;\1&gt;", "ALL")/>

		<cfreturn body />
	</cffunction>

</cfcomponent>