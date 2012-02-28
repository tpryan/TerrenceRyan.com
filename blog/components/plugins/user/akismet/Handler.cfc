<cfcomponent>


	<cfset variables.name = "Akismet">
	<cfset variables.id = "com.asfusion.mango.plugins.akismet">
	<cfset variables.package = "com/asfusion/mango/plugins/akismet"/>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset var blogid = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogid & "/" & variables.package />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.apiKey = variables.preferencesManager.get(path,"apiKey","YOUR_AKISMET_API_KEY") />
			<cfset variables.mode = variables.preferencesManager.get(path,"mode","moderate") />
			
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfset var path = variables.manager.getBlog().getId() & "/" & variables.package />
		<cfif NOT len(variables.preferencesManager.get(path,"apiKey",""))>
			<cfset variables.preferencesManager.put(path,"apiKey","YOUR_AKISMET_API_KEY") />
		</cfif>
		<cfif NOT len(variables.preferencesManager.get(path,"mode",""))>
			<cfset variables.preferencesManager.put(path,"mode","moderate") />
		</cfif>	
		<cfreturn "Akismet plugin activated. <br />You can now <a href='generic_settings.cfm?event=showAkismetSettings&amp;owner=askimet&amp;selected=showAkismetSettings'>Configure it</a>" />
	</cffunction>
	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<!--- TODO: Implement Method --->
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var js = "" />
			<cfset var outputData = "" />
			<cfset var link = "" />
			<cfset var page = "" />
			<cfset var data = ""/>
			<cfset var path = "" />
			<cfset var admin = "" />
			<cfset var verificationArgs = structnew() />
			<cfset var eventName = arguments.event.name />
			<cfset var comment = "" />
			<cfset var isSpam = false>
			<cfset var entry = "">
			
			<cfif eventName EQ "beforeCommentAdd">
				<cfset comment = arguments.event.getNewItem() />
				<cfif NOT len(comment.getAuthorId())>
					<!--- check for spam only if non-author --->
					<!--- test for spam --->
					<cfif NOT structkeyexists(variables, 'cfakismet')>
						<cfset initAskimet() />
					</cfif>
					
					<cfif variables.cfakismet.verifyKey()>				
						
						<cftry>
							<cftry>
							<cfset entry = variables.manager.getPostsmanager().getPostById(comment.getEntryId())>
							<cfcatch type="any">
								<cfset entry = variables.manager.getPagesManager().getPageById(comment.getEntryId()) />
							</cfcatch>
							</cftry>
							<cfset verificationArgs.CommentAuthor = comment.getCreatorName() />
							<cfset verificationArgs.CommentAuthorEmail = comment.getCreatorEmail() />
							<cfset verificationArgs.CommentAuthorURL = comment.getCreatorUrl() />
							<cfset verificationArgs.CommentContent = comment.getContent() />
							<cfset verificationArgs.Permalink  = variables.manager.getBlog().getUrl() & entry.getUrl() />
							
							<cfset isSpam = variables.cfakismet.isCommentSpam(argumentCollection= verificationArgs) />					
							
							<cfcatch type="any"></cfcatch>
						</cftry>
						
						<cfif isSpam and variables.mode EQ "moderate">
							<cfset comment.setApproved(0) />
							<cfset comment.setRating(-1) />
						<cfelseif isSpam and variables.mode EQ "reject">
							<cfset arguments.event.message.status = "error" />
							<cfset arguments.event.message.text = "Comment was marked as spam and could not be submitted" />
							<cfset arguments.event.continueProcess = false />
						</cfif>
					</cfif>
				</cfif>
			<!--- admin nav event --->
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "askimet">
				<cfset link.page = "settings" />
				<cfset link.title = "Akismet" />
				<cfset link.eventName = "showAkismetSettings" />
				
				<cfset arguments.event.addLink(link)>
			
			<!--- admin event, make sure user is logged in --->
			<cfelseif eventName EQ "showAkismetSettings" AND variables.manager.isCurrentUserLoggedIn()>
				<cfset data = arguments.event.getData() />				
				<cfif structkeyexists(data.externaldata,"apply")>
					<cfset variables.apiKey = data.externaldata.apiKey />
					<cfset variables.mode = data.externaldata.mode />
					<cfset path = variables.manager.getBlog().getId() & "/" & variables.package />
					<cfset variables.preferencesManager.put(path,"apiKey",variables.apiKey) />
					<cfset variables.preferencesManager.put(path,"mode",variables.mode) />
					
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("Settings updated")/>
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change message --->
					<cfset data.message.setTitle("Akismet settings") />
					<cfset data.message.setData(page) />
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="initAskimet" access="private">
		
		<cfset variables.cfakismet = createObject("component","CFAkismet").init()>
		<cfset variables.cfakismet.setBlogURL(variables.manager.getBlog().getUrl())>
		<cfset variables.cfakismet.setKey(variables.apiKey)>
		<cfset variables.cfakismet.setApplicationName("Mango " & variables.manager.getVersion())>
		
	</cffunction>

</cfcomponent>