<cfsetting enablecfoutputonly="yes" showdebugoutput="no">
<cfsilent>
<cfset siteurl = application.settings.getURL() />
<cfset rootdir = application.settings.getRootdir() />

<cfset posts = application.blogService.listposts('desc') />
<cfset categories = application.blogService.listcategories() />




<cfset basepages = ArrayNew(1) />
<cfset ArrayAppend(basepages, "index.cfm") />
<cfset ArrayAppend(basepages, "about/index.cfm") />
<cfset ArrayAppend(basepages, "book/index.cfm") />
<cfset ArrayAppend(basepages, "job/index.cfm") />
<cfset ArrayAppend(basepages, "sitemap/index.cfm") />
<cfset ArrayAppend(basepages, "search/index.cfm") />


<cfcontent type="text/xml"> 

</cfsilent>
<cfoutput><?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<cfloop index="i" from="1" to="#ArrayLen(basepages)#">
	<url>
		<loc>#siteurl##basepages[i]#</loc>
		<lastmod>#DateFormat(GetFileInfo(rootdir & "/" & basepages[i]).Lastmodified,"yyyy-mm-dd")#</lastmod>
      	<changefreq>weekly</changefreq>
      	<priority>1.0</priority>
	</url>
	</cfloop>
	
	<cfloop query="posts">
	<url>
		<loc>#siteurl#blog/post.cfm/#name#</loc>
		<lastmod>#DateFormat(posted_on,"yyyy-mm-dd")#</lastmod>
      	<changefreq>monthly</changefreq>
      	<priority>0.8</priority>
	</url>
	</cfloop>
	
	<cfloop query="categories">
	<url>
		<loc>#siteurl#blog/archives.cfm/category/#name#</loc>
      	<changefreq>monthly</changefreq>
      	<priority>0.4</priority>
	</url>
	</cfloop>


</urlset></cfoutput>