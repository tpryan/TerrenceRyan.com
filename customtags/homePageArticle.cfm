<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.count" type="numeric" default="5">	
	
<cfelse>
	<cfsilent>
	
	<cfscript>
		posts = cacheGet("terrenceryan_homepage_posts");
		
		if (isNull(posts) or not IsNull(url.reset_cache) OR posts.recordcount != attributes.count){
			posts =  application.blogService.listPosts("desc", attributes.count);
			cachePut("terrenceryan_homepage_posts", posts, CreateTimeSpan(1,0,0,0));
			
		}	
	</cfscript>
	</cfsilent>
	<cfoutput query="posts">
			<article class="item">
				<h3><a href="blog/post.cfm/#name#">#title#</a></h3>
				<time>#DateFormat(posted_on, "mmmm d, yyyy")#</time>
				#excerpt#
			</article>		
	</cfoutput>	
</cfif>
</cfprocessingdirective>


