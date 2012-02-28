<cfcomponent>

	

<!---*****************************************************--->
<!---init--->
<!---This is the pseudo constructor that allows us to play little object games.--->
<!---*****************************************************--->
<cffunction access="public" name="init" output="FALSE" returntype="any" hint="This is the pseudo constructor that allows us to play little object games." > 
	<cfargument name="properties" type="any" required="yes" hint="Some grouping of items that will be the list of known properties for the bean. " />
	<cfargument name="delimiter" type="string" default="," hint="If passing in a list of properties, this is the delimiter of that list." />
	
	<cfset var i= 0 />
	<cfset var item = "" />
	
	
	<cfif IsStruct(arguments.properties)>
		<cfset variables.internal.properties = arguments.properties />
	<cfelseif IsArray(arguments.properties)>
		<cfloop index="i" from="1" to="#ArrayLen(arguments.properties)#">
			<cfset variables.internal.properties[arguments.properties[i]] = ""/>
		</cfloop>
	<cfelse>	
		<cfloop list="#arguments.properties#" index="item">
			<cfset variables.internal.properties[item] = ""/>
		</cfloop>
	</cfif>
		
	<cfset variables.internal.initialized = TRUE />
	
	
	<cfreturn This />
</cffunction>


<cffunction access="public" name="onMissingMethod">
	<cfargument name="missingMethodName" />
	<cfargument name="missingMethodArguments" />
      
	<cfset var attribute = "" />
	
	<cfif CompareNoCase(left(arguments.missingMethodName, 3),"get") eq 0>
		<cfset attribute = Right(arguments.missingMethodName, len(arguments.missingMethodName)-3 ) />
		<cfreturn get(attribute) />
	<cfelseif CompareNoCase(left(arguments.missingMethodName, 7),"display") eq 0>	
		<cfset attribute = Right(arguments.missingMethodName, len(arguments.missingMethodName)-7 ) />
		<cfreturn get(attribute) />
	<cfelseif CompareNoCase(left(arguments.missingMethodName, 3),"set") eq 0>	
		<cfset attribute = Right(arguments.missingMethodName, len(arguments.missingMethodName)-3 ) />
		
		
		<cfreturn set(attribute, arguments.missingMethodArguments[1]) />	
	</cfif>
     
   
</cffunction>
	
<cffunction access="public" name="get" output="false" returntype="any" hint="The default get operation. " >
	<cfargument name="attribute" type="string" required="yes" default="" hint="The attribute to retrieve." />
	
	<cfset testInitialized() />
	<cfset testPropertyExists(arguments.attribute) />

	<cfreturn variables.internal.properties[arguments.attribute] />
</cffunction>


	
	
<cffunction access="public" name="set" output="false" returntype="string" hint="Sets a value on the IBO." >
	<cfargument name="attribute" type="string" required="yes" hint="The attribute to set." />
	<cfargument name="value" type="any" required="yes" hint="The value to set." />
	
	<cfset testInitialized() />
	<cfset testPropertyExists(arguments.attribute) />
	
	<cfset variables.internal.properties[arguments.attribute] = arguments.value />
	
</cffunction>

<cffunction access="private" name="testInitialized" output="false" returntype="void" hint="Ensures the IBO is initialized." >
	<cfif not structKeyExists(variables, "internal") or not structKeyExists(variables.internal, "initialized")  or not variables.internal.initialized>
		<cfthrow message="Bean not initialized" detail="The Bean must be passed an array, a struct, or a list that initializes it." />
	</cfif>

</cffunction>	


<cffunction access="private" name="testPropertyExists" output="false" returntype="void" hint="Tests to see if the input property actually was set in the init. " >
	<cfargument name="property" type="string" required="yes" hint="The property to test." />
	
	<cfif not structKeyExists(variables.internal.properties, arguments.property) >
		<cfthrow message="Property not in bean." detail="You have attempted to access a property [#Ucase(arguments.property)#] that was not present when the bean was defined." />
	</cfif>
	
</cffunction>	

<cffunction access="public" name="debug" output="false" returntype="struct" hint="Returns the internal state of the application. " >
	<cfreturn variables.internal />
</cffunction>

</cfcomponent>