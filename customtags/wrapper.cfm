<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.id" type="string" default="" />
<cfparam name="attributes.class" type="string" default="" />    
<cfparam name="attributes.title" type="string" default="TerrenceRyan.com" />
<cfparam name="attributes.linkHome" type="boolean" default="true" />    
<cfparam name="attributes.linkBlog" type="boolean" default="true" /> 
<cfparam name="attributes.linkAbout" type="boolean" default="true" />
<cfparam name="attributes.showHeaderNav" type="boolean" default="true" />
<cfparam name="attributes.showBigPictures" type="boolean" default="false" />
<cfparam name="attributes.showLittlePicture" type="boolean" default="false" />         
        
<cfif thisTag.executionMode is "start">
	<cf_htmlheader title="#attributes.title#" />
	<cfoutput><body id="#attributes.id#" class="#attributes.class#"></cfoutput>
	<cf_header showBigPictures="#attributes.showBigPictures#" showLittlePicture ="#attributes.showLittlePicture#" linkHome="#attributes.linkHome#" linkBlog="#attributes.linkBlog#" linkAbout="#attributes.linkAbout#" showHeaderNav="#attributes.showHeaderNav#" />
<cfelse>
	<cf_footer />
<script type="text/javascript"> 
	var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script> 
<script type="text/javascript"> 
	var pageTracker = _gat._getTracker("UA-620739-3");
	pageTracker._trackPageview();
</script> 
</body>
</html>
</cfif>
</cfprocessingdirective>
