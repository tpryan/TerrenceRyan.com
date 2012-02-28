<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">
<mangox:PodGroup locationId="sidebar">
	<mangox:TemplatePod id="categories" title="Categories">
	<ul class="submenu1">
		<mango:Categories parent="">
			<mango:Category>
		       <li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a></li>
			</mango:Category>
			</mango:Categories>
	</ul>
	</mangox:TemplatePod>
	<mangox:TemplatePod id="monthly-archives">
	 <h3>Monthly <span class="dark">Archives</span></h3>
			
      <ul class="submenu1"><mango:Archives type="month"><mango:Archive>
        <li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
		</mango:Archive>
		</mango:Archives>
	  </ul>
	</mangox:TemplatePod>
	<mangox:TemplatePod id="search">
	<h3>Search <span class="dark">Archives</span></h3>
		<form name="searchForm" id="searchForm" method="get" action="<mango:Blog searchUrl />">
			<input type="text" name="term" value="Search For..." />
			<input class="button" type="submit" name="Submit" value="GO" />
		</form>
	</mangox:TemplatePod>
	
	<mangox:TemplatePod id="links-by-category">
		<!--- Links --->
		<mangox:LinkCategories>
			<mangox:LinkCategory ifCurrentIsEven>
			<h3><span class="dark"><mangox:LinkCategoryProperty name /></span></h3>
			</mangox:LinkCategory>
			<mangox:LinkCategory ifCurrentIsOdd>
			<h3><mangox:LinkCategoryProperty name /></h3>
			</mangox:LinkCategory>
			<ul class="submenu1">
			<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
				</mangox:Link>
			</mangox:Links>
			</ul>
		</mangox:LinkCategories>
	</mangox:TemplatePod>
	
	<!--- category cloud -- to add, uncomment here and in skin.xml
	<mangox:TemplatePod id="category-cloud" title="Tag Cloud">
		<p><mangox:CategoryCloud /></p>
	</mangox:TemplatePod>
	 --->
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods>
		<mangox:Pod>
			<mangox:PodProperty ifHasTitle>
				<mangox:Pod ifCurrentIsOdd><h3><span class="dark"><mangox:PodProperty title /></span></h3></mangox:Pod>
				<mangox:Pod ifCurrentIsEven><h3><mangox:PodProperty title /></h3></mangox:Pod>
			<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
		<mangox:Pod><!--- output the content as is, good for "templatePods" --->
			<mangox:PodProperty ifNotHasTitle>
				<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
	</mangox:Pods>
</mangox:PodGroup>
</cfif>