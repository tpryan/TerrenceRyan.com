<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.linkHome" type="boolean" default="true" />    
<cfparam name="attributes.linkBlog" type="boolean" default="true" /> 
<cfparam name="attributes.linkAbout" type="boolean" default="true" />
    
<cfelse>
		<nav>
			<ul>
				<cfif attributes.linkHome>
				<li><a href="/">Home</a></li>
				<cfelse>
				<li>Home</li>
				</cfif>
				<cfif attributes.linkBlog>
				<li><a href="/blog">Blog</a></li>
				<cfelse>
				<li>Blog</li>
				</cfif>
				<cfif attributes.linkAbout>
				<li><a href="/about">About</a></li>	
				<cfelse>
				<li>About</li>
				</cfif>        
			</ul>
		</nav>
</cfif>
</cfprocessingdirective>
