<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">
    
    <cfif structKeyExists(url, "reset")>
        <cfcache action ="flush">
    </cfif>    
    
    <li class="widget">
		<cf_bookad />
	</li>
    
	<!--- recent posts --->
	<mangox:TemplatePod id="posts" title="Recent Entries">
	<ul>
		<mango:Posts count="5" source="recent">
		<mango:Post><li><span class="recent_date"><mango:PostProperty date dateformat="m.dd" /></span> <a href="<mango:PostProperty link />"><mango:PostProperty title /></a></li>
		</mango:Post>
		</mango:Posts>
		<mango:Archive pageSize="5"><mango:ArchiveProperty ifHasNextPage><li><a href="<mango:ArchiveProperty link />" title="Visit the archives!">Visit the archives for more!</a></li></mango:ArchiveProperty></mango:Archive>
	</ul>
	</mangox:TemplatePod>
	
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
	

	<!--- category cloud --->
	<mangox:TemplatePod id="category-cloud" title="Tag Cloud">
		<mangox:CategoryCloud />
	</mangox:TemplatePod>
	
	<!--- all archives by month --->
	<mangox:TemplatePod id="monthly-archives" title="Monthly Archives">
		<ul><mango:Archives type="month" ><mango:Archive>
			<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li></mango:Archive></mango:Archives>
		</ul>
	</mangox:TemplatePod>
	
	<!--- all links by category --->
	<mangox:TemplatePod id="links-by-category">
		<mangox:LinkCategories>
			<mangox:LinkCategory>
			<li class="linkcat">
			<h2><mangox:LinkCategoryProperty name /></h2>
			</mangox:LinkCategory>
				<ul>
				<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
				</mangox:Link>
				</mangox:Links>
				</ul>
			</li>
		</mangox:LinkCategories>
	</mangox:TemplatePod>
	
	
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods>
		<mangox:Pod>
			<mangox:PodProperty ifHasTitle>
			<li class="widget">
				<h2><mangox:PodProperty title /></h2>
				<mangox:PodProperty content />
			</li>
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