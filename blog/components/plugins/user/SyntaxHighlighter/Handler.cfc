<!---
LICENSE INFORMATION:

Copyright 2009, Tony Garcia
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of SyntaxHighlighter Mango Blog Plugin (v1.0).
--->
<cfcomponent displayname="Handler">
	<cfset variables.name = "SyntaxHighlighter">
	<cfset variables.id = "com.objectivebias.mango.plugins.syntaxhighlighter">
	<cfset variables.package = "com/objectivebias/mango/plugins/syntaxhighlighter"/>
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
		<cfset var blogid = arguments.mainManager.getBlog().getId() />
		<cfset variables.path = blogid & "/" & variables.package />
			
		<cfset variables.blogManager = arguments.mainManager />
		<cfset variables.prefs = arguments.preferences />
		<cfset variables.languages = variables.prefs.get(variables.path,"shLanguages","") />
		<!--- put the languages list in the app scope so that the TinyMCE dialog can
			access that variable. (This is a hack until I figure out a better way to do this) --->
		<cfset application.shLanguages = variables.languages />
		
		<cfreturn this/>
	</cffunction>
  
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>

	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>

	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<!--- here, we need to change the TinyMCE config so that the syntaxhl plugin is included and also add the button --->
		<cfset var layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/editorSettings.cfm') />
		<cfset var content = "" />
		<!--- initialize prefernces with base list of languages --->
		<cfset variables.prefs.put(variables.path,"shLanguages","coldfusion,as3,css,jscript,sql,xml") />
		
		<!--- modify TinyMCE editor settings --->
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<!--- Add the plugin --->
			<cfset content = ReplaceNoCase(content, "plugins : ""table,", "plugins : ""table,syntaxhl,", "one") />
			<!--- Add the button --->
			<cfset content = ReplaceNoCase(content, ",code,help", ",code,syntaxhl,help", "one") />
			<!--- Add textarea to extended_valid_elements setting --->
			<cfset content = ReplaceNoCase(content,"span[class|style],","span[class|style],textarea[cols|rows|disabled|name|readonly|class],")>
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "SyntaxHighlighter has been activated, but was unable to modify TinyMCE config. See install instructions for manual setup."/>
			</cfcatch>
		</cftry>

		<!--- copy public files for this plugin to the preferred location --->
		<cfset copyAssets()/>

		<cfreturn "SyntaxHighlighter Plugin Activated" />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<!--- for current version of mango --->
		<cfset var layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/editorSettings.cfm') />
		<cfset var content = "" />
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<cfset content = ReplaceNoCase(content, "plugins : ""table,syntaxhl,", "plugins : ""table,", "one") />
			<cfset content = ReplaceNoCase(content, ",code,help,syntaxhl", ",code,help", "one") />
			<cfset content = ReplaceNoCase(content, "span[class|style],textarea[cols|rows|disabled|name|readonly|class],", "span[class|style],", "one") />
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "SyntaxHighlighter has been de-activated, but was unable to modify TinyMCE config. See install instructions for manual removal."/>
			</cfcatch>
		</cftry>

		<!--- remove public-facing files --->
		<cfset clearAssets()/>

		<cfreturn "SyntaxHighlighter Plugin De-activated" />
	</cffunction>

	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfreturn />
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var eventData = arguments.event.getData() />
		<cfset var message = arguments.event.getMessage() />
		<cfset var local = {} />
		<cfset var js = ""/>
		<cfset var data = ""/>
		
		<cfswitch expression="#arguments.event.getName()#">
		
			<cfcase value="beforeHtmlBodyEnd">
				<cfset data =  arguments.event.outputData />
				<cfset data = data & '#chr(13)##chr(10)#<link rel="stylesheet" href="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/styles/SyntaxHighlighter.css" type="text/css" media="screen" />'/>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shCore.js" type="text/javascript"></script>'/>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushColdFusion.js" type="text/javascript"></script>'/>
				<cfif listFindNoCase(variables.languages,"as3")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushAS3.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"cpp")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushCpp.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"cSharp")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushCSharp.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"css")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushCss.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"delphi")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushDelphi.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"java")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushJava.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"jscript")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushJScript.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"php")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushPhp.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"python")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushPython.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"ruby")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushRuby.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"sql")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushSql.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"vb")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushVb.js" type="text/javascript"></script>'/>
				</cfif>
				<cfif listFindNoCase(variables.languages,"xml")>
				<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/shBrushXml.js" type="text/javascript"></script>'/>
				</cfif>
				<cfset data = data & '#chr(13)##chr(10)#<script type="text/javascript">'/>
				<cfset data = data & "#chr(13)##chr(10)#dp.SyntaxHighlighter.ClipboardSwf =  '#variables.blogManager.getBlog().getBasePath()#assets/plugins/#getname()#/scripts/clipboard.swf';"/>
				<cfset data = data & "#chr(13)##chr(10)#dp.SyntaxHighlighter.HighlightAll('code');"/>
				<cfset data = data & '#chr(13)##chr(10)#</script>'/>
				<cfset arguments.event.outputData = data />
			</cfcase>
		
		<!--- admin event --->
			<cfcase value="settingsNav">
				<cfset LOCAL.link = structnew() />
				<cfset LOCAL.link.owner = "syntaxHighlighter">
				<cfset LOCAL.link.page = "settings" />
				<cfset LOCAL.link.title = "SyntaxHighlighter" />
				<cfset LOCAL.link.eventName = "showSHSettings" />
				
				<cfset arguments.event.addLink(LOCAL.link)>
			</cfcase>

			<cfcase value="showSHSettings">		
				<cfif structkeyexists(eventData.externaldata,"apply")>
					<cfset variables.languages = eventData.externaldata.shLanguages />
					<!--- put the languages list in the app scope so that the TinyMCE dialog can
						access that variable. (This is a hack until I figure out a better way to do this) --->
					<cfset application.shLanguages = variables.languages />
					<cfset variables.prefs.put(variables.path,"shLanguages",variables.languages) />
					
					<!--- this is a hack, just try to get the currently authenticated user --->
					<cftry>
						<cfif structkeyexists(session,"author")>
							<cfset variables.manager.getAdministrator().pluginUpdated(
									"SyntaxHighlighter", variables.id, session.author) />
						</cfif>
						<cfcatch type="any"></cfcatch>
					</cftry>
					<cfset eventData.message.setstatus("success") />
					<cfset eventData.message.setType("settings") />
					<cfset eventData.message.settext("Settings updated")/>
				</cfif>
				
				<cfsavecontent variable="LOCAL.page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change message --->
					<cfset eventData.message.setTitle("SyntaxHighlighter settings") />
					<cfset eventData.message.setData(LOCAL.page) />
			</cfcase>
		</cfswitch>
	
		<cfreturn arguments.event />
	</cffunction>  

	<cffunction name="copyAssets" access="private" output="false" returntype="void"
	hint="I'm used during plugin activation to copy files to a public location">
		
		<!--- copy assets to correct public folder --->
		<cfset var local = structNew()/>
		<cfset local.src = getCurrentTemplatePath() />
		<cfset local.src = listAppend(listDeleteAt(local.src, listLen(local.src, "\/"), "\/"), "assets", "/")/>
		<cfset local.dest = expandPath('#variables.blogManager.getBlog().getBasePath()#/assets/plugins/#getname()#')/>
		<cfset local.TMCEpluginDir = expandpath("#variables.blogManager.getBlog().getBasePath()#/admin/assets/editors/tinymce_3/jscripts/tiny_mce/plugins/syntaxhl") />
		
		<!--- copy our SH scripts/styles to the root/assets/plugins/SyntaxHighlighter folder so that they are web-accessible --->
		<cfset directoryCopy("#local.src#/syntaxhighlighter","#local.dest#") />
		
		<!--- copy TinyMCE plugin files to the TinyMCE plugin directory --->
		<cfset directoryCopy("#local.src#/syntaxhl","#local.TMCEpluginDir#") />

	</cffunction>

	<cffunction name="clearAssets" access="private" output="false" returntype="void"
	hint="I'm used during plugin de-activation to remove public files">

		<cfset var dir = expandPath('../assets/plugins/#getname()#')/>
		<cfset var TMCEpluginDir = expandpath("#variables.blogManager.getBlog().getBasePath()#/admin/assets/editors/tinymce_3/jscripts/tiny_mce/plugins/syntaxhl") />
		

		<!--- delete assets --->
		<cfdirectory action="delete" directory="#dir#" recurse="yes"/>
		<!--- delete TinyMCE plugin --->
		<cfdirectory action="delete" directory="#TMCEpluginDir#" recurse="yes"/>
		
	</cffunction>
	
	<!---
	Copies a directory.

	@param source      Source directory. (Required)
	@param destination      Destination directory. (Required)
	@param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
	@return Returns nothing.
	@author Joe Rinehart (joe.rinehart@gmail.com)
	@version 1, July 27, 2005
	--->
	<cffunction name="directoryCopy" output="true" access="private">
	    <cfargument name="source" required="true" type="string">
	    <cfargument name="destination" required="true" type="string">
	    <cfargument name="nameconflict" required="true" default="overwrite">

	    <cfset var contents = "" />
	    <cfset var dirDelim = "/">

	    <cfif server.OS.Name contains "Windows">
	        <cfset dirDelim = "\" />
	    </cfif>

	    <cfif not(directoryExists(arguments.destination))>
	        <cfdirectory action="create" directory="#arguments.destination#">
	    </cfif>

	    <cfdirectory action="list" directory="#arguments.source#" name="contents">

	    <cfloop query="contents">
	        <cfif contents.type eq "file">
	            <cffile action="copy" source="#arguments.source#\#name#" destination="#arguments.destination#\#name#" nameconflict="#arguments.nameConflict#">
	        <cfelseif contents.type eq "dir">
	            <cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
	        </cfif>
	    </cfloop>
	</cffunction>

</cfcomponent>