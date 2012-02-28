<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.linkHome" type="boolean" default="true" />    
<cfparam name="attributes.linkBlog" type="boolean" default="true" /> 
<cfparam name="attributes.linkAbout" type="boolean" default="true" />
<cfparam name="attributes.showHeaderNav" type="boolean" default="true" />
<cfparam name="attributes.showBigPictures" type="boolean" default="false" />
<cfparam name="attributes.showLittlePicture" type="boolean" default="false" />    
    
<cfif thisTag.executionMode is "start">
    
<cfelse>
	<cfset age = dateDiff("yyyy",CreateDate(1976,12,19),now()) />
<header>
	<hgroup>
		<h1><a href="/">TerrenceRyan.com</a></h1>
		<h2>I'm a <cfoutput>#age#</cfoutput> year old redhead geek from Philly. <br /> 
			I'm currently a Developer Evangelist for <a href="/job">Adobe</a>.</br>
			Also the author of <a href="/book">Driving Technical Change</a>
		</h2>
		<cfif attributes.showBigPictures>
		<a href="/about"><img src="/headshot.jpg" width="160" height="230" alt="Headshot of Terrence Ryan" /></a>
		<a href="/book"><img src="/book.jpg" width="160" height="230" alt="Cover of Driving Technical Change" /></a>
		</cfif>
		<cfif attributes.showLittlePicture>
		<a href="/about"><img src="/headshot.png" width="55" height="80" alt="Headshot of Terrence Ryan" /></a>
		</cfif>
		<cfif attributes.showHeaderNav>
		<cf_headerNav />
		</cfif>	
	</hgroup>
</header>   
</cfif>
</cfprocessingdirective>
