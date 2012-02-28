<cfcomponent>
<!--- 
 * File Explorer plugin cannot be used outside MangoBlog. Please visit asfusion.com 
 * to get a commercial version
 *
 * @author AsFusion
 * @copyright Copyright ©2008, AsFusion, All rights reserved.
 * --->

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getInstance" output="false" description="Returns an object of this class" 
					access="public" returntype="any">
						
		<cfset var newinstance = "" />
		<cfif NOT structkeyexists(application,"_mainFileExplorerPlugin")> 
			<cfset newinstance = createObject("component", "MainFileExplorer").init() />
			<cfset application._mainFileExplorerPlugin = newinstance />
		 </cfif> 
		
		<cfreturn application._mainFileExplorerPlugin />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" output="false" returntype="any">
		
		<cfset variables.configfile = expandPath("./fileexplorer.ini.cfm") />
		<cfset getSettings()/>	
		
		<!--- try finding an application variable  --->
		<cfif structkeyexists(application,"asfFileExplorerPluginRoot")>
			<cfset variables.settings.root = application.asfFileExplorerPluginRoot />
		</cfif>
	 
		<cfreturn this>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getFileManager" access="public" output="false" returntype="any">
		<cfif NOT structkeyexists(variables,"filemanager")>
			<cfset variables.fileManager = createObject("component","FileManager").init(variables.settings.root, variables.settings.ext)/>
		</cfif>
		<cfreturn variables.fileManager />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setFileManager" access="public" output="false" returntype="any">
		<cfargument name="filemanager">

		<cfset variables.fileManager = arguments.filemanager>

	</cffunction>
		
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getSettings" output="false" description="Gets the settings for this application" 
					access="private" returntype="void">
				
		<cfscript>
			variables.settings = structnew();

			variables.settings.root  = GetProfileString(variables.configfile, "default", "rootDirectory");
			variables.settings.ext = GetProfileString(variables.configfile, "default", "allowedExtensions");
		</cfscript>

	</cffunction> 
	
				
</cfcomponent>