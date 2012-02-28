<cfcomponent output="false">

<cfset variables.key = "">
<cfset variables.secret = "">

<cffunction name="init" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="secret" type="string" required="true">
	<cfargument name="timeout" type="numeric" required="false" default="9999">	
	<cfset variables.key = arguments.key>
	<cfset variables.secret = arguments.secret>
	<cfset variables.timeout = arguments.timeout>

	<cfreturn this>
</cffunction>

<cffunction name="getSecurityString" access="private" returnType="string" output="false" hint="I handle the security portion of the URL.">
	<cfset var s = "api_key=" & variables.key>
	<cfset var t = dateDiff("s", "January 1 1970 00:00", now())>
	<cfset var myhash = lcase(hash(variables.secret & t,"SHA","UTF-8"))>
	
	<cfset s = s & "&ts=#t#&hash=#myhash#">
	
	<cfreturn s>
</cffunction>

<cffunction name="getSlideShow" access="public" returnType="struct" output="false" hint="Get one slide show.">
	<cfargument name="slideid" type="any" required="true">
	<cfset var theurl = "http://www.slideshare.net/api/1/">
	<cfset var r = "">
	<cfset var results = "">
	<cfset var result = structNew()>
	
	<cfset theurl &= "get_slideshow?#getSecurityString()#&slideshow_id=#urlEncodedFormat(arguments.slideid)#">
	<cfhttp url="#theurl#" result="r" timeout="#variables.timeout#">
	<cfset results = xmlParse(r.fileContent)>

	<cfif r.responseheader.status_code is "500"> 
		<cfthrow message="SlideShareCFC Error">
	<cfelseif structKeyExists(results, "SlideShareServiceError")>
		<cfthrow message="SlideShareCFC Error: SlideShowID: #arguments.slideid# - #results.slideshareserviceerror.message.xmltext#">
	</cfif>

	<cfset result.embedcode = results.slideshows.slideshow.embedcode.xmlText>
	<cfset result.thumbnail = results.slideshows.slideshow.thumbnail.xmlText>
	<cfset result.title = results.slideshows.slideshow.title.xmlText>
	<cfset result.description = results.slideshows.slideshow.description.xmlText>
	<cfset result.status = results.slideshows.slideshow.status.xmlText>
	<cfset result.statusdescription = results.slideshows.slideshow.statusdescription.xmlText>
	<cfset result.permalink = results.slideshows.slideshow.permalink.xmlText>
	<cfset result.views = results.slideshows.slideshow.views.xmlText>
	<cfset result.tags = results.slideshows.slideshow.tags.xmlText>
	<cfset result.transcript = results.slideshows.slideshow.transcript.xmlText>
	<cfreturn result>
	
</cffunction>

<!--- todo, support tag/group --->
<cffunction name="getSlideShows" access="public" returnType="query" output="false" hint="Main function to get and parse results.">
	<cfargument name="username" type="string" required="false">
	<cfargument name="tag" type="string" required="false">
	<cfargument name="group" type="string" required="false">
		
	<cfset var r = "">
	<cfset var theurl = "http://www.slideshare.net/api/1/">
	<cfset var results = "">
	<cfset var ss = queryNew("user,total,embedcode,thumbnail,title,description,status,statusdescription,permalink,views,id")>
	<cfset var x = "">
	<cfset var node = "">
	<cfset var user = "">
	<cfset var total = "">
	
	<cfif not structKeyExists(arguments, "username") and not structKeyExists(arguments, "tag") and not structKeyExists(arguments, "group")>
		<cfthrow message="SlideShareCFC Error: getSlideShows must be provided with either a username, tag, or group argument.">
	</cfif>
	
	<cfif structKeyExists(arguments, "username")>
		<cfset theurl &= "get_slideshow_by_user?#getSecurityString()#&username_for=" & urlEncodedFormat(arguments.username)>
	</cfif>
	

	<cfhttp url="#theurl#" result="r" timeout="#variables.timeout#">

	<cfif r.filecontent is "Connection Timeout" or r.responseheader.status_code is "500"> 
		<cfthrow message="SlideShareCFC Error">
	</cfif>
	
	<cfif not isXML(r.fileContent)>
		<cfthrow message="SlideShareCFC Error: Invalid response from server">
	</cfif>

	<cfset results = xmlParse(r.fileContent)>

	<cfif structKeyExists(results, "SlideShareServiceError")>
		<cfthrow message="SlideShareCFC Error: #results.slideshareserviceerror.message.xmltext#">
	</cfif>

	<cfset user = results.user.name.xmlText>
	<cfset total = results.user.count.xmlText>

	<cfif total is 0>
		<cfreturn ss>
	</cfif>
		
	<cfloop index="x" from="1" to="#arrayLen(results.user.slideshow)#">
		<cfset node = results.user.slideshow[x]>
		<cfset queryAddRow(ss)>
		<cfset querySetCell(ss, "user", user)>
		<cfset querySetCell(ss, "total", total)>
		<cfset querySetCell(ss, "embedcode", node.embedcode.xmltext)>
		<cfset querySetCell(ss, "thumbnail", node.thumbnail.xmltext)>
		<cfset querySetCell(ss, "title", node.title.xmltext)>
		<cfset querySetCell(ss, "description", node.description.xmltext)>
		<cfset querySetCell(ss, "status", node.status.xmltext)>
		<cfset querySetCell(ss, "statusdescription", node.statusdescription.xmltext)>
		<cfset querySetCell(ss, "permalink", node.permalink.xmltext)>
		<cfset querySetCell(ss, "views", node.views.xmltext)>
		<cfset querySetCell(ss, "id", node.id.xmltext)>
		
	</cfloop>
	<cfreturn ss>
</cffunction>

<cffunction name="uploadSlideShow" access="public" returntype="numeric" output="false" hint="Upload a slide show.">
	<cfargument name="username" type="string" required="true" />
	<cfargument name="password" type="string" required="true" />
	<cfargument name="slideTitle" type="string" required="true" />
	<cfargument name="slidePath" required="true" hint="Absolute path of the powerpoint presentation on server"/>
	<cfargument name="slideDescription" type="string" required="false" />
	<cfargument name="slideTags" type="string" required="false" />
	
	<cfset var theurl = "http://www.slideshare.net/api/1/">
	<cfset var r = "">
	<cfset var SlideShowId = 0 />
	
	<cfset theurl &= "upload_slideshow?#getSecurityString()#&username=#urlEncodedFormat(arguments.username)#&password=#urlEncodedFormat(arguments.password)#&slideshow_title=#urlEncodedFormat(arguments.slideTitle)#">
	
	<cfhttp url="#theurl#" result="r" timeout="#variables.timeout#"  method="post">
		<cfhttpparam name="slideshow_srcfile" type="file" file="#arguments.slidePath#" mimetype="application/ms-powerpoint">
		<cfif structKeyExists(arguments, "slideDescription")>
			<cfhttpparam type="formfield" name="slideshow_description" value="#arguments.slideDescription#">
		</cfif>
		<cfif structKeyExists(arguments, "slideTags")>
			<cfhttpparam type="formfield" name="slideshow_tags" value="#arguments.slideTags#">
		</cfif>

	</cfhttp>
	
	<cfset r = xmlParse(r.fileContent) />
	
	<cfreturn val(r.SlideShowUploaded.SlideShowID.XmlText) />
</cffunction>

</cfcomponent>