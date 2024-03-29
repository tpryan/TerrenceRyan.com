<cfcomponent name="Setup">
	
	<cfset variables.defaults = structnew() />
	<cfset variables.defaults["id"] = "default"/>
	<cfset variables.defaults["charset"] = "utf-8"/>
	<cfset variables.defaults["tagline"] = "A Mango for you"/>
	<cfset variables.defaults["description"] = "A mango blog (edit your blog description in the administration)"/>
	<cfset variables.defaults["skin"] = "cutline"/>
	<cfset variables.defaults["categoryName"] = "default"/>
	<cfset variables.defaults["categoryTitle"] = "Default"/>
	<cfset variables.defaults["systemPlugins"] = "SubscriptionHandler,Links,Statistics,PodManager,RevisionManager"/>
	<cfset variables.defaults["userPlugins"] = "cfformprotect,formRememberer,colorcoding,linkify,paragraphFormatter"/>
			
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="init" access="public" output="false" returntype="Setup">
		<cfargument name="address" type="String" required="true" />
		<cfargument name="datasourcename" type="String" required="true" />
		<cfargument name="dbType" type="String" required="true" />
		<cfargument name="prefix" type="String" required="false" default="" />
		<cfargument name="username" type="String" required="false" default="" />
		<cfargument name="password" type="String" required="false" default="" />

			<cfset variables.dsn = arguments.datasourcename  />
			<cfset variables.dbType = arguments.dbType  />
			<cfset variables.prefix = arguments.prefix  />
			<cfset variables.dsnUsername = arguments.username  />
			<cfset variables.dsnPassword = arguments.password  />
			<!--- attempt to get the components path --->
			<cfset variables.componentPath = replacenocase(GetMetaData(this).name,"admin.setup.Setup","components.") />
			<cftry>
				<cfset createObject("component",variables.componentPath & "utilities.PreferencesFile")>
			<cfcatch type="any">
				<!--- if we catch a problem, it means there was a problem finding the path --->
				<cfset variables.componentPath = replace(GetPathFromURL(arguments.address),"/",".",'all') & "components." />
				<cfset variables.componentPath = right(variables.componentPath,len(variables.componentPath)-1) />
				<cfset createObject("component",variables.componentPath & "utilities.PreferencesFile")>
			</cfcatch>
			</cftry>
		<cfreturn this />
	
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="checkSystem" access="public" output="false" returntype="any">
		<!--- check cffile --->
		<!--- check directory permissions --->
		<!--- check Verity availability --->
	
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="setupDatabase" access="public" output="false" returntype="struct">
			<cfset var setup = "" />
			<cfset var result = structnew() />
			<cfset var prefix = variables.prefix />
			<cfset var dsn = variables.dsn />
			<cfset var dbType = variables.dbType />
			<cfset var username = variables.dsnUsername />
			<cfset var password = variables.dsnPassword />
			<cfset result.status = true />
			<cfset result.message =  "" />
			
			<cftry>

				<cfinclude template="#dbType#.sql">
			
			<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail/>
			</cfcatch>
			</cftry>

		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addCFDatasource" access="public" output="false" returntype="struct">
		<cfargument name="cfadminpassword" type="String" required="true" />
		<cfargument name="datasourcename" type="String" required="true" />
		<cfargument name="dbName" type="String" required="true" />
		<cfargument name="host" type="String" required="true" />
		<cfargument name="dbType" type="String" required="true" />
		<cfargument name="username" type="String" required="false" />
		<cfargument name="password" type="String" required="false" />
		
			<cfset var ds = "" />
			<cfset var result = structnew() />
			<cfset var dsn = structnew() />
			<cfset var dsexists = true />
			<cfset var dsObj = ""/>
			<cfset result.status = false />
			<cfset result.message =  "" />
		<cfif server.coldfusion.productName eq "ColdFusion Server">
			<cfinclude template="addCFDatasource.cfm">
		<cfelse>
			<cfinclude template="addRailoDatasource.cfm">
		</cfif>
		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addAuthor" access="public" output="false" returntype="struct">
		<cfargument name="name" type="String" required="false" />
		<cfargument name="username" type="String" required="false" />
		<cfargument name="password" type="String" required="false" />
		<cfargument name="email" type="String" required="false" />

			<cfset var qinsertauthor = "" />
			<cfset var result = structnew() />
			<cfset var admin = ""/>
			<cfset var id = createUUID() />
			<cfset result.status = false />
			<cfset result.message =  "" />
		<cftry>
			<cfset admin = variables.blog.getAdministrator()>
			<cfset result = admin.newAuthor(arguments.username,arguments.password,arguments.name,arguments.email,'','','administrator') />

			<cfset result.status = result.message.getstatus() EQ "success">
			<cfset result.message = result.message.getText() />
			<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
		</cftry>

		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addBlog" access="public" output="false" returntype="struct">
		<cfargument name="title" type="String" required="false" />
		<cfargument name="address" type="String" required="false" />
		
			<cfset var qinsertblog = "" />
			<cfset var result = structnew() />
			<cfset result.status = true />
			<cfset result.message =  "" />
			<!--- add back slash if there isn't' --->
			
			<cfif right(arguments.address,1) NEQ "/">
				<cfset arguments.address = arguments.address & "/">
			</cfif>
			<cftry>
	
			<cfquery name="qinsertblog" datasource="#variables.dsn#" username="#variables.dsnUsername#" password="#variables.dsnPassword#">
				INSERT INTO #variables.prefix#blog
				(id, title,tagline,skin,url,charset,basePath, description,plugins,systemplugins)
				VALUES (
				'#variables.defaults["id"]#',
				<cfqueryparam value="#arguments.title#" cfsqltype="CF_SQL_VARCHAR" maxlength="150"/>,
				'#variables.defaults["tagline"]#',
				'#variables.defaults["skin"]#',
				<cfqueryparam value="#arguments.address#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>,
				'#variables.defaults["charset"]#',
				<cfqueryparam value="#GetPathFromURL(arguments.address)#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>,
				'#variables.defaults["description"]#',
				'#variables.defaults["userPlugins"]#',
				'#variables.defaults["systemPlugins"]#')
		  </cfquery>

		<cfset variables.blog = createobject("component",variables.componentPath & "Mango").init(variables.config,
				variables.defaults["id"],
				variables.path)>
		<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
		</cftry>

		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addData" access="public" output="false" returntype="struct">
		
			<cfset var addDataQuery = "" />
			<cfset var result = structnew() />
			<cfset var admin = ""/>
			<cfset var categoryId = createUUID() />
			<cfset var local = structnew() />
			
			<cfset result.status = true />
			<cfset result.message =  "" />
			
			<cfif structkeyexists(variables,"blog")>
				<cftry>
				<cfset admin = variables.blog.getAdministrator()>
				<cfset admin.newCategory(variables.defaults["categoryTitle"]) />
				
				<cfset local.authors = admin.getAuthors() />
				<cfif arraylen(local.authors)>
					<!--- add a post --->
					<cfset local.post = admin.newPost("Hello World!", 
						"<p>Hello! and welcome to my blog. This is my first post just to see how things are working</p>",'',true,local.authors[1].getId()) />
					<!--- add a comment to that post. I am using the db direclty to avoid getting caught by plugins trying to check for spam --->
						<cfquery name="addDataQuery"  datasource="#variables.dsn#" username="#variables.dsnUsername#" password="#variables.dsnPassword#">
								INSERT INTO #variables.prefix#comment ( id, entry_id, content, creator_name, creator_email, creator_url, created_on, approved, rating)
								VALUES ('#createUUID()#', '#local.post.newPost.getId()#', 'Looking forward to your blog :)
								(This is a test comment)', 'Mango Blog', 'info@mangoblog.org', 'http://www.mangoblog.org', <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP"/>, 1, 0)
						</cfquery>

					<!--- add an archives page --->
					<cfset local.post = admin.newPage("Archives", 
						"<p>This is a sample page, which you can edit/delete from your administration.</p><p>If your theme has the custom template for archives, you will see a list of your post archives below.</p>",
						'',true, '', 'archives_index.cfm', 1, local.authors[1].getId(),false) />
				</cfif>
				<cfcatch type="any"><!--- it is not super important that we add this data ---></cfcatch>
				</cftry>
			<cfelse>
				<cfquery name="addDataQuery"  datasource="#variables.dsn#" username="#variables.dsnUsername#" password="#variables.dsnPassword#">
					INSERT INTO #variables.prefix#category
					(id,name,title,created_on,blog_id)
					VALUES ('#createUUID()#','#variables.defaults["categoryName"]#', '#variables.defaults["categoryTitle"]#',
					<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP"/>,'#variables.defaults["id"]#')
		  		</cfquery>
		  	</cfif>

		<cfquery name="addDataQuery"  datasource="#variables.dsn#" username="#variables.dsnUsername#" password="#variables.dsnPassword#">
				INSERT INTO #variables.prefix#link_category ( id, name, blog_id)
				VALUES ('#categoryId#', 'Favorite Links', '#variables.defaults["id"]#')
		</cfquery>

		<cfquery name="addDataQuery"  datasource="#variables.dsn#" username="#variables.dsnUsername#" password="#variables.dsnPassword#">
				INSERT INTO #variables.prefix#link ( id, title, address, description, category_id)
				VALUES ('#createUUID()#', 'AsFusion', 'http://www.asfusion.com', 'A blog about ColdFusion and Flex', '#categoryId#')
		</cfquery>
		
		
			
		<cfreturn result/>
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="setupPlugins" access="public" output="false" returntype="any">
		<cfset var queue = ""/>
		<cfset var plugin = "" />
		<cfset var i = 0 />
		<cfset var list = "">
		
		<cfif structkeyexists(variables,"blog")>
			
			<cfset queue = variables.blog.getPluginQueue() />
			<cfset list = queue.getPluginNames() />
				
			<cfloop from="1" to="#arraylen(list)#" index="i">
				<cfset plugin = queue.getPlugin(list[i])>
				<cfset plugin.setup() />
			</cfloop>
		</cfif>

		<cfreturn/>
	</cffunction>		
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="saveConfig" access="public" output="false" returntype="struct">
		<cfargument name="path" type="String" required="true" />
		<cfargument name="pluginsDir" type="String" required="false" default="" />
		<cfargument name="assetsDir" type="String" required="false" default="" />
		<cfargument name="email" type="String" required="false" default="" />
		<cfargument name="id" type="String" required="false" default="#variables.defaults['id']#"/>
		<cfargument name="pluginsPath" type="String" required="false" default="plugins." />
		<cfargument name="applyUserPlugins" type="boolean" required="false" default="true" />
		
			<cfset var setup = "" />
			<cfset var result = structnew() />
			<cfset var local = structnew() />

			<cfset var config = createObject("component",variables.componentPath & "utilities.PreferencesFile").init("#arguments.path#config.cfm")>
			<cfset variables.config = "#arguments.path#config.cfm" />
			<cfset variables.path = arguments.path />
			<cfset result.status = true />
			<cfset result.message =  "" />
			
			<cfif NOT len(arguments.assetsDir)>
				<cfset arguments.assetsDir = "{baseDirectory}assets/content/" />
			</cfif>
			
			<cfif NOT len(arguments.pluginsDir)>
				<cfset arguments.pluginsDir = "{componentsDirectory}plugins/" />
			</cfif>
			
			<cfset local.isCF8 = server.coldfusion.productname is "ColdFusion Server" and 
				listFirst(server.coldfusion.productversion) gte 8 />
			<cfif local.isCF8>
				<cfset local.threaded = '1' />
			<cfelse>
				<cfset local.threaded = '0' />
			</cfif>
			<cfset config.put('generalSettings/system','enableThreads', local.threaded) />
			
			<!--- datasource --->
			<cfset config.put("generalSettings/dataSource", "name", variables.dsn)/>
			<cfset config.put("generalSettings/dataSource", "type", variables.dbType)/>
			<cfset config.put("generalSettings/dataSource", "username", variables.dsnUsername) />
			<cfset config.put("generalSettings/dataSource", "password",  variables.dsnPassword)/>
			<cfset config.put("generalSettings/dataSource", "tablePrefix", variables.prefix )/>
			
			<!--- mailserver --->
			<cfset config.put("generalSettings/mailServer", "server", "")/>
			<cfset config.put("generalSettings/mailServer", "username", "") />
			<cfset config.put("generalSettings/mailServer", "password",  "")/>
			<cfset config.put("generalSettings/mailServer", "defaultFromAddress",  arguments.email)/>
			
			<!--- blog settings for this id --->
			<cfset config.put(arguments.id & "/blogsettings","language", "en") />
			<cfset config.put(arguments.id & "/blogsettings","searchUrl", "archives.cfm/search/") />
			<cfset config.put(arguments.id & "/blogsettings","postUrl", "post.cfm/{postName}") />
			<cfset config.put(arguments.id & "/blogsettings","authorUrl", "author.cfm/{authorAlias}") />
			<cfset config.put(arguments.id & "/blogsettings","archivesUrl", "archives.cfm/") />
			<cfset config.put(arguments.id & "/blogsettings","categoryUrl", "archives.cfm/category/{categoryName}") />
			<cfset config.put(arguments.id & "/blogsettings","pageUrl", "page.cfm/{pageHierarchyNames}{pageName}") />
			<cfset config.put(arguments.id & "/blogsettings","rssUrl", "feeds/rss.cfm") />
			<cfset config.put(arguments.id & "/blogsettings","atomUrl", "feeds/atom.cfm") />
			<cfset config.put(arguments.id & "/blogsettings","apiUrl", "api") />
			<cfset config.put(arguments.id & "/blogsettings","skinsDirectory", "{baseDirectory}skins/") />
			<cfset config.put(arguments.id & "/blogsettings","useFriendlyUrls", "1") />
			<cfset config.put(arguments.id & "/plugins","directory", arguments.pluginsDir) />
			<cfset config.put(arguments.id & "/plugins","path", arguments.pluginsPath) />
			
			<!--- search settings, use database --->
			<cfset config.put(arguments.id & "/searchSettings","component", "search.DatabaseSimple") />
			<cfset config.put(arguments.id & "/searchSettings/settings/dataSource", "name", variables.dsn)/>
			<cfset config.put(arguments.id & "/searchSettings/settings/dataSource", "type", variables.dbType)/>
			<cfset config.put(arguments.id & "/searchSettings/settings/dataSource", "username", variables.dsnUsername) />
			<cfset config.put(arguments.id & "/searchSettings/settings/dataSource", "password",  variables.dsnPassword)/>
			<cfset config.put(arguments.id & "/searchSettings/settings/dataSource", "tablePrefix", variables.prefix )/>
			
			<cfset config.put(arguments.id & "/blogsettings/admin/customPanels","directory", "{baseDirectory}admin/custompanels/") />
			<cfset config.put(arguments.id & "/blogsettings/admin/customPanels","path", "custompanels/") />
			
			<cfset config.put(arguments.id & "/blogsettings/assets","directory", arguments.assetsDir) />
			<cfset config.put(arguments.id & "/blogsettings/assets","path", "assets/content/") />
			
			<cfset config.put(arguments.id & "/authorization","methods", "native") />
			<cfset config.put(arguments.id & "/authorization/settings","component", "") />
			
			<cfif NOT listfindnocase(variables.defaults["userPlugins"],"blogcfcRedirecter")>
				<cftry>
					<cfdirectory directory="#arguments.path#components/plugins/user/blogcfcRedirecter" action="delete" recurse="true" />
					<cfcatch type="any" />
				</cftry>
			</cfif>
		<cfreturn result/>
	</cffunction>
	
<cfinclude template="lib.cfm">


</cfcomponent>