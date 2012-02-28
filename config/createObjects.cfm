<cfif FindNoCase('dev', cgi.server_name)>
	<cfset status = "local">
<cfelse>
	<cfset status = "prod">
</cfif>

<cfset application.coldSpringPath = getDirectoryFromPath(getCurrentTemplatePath()) & "/" & status & "/coldspring.xml.cfm" />

<!--- Create Coldspring Instance --->
<cfset application.cs = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
<cfset application.cs.loadBeansFromXmlFile(application.coldSpringPath ,true) />

<!--- Create Application Objects. --->
<cfset application.settings = application.cs.getBean('settings') />
<cfset application.debug = application.cs.getBean('debug') />
<cfset application.blogService = application.cs.getBean('blogService') />
<cfset application.error = application.cs.getBean('utility.error') />
<cfset application.cfakismet = application.cs.getBean('utility.cfakismet') />
<cfset application.cacheService= application.cs.getBean('cacheService') />
<cfset application.lanyrdSettings= application.cs.getBean('lanyrdSettings') />
<cfset application.githubSettings= application.cs.getBean('githHubSettings') />
<cfset application.slideshareSettings= application.cs.getBean('slideShareSettings') />
        
<cfset application.settings.setStatus(status) />

