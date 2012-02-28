<cfsetting showdebugoutput="false" >
<cfparam name="url.page" default=""  />

<cfif CompareNoCase(url.page, "/blog/rss.cfm") eq 0>
    <cfset redirect = new cfc.service.redirect(application.settings.geturl()) />
	<cflocation url="#redirect.getRedirectURL(url.page)#" addtoken="false"statuscode="301" />
</cfif>


<cf_wrapper id="404" class="focus">
		<section id="content">
			
			<section id="info">
				<h2>404 Not Found</h2>
				<h3>We could not find that.</h3>
				<p>Move it along, nothing to see here, you know the drill.</p>
				
			</section>
			<section id="action">
				<h2>Could these help?</h2>
				<ul>
					<li><a href="/sitemap">Sitemap</a></li>
					<li><a href="/search">Site Search</a></li>
				</ul>
			</section>
		</section>
</cf_wrapper>		



<cfscript>
	sendMail = true;
	
	pagesToSkip = FileRead(ExpandPath('./pages.xml'));
	pagesXML = XMLParse(pagesToSkip);
	
	for (i = 1; i <= ArrayLen(pagesXML.pages.page); i++){
		if (compareNocase(url.page, pagesXML.pages.page[i].XMLText) eq 0){
			sendMail = false;
			break;
		}
	}

</cfscript>

<cfif sendMail>
	You got 404 served.     
	<cfmail to="#application.settings.getAdminEmail()#" from="#application.settings.getAdminEmail()#" subject="404 on TerrenceRyan.com" type="html">
	
		<cfoutput>
		<table>
			<tr><th>Page requested:</th><td>#application.settings.geturl()##url.page#</p></td></tr>
			<tr><th>Remote Address:</th><td>#cgi.remote_addr#</td></tr>
			<tr><th>Remote Host:</th><td>#cgi.remote_host#</td></tr>
			<tr><th>Time:</th><td>#DateFormat(now())# #TimeFormat(now())#</td></tr>
			<tr><th>User Agent:</th><td>#cgi.HTTP_USER_AGENT#</td></tr>
		</table>
		</cfoutput>
	
	</cfmail>
</cfif>

<cfsavecontent variable="jsToInject">
	<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" >
		$(document).ready(function() {
			 resizeFooter();
		});
		
		$(window).resize(function() {
			 resizeFooter();
		});
		
		function resizeFooter(){
		
			var neededHeight = $(window).height() -($("footer").offset().top );
			$("footer").height(neededHeight);
		}
		
	</script>
</cfsavecontent>

<cfhtmlhead text="#jsToInject#">	