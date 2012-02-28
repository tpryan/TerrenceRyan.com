<cfcomponent>
	<cfset variables.package = "com/asfusion/mango/plugins/extremecache"/>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
			<cfset var blog = "" />
			<cfset var defaultDirectory = replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()) & "cache_store","\","/","all") />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.queryInterface = variables.manager.getQueryInterface() />
			<cfset variables.prefix = variables.queryInterface.getTablePrefix() />	
			<cfset variables.storeDirectory = variables.preferencesManager.get(variables.package,"storeDirectory", defaultDirectory) />
			<cfset blog = variables.manager.getBlog() />
			<cfset variables.blogId = blog.getId() />
			<cfset variables.blogUrl = blog.getUrl() />
			
		<cfreturn this/>
	</cffunction>

	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<!--- check whether db tables exist --->
		<cfset var dbtype = variables.queryInterface.getDBType() />
		<cfset var query = "" />
		
		<cfif dbtype EQ "mysql">
			<cfsavecontent variable="query">
				<cfoutput>CREATE TABLE  `#variables.prefix#extremecache` (
  					`blog_id` varchar(50) NOT NULL,
					`entry_id` varchar(35) NOT NULL,
  					`filename` varchar(200) default NULL,
					`address` varchar(500) default NULL,
  					`createdOn` varchar(200) default NULL,
					`isUpdating` tinyint(1) default 0,
  					PRIMARY KEY  (`blog_id`,entry_id)
				) </cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="query">
				<cfoutput>CREATE TABLE #variables.prefix#extremecache (
  					blog_id varchar(50) NOT NULL,
					entry_id varchar(35) NOT NULL,
  					filename varchar(200) NULL,
					address varchar(500) NULL,
  					createdOn varchar(200) NULL,
					isUpdating bit default 0,
  					PRIMARY KEY  (blog_id,entry_id)
				) </cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cftry>
			<cfset variables.queryInterface.makeQuery(query,-1,false) />			
			<cfcatch type="database">
				<!--- table already existed --->
			</cfcatch>
		</cftry>
		
		<cfreturn "Plugin activated" />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfset var dbtype = variables.queryInterface.getDBType() />
		<cfset var query = "" />
		
		<cfif dbtype EQ "mysql">
			<cfsavecontent variable="query">
				<cfoutput>DROP TABLE `#variables.prefix#extremecache`</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="query">
				<cfoutput>DROP TABLE #variables.prefix#extremecache</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cftry>
			<cfset variables.queryInterface.makeQuery(query,-1,false) />			
			<cfcatch type="database">
				<!--- table already existed --->
			</cfcatch>
		</cftry>
		
		<cfreturn "Plugin de-activated" />
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

	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
		<cfset var eventName = arguments.event.name />
		<cfset var entryId = "" />
		
		<cfif eventName EQ "extremecache-cacheIndex">
			<cfset saveIndex() />
			
		<cfelseif eventName EQ "extremecache-cachePage">
			<cfset savePage('', arguments.event.data.entry_id, true) />
			
		<cfelseif eventName EQ "extremecache-softCacheIndex">
			<!--- when soft, we just need to make sure the index has been cached,
			we don't need to overwrite it if it is there --->
			<cfif NOT len(getCached('index')) AND NOT isUpdating('index')>
				<cfset saveIndex() />
			</cfif>
			
		<cfelseif eventName EQ "extremecache-softCachePage">
			<!--- when soft, we just need to make sure the page has been cached,
			we don't need to overwrite it if it is there --->
			<cfif NOT len(getCached(arguments.event.data.entry_id)) AND NOT isUpdating(arguments.event.data.entry_id)>
				<cfset savePage('', arguments.event.data.entry_id, arguments.event.data.isPage) />
			</cfif>
		
		<cfelseif eventName EQ "afterCommentDelete" OR eventName EQ "afterCommentAdd">
			<cfset saveIndex() />
			
			<!--- after adding a comment --->
			<cfif eventName EQ "afterCommentAdd">
				<cfset entryId = event.newItem.entryId />			
				
			
			<cfelseif eventName EQ "afterCommentDelete">
				<cfset entryId = event.oldItem.entryId />
			</cfif>
			
			<!--- assume it is a post first, otherwise, it is page --->
			<cftry>
				<cfset variables.manager.getPostsManager().getPostById(entryId, false, false) />
				<cfset savePage('', entryId, false) />
			<cfcatch type="any">
				<cftry>
					<cfset variables.manager.getPagesManager().getPageById(entryId, false, false) />
					<cfset savePage('', entryId, true) />
				<cfcatch type="any"></cfcatch>
				</cftry>
			</cfcatch>
			</cftry>
		
		<cfelseif eventName EQ "afterPageAdd" OR eventName EQ "afterPageUpdate" OR 
					eventName EQ "afterPostAdd" OR eventName EQ "afterPostUpdate">
						
			<!--- more dramatic changes require a redo of all files --->
			<cfset removeAll() />			
			
			<cfset cleanUpEntry(event.newItem.id, event.newItem.name) />
			<cfset saveIndex() />
		
		<cfelseif eventName EQ "afterPostDelete" OR eventName EQ "afterPageDelete">
		
			<!--- more dramatic changes require a redo of all files --->
			<cfset removeAll() />			
			
			<cfset cleanUpEntry(event.oldItem.id, event.oldItem.name) />
			<cfset saveIndex() />
			
		</cfif>
		
		<cfreturn />
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var data = arguments.event.data />
			<cfset var eventName = arguments.event.name />
			<cfset var pluginQueue = "" />
			<cfset var page = "" />
			<cfset var cached = "" />
			<cfset var newEventData = "" />
			<cfset var content = "" />
			
			<cfif eventName EQ "beforeIndexTemplate">
				<cfset cached = getCached('index')>
				
				<cfif len(cached)>
					<cffile action="read" file="#cached#" variable="content" />
					<cfset data.message.setText(content) />
					<cfset data.indexTemplate = "../../output.cfm" />
				<cfelse>
					<!--- send request, and let it continue --->
					<cfset pluginQueue = variables.manager.getPluginQueue() />
					<cfset pluginQueue.broadcastEvent(pluginQueue.createEvent("extremecache-softCacheIndex")) />
				</cfif>
			
			<cfelseif eventName EQ "beforePageTemplate">
				<cfif structkeyexists(cgi, "REQUEST_METHOD") AND cgi.REQUEST_METHOD EQ "GET">
					<cfset page = variables.manager.getPagesManager().getPageByName(data.externalData.pageName, false, false) />
					<!--- look for it cached --->
					<cfset cached = getCached(page.id)>
					
					<cfif len(cached)>
						<cffile action="read" file="#cached#" variable="content" />
						<cfset data.message.setText(content) />
						<cfset data.pageTemplate = "../../output.cfm" />
					<cfelse>
						<!--- send request, and let it continue --->
						<cfset newEventData = structnew() />
						<cfset newEventData.entry_id = page.id />
						<cfset newEventData.isPage = true />
						<cfset pluginQueue = variables.manager.getPluginQueue() />
						<cfset pluginQueue.broadcastEvent(pluginQueue.createEvent("extremecache-softCachePage", newEventData)) />
					</cfif>
				</cfif>
				
			<cfelseif eventName EQ "beforePostTemplate">
				<cfif structkeyexists(cgi, "REQUEST_METHOD") AND cgi.REQUEST_METHOD EQ "GET">
					<cfset page = variables.manager.getPostsManager().getPostByName(data.externalData.postName, false, false) />
					<!--- look for it cached --->
					<cfset cached = getCached(page.id)>
					
					<cfif len(cached)>
						<cffile action="read" file="#cached#" variable="content" />
						<cfset data.message.setText(content) />
						<cfset data.postTemplate = "../../output.cfm" />
					<cfelse>
						<!--- send request, and let it continue --->
						<cfset newEventData = structnew() />
						<cfset newEventData.entry_id = page.id />
						<cfset newEventData.isPage = false />
						<cfset pluginQueue = variables.manager.getPluginQueue() />
						<cfset pluginQueue.broadcastEvent(pluginQueue.createEvent("extremecache-softCachePage", newEventData)) />
					</cfif>
				</cfif>
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>
	


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="savePage" access="private" output="false">
		<cfargument name="entry_alias" type="string" required="true" />
		<cfargument name="entry_id" type="string" required="true" />
		<cfargument name="isPage" type="boolean" required="true" />
		
		<cfset var content = ''>
		<cfset var pageObj = "" />
		
		<cfif directoryexists(variables.storeDirectory)>	
			<cftry>
				
				<cfif len(arguments.entry_alias)>
					<cfif arguments.isPage>
						<cfset pageObj = variables.manager.getPagesManager().getPageByName(arguments.entry_alias, false, false) />
					<cfelse>
						<cfset pageObj = variables.manager.getPostsManager().getPostByName(arguments.entry_alias, false, false) />
					</cfif>
				<cfelse>
					<cfif arguments.isPage>
						<cfset pageObj = variables.manager.getPagesManager().getPageById(arguments.entry_id, false, false) />
					<cfelse>
						<cfset pageObj = variables.manager.getPostsManager().getPostById(arguments.entry_id, false, false) />
					</cfif>
				</cfif>
				
				<!--- remove previous --->
				<cfset cleanUpEntry(pageObj.id, pageObj.name) />
				
				<!--- save the new one --->
				<cfset addEntry(pageObj.permalink, pageObj.id, pageObj.name) />
			
				<cfcatch type="any">
				</cfcatch>
			</cftry>
			
		</cfif>
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="saveIndex" access="private" output="false">
		
		<cfif directoryexists(variables.storeDirectory)>
		
			<!--- remove previous --->
			<cfset cleanUpEntry('index', '#variables.blogId#_index') />
			
			<!--- save the new one --->
			<cfset addEntry(variables.blogUrl,'index', '#variables.blogId#_index') />
		</cfif>
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="cleanUpEntry" access="private" returntype="void">
		<cfargument name="entry_id" type="string" required="true" />
		<cfargument name="entry_alias" type="string" required="true" />
		
		<!--- remove the old file --->
		<cfif fileExists("#variables.storeDirectory#/#arguments.entry_alias#.html")>
			<cffile action="delete" file="#variables.storeDirectory#/#arguments.entry_alias#.html" />
		</cfif>
		
		<cfset updateDB(arguments.entry_id, '', '', 0) />
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="addEntry" access="private" returntype="void">
		<cfargument name="address" type="string" required="true" />
		<cfargument name="entry_id" type="string" required="true" />
		<cfargument name="entry_alias" type="string" required="true" />
		
		<cfset var content = '' />
		
		<!--- notify that we are updating so that we don't enter an infinite loop --->
		<cfset updateDB(arguments.entry_id, '', arguments.address, 1) />
		
		<!--- make an http request to get the page data --->		
		<cfhttp url="#arguments.address#" result="content" />			
			
		<cfif len(variables.storeDirectory)>
			<cfif content.statusCode EQ "200 OK">
				<cffile action="write" file="#variables.storeDirectory#/#arguments.entry_alias#.html" 
						output="#trim(content.fileContent)#" charset="utf-8" />						
				
				<cfset updateDB(arguments.entry_id, '#variables.storeDirectory#/#arguments.entry_alias#.html', 
						arguments.address, 0) />					
			</cfif>
		</cfif>
	</cffunction>

	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCached" access="private" output="false">
		<cfargument name="entry_id" type="string" required="true" />
		
		<cfset var query = "" />
		<cfset var queryResult = "" />
		
		<cfsavecontent variable="query">
			<cfoutput>SELECT * FROM #variables.prefix#extremecache 
				WHERE blog_id = '#variables.blogId#'
				AND entry_id = '#arguments.entry_id#'
			</cfoutput>
		</cfsavecontent>

		<cfset queryResult = variables.queryInterface.makeQuery(query, 60, true) />
		
		<cfif queryResult.recordcount AND len(queryResult.filename) AND fileExists(queryResult.filename)>
			<cfreturn queryResult.filename />
		<cfelse>
			<cfreturn "" />
		</cfif>
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="isUpdating" access="private" output="false">
		<cfargument name="entry_id" type="string" required="true" />
		
		<cfset var query = "" />
		<cfset var queryResult = "" />
		
		<cfsavecontent variable="query">
			<cfoutput>SELECT * FROM #variables.prefix#extremecache 
				WHERE blog_id = '#variables.blogId#'
				AND entry_id = '#arguments.entry_id#'
			</cfoutput>
		</cfsavecontent>

		<cfset queryResult = variables.queryInterface.makeQuery(query, 30, true) />
		
		<cfreturn queryResult.recordcount AND queryResult.isUpdating />
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="updateDB" access="private" output="false">
		<cfargument name="entry_id" type="string" required="true" />
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="address" type="string" required="true" />
		<cfargument name="isUpdating" type="numeric" required="true" />
		
		<cfset var query = "" />
		<cfset var queryResult = "" />
		
		<cfsavecontent variable="query">
			<cfoutput>SELECT * FROM #variables.prefix#extremecache 
				WHERE blog_id = '#variables.blogId#'
				AND entry_id = '#arguments.entry_id#'
			</cfoutput>
		</cfsavecontent>

		<cfset queryResult = variables.queryInterface.makeQuery(query, 0, true) />
		
		<cfif queryResult.recordcount>
			<!--- needs updating --->
			<cfsavecontent variable="query">
				<cfoutput>UPDATE #variables.prefix#extremecache
					SET filename = '#arguments.filename#', 
					address = '#arguments.address#', 
					createdOn = #now()#,
					isUpdating = #arguments.isUpdating#
					
					WHERE blog_id = '#variables.blogId#'
					AND entry_id = '#arguments.entry_id#'
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<!--- needs inserting --->
			<cfsavecontent variable="query">
				<cfoutput>INSERT INTO #variables.prefix#extremecache 
					VALUES ('#variables.blogId#', '#arguments.entry_id#', 
					'#arguments.filename#', '#arguments.address#', #now()#, #arguments.isUpdating#)
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfset variables.queryInterface.makeQuery(query,-1,false) />
		
	</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="removeAll" access="private" output="false">		
		
		<cfset var query = "" />

		<cfsavecontent variable="query">
			<cfoutput>UPDATE #variables.prefix#extremecache
				SET filename = '', 
				address = '', 
				createdOn = #now()#,
				isUpdating = 0
					
				WHERE blog_id = '#variables.blogId#'
			</cfoutput>
		</cfsavecontent>
		
		<cfset variables.queryInterface.makeQuery(query,-1,false) />
		
	</cffunction>
	
</cfcomponent>