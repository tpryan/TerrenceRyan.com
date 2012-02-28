<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">
    
    <cfif structKeyExists(url, "reset")>
        <cfcache action ="flush">
    </cfif>    
    
    
	<!--- recent posts --->
	
	<cfcache key="trblogsidebar" action="cache"  timespan="#CreateTimeSpan(1,0,0,0)#" >
	
	<!--- categories with RSS --->
	<mangox:TemplatePod id="categories" title="Categories">
		<ul>
		<mango:Categories>
			<mango:Category>
			<li><a href="<mango:CategoryProperty rssurl />" class="category_rss">
					<img src="<mango:Blog skinurl />assets/images/icon_rss.gif">
				</a> 
				<a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />">
					<mango:CategoryProperty title />
				</a> 
			</li>
			</mango:Category>
		</mango:Categories>
		</ul>
	</mangox:TemplatePod>
	

	
	<!--- all archives by month --->
	<mangox:TemplatePod id="monthly-archives" title="Monthly Archives">
			<ul><mango:Archives type="month" ><mango:Archive>
				<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li></mango:Archive></mango:Archives>
			</ul>
	</mangox:TemplatePod>
	
	<!--- category cloud --->
	<mangox:TemplatePod id="tagcloud" title="Tag Cloud">
		<mangox:CategoryCloud />
	</mangox:TemplatePod>
	
	
	
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods>
		<mangox:Pod>
			<mangox:PodProperty ifHasTitle>
			<section id="<mangox:PodProperty id />" class="widget">
				<h2><mangox:PodProperty title /></h2>
				<mangox:PodProperty content />
			</section>
			</mangox:PodProperty>
		</mangox:Pod>
		<mangox:Pod><!--- output the content as is, good for "templatePods" --->
			<mangox:PodProperty ifNotHasTitle>
				<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
	</mangox:Pods>
	
	
	</cfcache>
</cfif>