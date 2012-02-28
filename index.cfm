<cfset appearanceCount = 3 />
<cfset blogCount = 3 />
<cfset projectCount = 3 />
<cfset presoCount = 3 />



<cfsetting showdebugoutput="false">
<cf_wrapper showBigPictures="true" id="index" class="home" linkHome="false" showHeaderNav = "false" >
<div id="content">
	<div id="primarycontent">
		<div id="posts" class="pod">
			<h2><a href="/blog">I Write</a></h2>
			<cf_homePageArticle count="#blogCount#" />
			<p class="externalref">View more on <a href="/blog">my blog</a>.</p>
		</div>
		<div id="events" class="pod">
			<h2><a href="http://lanyrd.com/profile/tpryan/">I Speak</a></h2>
			<cf_appearances count="#appearanceCount#" />
			<p class="externalref">View more on <a href="http://lanyrd.com/profile/tpryan/">lanyrd.com</a></p>
			
			<cfif actualEventCount lt blogCount> 
				<h2><a href="http://twitter.com/tpryan">I Tweet</a></h2>
				<cf_twitter count="1" />
				<p class="externalref">Follow me on <a href="http://twitter.com/tpryan">twitter.com</a></p>
			</cfif>
		</div>
		
	</div>

	<div id="secondarycontent">
		<div id="projects" class="pod">
			<h2><a href="https://github.com/tpryan">I Code</a></h2>
			<cf_projects count = "#projectCount#" />
			<p class="externalref">View more on <a href="https://github.com/tpryan">github.com</a>.</p>
		</div>
			
		<div id="presos" class="pod">
			<h2><a href="">I Present</a></h2>
			<cf_presos count = "#presoCount#" />
			<p class="externalref">View more on <a href="http://www.slideshare.net/tpryan/">slideshare.com</a>.</p>
		</div>
	</div>	
</div>
</cf_wrapper>