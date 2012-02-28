<cfcomponent>

	<!---*****************************************************--->
	<!---init   --->
	<!---Psuedo constructor that allows us to play our object games. --->
	<!---*****************************************************--->
	<cffunction name="init" output="FALSE" access="public"  returntype="any" hint="Psuedo constructor that allows us to play our object games." >
		<cfargument name="datasource" type="string" required="TRUE" hint="The datasource to query against." />
		
		<cfset variables.datasource = arguments.datasource />
		
		<cfreturn This />
	</cffunction>


	<!---*****************************************************--->
	<!---listPosts   --->
	<!---Lists all of the posts in the blog. --->
	<!---*****************************************************--->
	<cffunction name="listPosts" output="FALSE" access="public"  returntype="query" hint="Lists all of the posts in the blog." >
		<cfargument name="asc" type="string" default="asc" hint="" />
		<cfargument name="limit" type="numeric" default="0" hint="" />
		<cfset var result = "" />
		
		<cfquery datasource="#variables.datasource#" name="result">
			SELECT       	e.name, e.title, p.posted_on,  
							year(p.posted_on) as year, month(p.posted_on) as month, 
							e.excerpt
			FROM         	entry e
			INNER JOIN 		post p on p.id = e.id
			WHERE 			e.status = 'published'		
			ORDER BY     	p.posted_on #arguments.asc#
			<cfif limit neq 0>
			Limit 0, #arguments.limit#
			</cfif>
		</cfquery>
	
		<cfreturn result />
	</cffunction>

	<!---*****************************************************--->
	<!---listCategories   --->
	<!---List all of the categories. --->
	<!---*****************************************************--->
	<cffunction name="listCategories" output="FALSE" access="public"  returntype="query" hint="List all of the categories." >
		<cfset var result = "" />
		
		<cfquery datasource="#variables.datasource#" name="result">
			SELECT     name, title
			FROM       category c
			ORDER BY   name
		</cfquery>
	
		<cfreturn result />
	
	</cffunction>
	
	<cffunction name="authenticate" output="FALSE" access="public"  returntype="boolean" hint="Determines if a username/password combo is good. " >
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		
		<cfquery datasource="#variables.datasource#" name="local.userQuery">
			SELECT     	id
			FROM       	author
			WHERE		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
		</cfquery>
		
		<cfset local.userid = userQuery.id />
		<cfset local.hashedPassword = hash(userid & arguments.password,"SHA") />
		
		<cfquery datasource="#variables.datasource#" name="local.authQuery">
			SELECT     	id
			FROM       	author
			WHERE		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
			AND			password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashedPassword#" />
		</cfquery>
		
		<cfif local.authQuery.recordCount eq 1>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	
	</cffunction>



</cfcomponent>