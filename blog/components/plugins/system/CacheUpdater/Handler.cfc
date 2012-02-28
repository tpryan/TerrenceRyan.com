<cfcomponent>
		
	<cfset variables.id = "">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		
		<cfset variables.manager = arguments.mainManager />
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
		<!--- TODO: Implement Method --->
		<cfreturn />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<!--- TODO: Implement Method --->
		<cfreturn />
	</cffunction>

	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

		<cfset var obj = "" />
		<cfset var eventString = "" />
		<cfset var admin = variables.manager.getAdministrator() />	
		<cfset var user = "" />
		<cfset var eventName = arguments.event.getName()/>
		<cfset var parentId = "" />
		
		<cfif eventName EQ "afterPostAdd">
					<!--- we don't need to do anything when a post is added --->
					
		<cfelseif eventName EQ "afterPostUpdate">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "postUpdated|" & obj.getId() />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPostsManager().updateEvent(eventString) />
										
		<cfelseif eventName EQ "afterPostDelete">
					<cfset obj = arguments.event.getOldItem() />					
					<cfset eventString = "postDeleted|" & obj.getId() />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPostsManager().updateEvent(eventString) />										

		<cfelseif eventName EQ "afterPageAdd">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "pageAdded|" & obj.getId() />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPagesManager().updateEvent(eventString) />	

		<cfelseif eventName EQ "afterPageUpdate">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "pageUpdated|" & obj.getId() />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPagesManager().updateEvent(eventString) />	
					
					<cfset parentId = arguments.event.getOldItem().getParentPageId() />
					<cfif len(parentId)>
						<cfset eventString = "pageUpdated|" & parentId />
						<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
						<cfset variables.manager.getPagesManager().updateEvent(eventString) />
					</cfif>	

		<cfelseif eventName EQ "afterPageDelete">
					<cfset obj = arguments.event.getOldItem() />					
					<cfset eventString = "pageDeleted|" & obj.getId() />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPagesManager().updateEvent(eventString) />	
					
					<cfset eventString = "pageUpdated|" & obj.getParentPageId() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
					<cfset variables.manager.getPagesManager().updateEvent(eventString) />	

		<cfelseif eventName EQ "afterBlogUpdate">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "blogUpdated" />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
		
		<cfelseif eventName EQ "afterCommentAdd">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "postUpdated|" & obj.getEntryId() />
					<cfset variables.manager.getPostsManager().updateEvent(eventString) />
		
		<cfelseif eventName EQ "afterCommentDelete">
					<cfset obj = arguments.event.getOldItem() />
					<cfset eventString = "postUpdated|" & obj.getEntryId() />
					<cfset variables.manager.getPostsManager().updateEvent(eventString) />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
		
		<cfelseif eventName EQ "afterCommentUpdate">
					<cfset obj = arguments.event.getNewItem() />
					<cfset eventString = "postUpdated|" & obj.getEntryId() />
					<cfset variables.manager.getPostsManager().updateEvent(eventString) />
					<cfset user = arguments.event.getChangeByUser() />
					<cfset admin.notifyAPI(user.getUsername(),user.getPassword(),eventString) />
		
		<cfelseif eventName EQ "afterCategoryUpdate">
		</cfif>
											
		<cfreturn />
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
		<cfreturn arguments.event />
	</cffunction>
	

</cfcomponent>