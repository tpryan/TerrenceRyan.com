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


	<cffunction name="list" output="FALSE" access="public"  returntype="query" hint="Gets a list of all appearances." >
		<cfargument name="n" type="numeric" default="-1" hint="" />
		
		<cfset var result ="">
		
	
		<cfquery datasource="#datasource#" name="result" maxrows="#n#">
			SELECT 		*, month(sessionStartTime) as sessionMonth, year(sessionStartTime) as sessionYear
			FROM 		appearances
			WHERE		sessionStartTime > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#" />
			ORDER BY 	sessionStartTime asc
		</cfquery>
		
		<cfreturn result />
	</cffunction>


</cfcomponent>