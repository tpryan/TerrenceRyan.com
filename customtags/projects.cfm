<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.count" default="0" type="numeric" >	
	
<cfif thisTag.executionMode is "start">
<cfelse>
	<cfscript>
	
		projects = cacheGet("terrenceryan_github_projects");
		
		if (isNull(projects) or not IsNull(url.reset_cache)){
			try{
				githuburl = application.githubSettings.getUrl();	;	
				httpService = new http(url=githuburl);
				result = httpService.send().getPrefix().fileContent;
				
				github = new terrenceryan.cfc.utility.github();
				projects = github.convertToQuery(result);
				
				cachePut("terrenceryan_github_projects", projects, CreateTimeSpan(1,0,0,0));
			}
			catch(any e){
				projects = queryNew('');
			}
		}	
	
	if (attributes.count < 1){
		attributes.count = projects.recordCount;
	}	
		
	</cfscript>
	
	
	<cfif projects.recordCount gt 0>
		<cfquery name="projects" dbtype="query" maxrows="#attributes.count#">
			SELECT *
			FROM projects
			ORDER BY updatedAT desc
		</cfquery>
		
		<cfoutput query="projects">
			<div class="project">
				<h3><a href="#projects.url[currentRow]#">#name#</a></h3>
				<p>#description#</p>
			</div>
		</cfoutput>	
	<cfelse>
		<p>Either I have deleted all my projects in a fit of rage, or 
		I'm having trouble talking to github.com.  Neither is more likely then the other.</p>
	</cfif>
</cfif>
</cfprocessingdirective>