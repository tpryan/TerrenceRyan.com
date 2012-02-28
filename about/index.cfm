<cfsetting showdebugoutput="false" >
<cf_wrapper id="about" class="focus" linkAbout="false" >
		<section id="content" class="about">
			
			<section id="info">
				<h2>About Me</h2>
				<img src="headshot2011.jpg"  width="200" height="300">
				
				
				<h3>Current</h3>	
				<p>I'm a Worldwide Developer Evangelist for <a href="http://www.adobe.com/">Adobe</a>.  
				My job basically entails me traveling the world and 
				talking about the developer tools and technologies that Adobe has to offer or that we support. 
				To find out more, see about my <a href="/job">Job</a>. 
				</p>
				
				<p>I'm also the author of <em>Driving Technical Change.</em> It's about convinving reluctant co-workers 
				to adopt new tools and techniques.  To find out more, see about my <a href="/book">Book</a>. </p>
				
				
				
				<h3>Past</h3>
				<p>I went to University of Pennsylvania, and received a Bachelors of Art in Psychology.  While I was in school, I started 
				working in various Psychiatric clinical practices.  Gradually I shifted from psychological work to computing work. By the 
				time I got out of school, my desire to do psychology was gone, and there were tons of tech jobs available.</p>
				<p>I started out of school working at the Wharton School of Business. I moved from tech support to server admin to 
				system programmer to developer.  After 10 years there, I had done just about every technical job there is to do, and 
				decided programming was where I belonged. </p>
				
				
				<h3>Site</h3>
				<h4>Front End</h4>
				<p>This is my second attempt at building a semantic HTML5 site.</p>
				<p>I use Typekit to render <a href="https://typekit.com/fonts/league-gothic">League Gothic</a> 
				as a the header font <a href="https://typekit.com/fonts/warnock-pro">Warnock Pro</a> for the copy font. </p>
			 
				
				<h4>Backend</h4>	
				<p>The backend is powered by <a href="http://www.adobe.com/products/coldfusion/">ColdFusion 9</a>.</p>
				<p>The blog is powered by <a href="http://www.mangoblog.org/">MangoBlog</a>.</p> 
				
				<h4>Tools</h4>
				<p>I used <a href="http://browserlab.adobe.com">Browser Lab</a> to get the site working cross platform/browser.</p>	
				<p>The site was composed using <a href="http://www.adobe.com/products/fireworks/">Fireworks CS5</a>.</p>
				<p>The code was written using <a href="http://www.adobe.com/products/coldfusion/cfbuilder/features/?view=topfeatures">ColdFusion Builder</a>.</p>
			</section>
			
			<section id="action">
			<h2>Contact</h2>
			
			<cfparam name="url.method" type="string" default="display_form">
			<cfset bannedIpAddress = "83.149.74.179,204.15.134.196,24.39.181.180,200.88.223.98,67.161.171.10,72.130.30.69" />  
			<cfset bannedEmail = "adeptus@gmail.com,kevin777@gmail.com,sdfuheuhiuh230@gmail.com,info@uzshar.com" />  
			
			
			<cfswitch expression="#url.method#">
				<cfcase value="process_form">
					<cfparam name="form.name" type="string" default="">
					<cfparam name="form.email" type="string" default="">
					<cfparam name="form.text" type="string" default="">
			
					<cfset args = StructNew() />
			        <cfset args.CommentAuthor  = form.name />
			        <cfset args.CommentAuthorEmail  = form.email />
			        <cfset args.CommentContent  = form.text />
					<cfset args.CommentAuthorURL  = "" />
					<cfset args.Permalink  = "" />
			        
			        <cfset CommentIsSpam = application.cfakismet.isCommentSpam(ArgumentCollection=args) />
			
					<cfif CommentIsSpam>
							<h3 class="blurb">Spam!</span></h3>
							<p>Sorry, this email appears to be spam.</p>
						<cfabort>
					</cfif>
					
					<cfif len(form.name) gt 0 and len(form.email) gt 0 and len(form.text) gt 0 
						and not ListFind(bannedIpAddress, cgi.remote_addr, ",")
						and not ListFind(bannedEmail, form.email, ",")
						> 
					
						<cfmail to="terry@terrenceryan.com" from="#form.email#" subject="Mail from TerrenceRyan.com" type="html">
						#text#
						<br /><br /><br />
						
						<cfoutput>
						<table>
							<tr><th>Remote Address:</th><td>#cgi.remote_addr#</td></tr>
							<tr><th>Remote Host:</th><td>#cgi.remote_host#</td></tr>
							<tr><th>Time:</th><td>#DateFormat(now())# #TimeFormat(now())#</td></tr>
						</table>
						</cfoutput>
			
						</cfmail>
			
					
					</cfif>
					<cflocation url="#cgi.script_name#?method=confirm" addtoken="no">
				</cfcase>
				
				<cfcase value="confirm">
						<h3>I Will Get Back to You!</h3>
						<p>Thanks for your message, I'll be in touch as soon as I can. In the meantime, have a very nice day. </p>
				
			
				
				</cfcase>
			
				<cfcase value="display_form">
					
						
						<h3>Drop me a line.</h3>
						<cfform action="?method=process_form" method="post" name="contact_form" id="contact_form" >
							<label for="name">Name:</label><br />
							<cfinput type="text" name="name" id="name" size="50" maxlength="128" style="width: 250px;"  required="true" message="You gotta tell me who you are." /><br />
							<label for="email">Email:</label><br />
							<cfinput type="text" name="email" id="email" size="50" maxlength="128" style="width: 250px;"  required="true" message="You gotta give me a valid email." validate="email" /><br />
							<label for="text">Message:</label><br />
							<cftextarea name="text" cols="23" rows="7" id="text" columns="50" required="true" style="width: 250px;" message="You gotta say something." /><br />
							<input name="Submit" type="submit" value="Submit" class="submit" /><br />
						</cfform>
						
				
			
				</cfcase>
			</cfswitch>	
			<br /><br />
			<h3>Social Networks</h3>
	
	
			<table id="socialnetworks">
				<tr>
					<td class="username"><a href="http://www.facebook.com/terry.ryan" title="Facebook | Terrence Ryan">Terry.Ryan</a> </td>
					<td>
						<a href="http://www.facebook.com/terry.ryan" title="Facebook | Terrence Ryan">
							<img src="/static/img/facebookicon.png" height="55" width="116" alt="Facebook" />
						</a>
					</td>
				</tr>
				
				<tr>
					<td class="username"><a href="http://twitter.com/tpryan" title="Twitter / tpryan">tpryan</a> </td>
					<td>
						<a href="http://twitter.com/tpryan" title="Twitter / tpryan">
							<img src="/static/img/twitter.png" height="55" width="155" alt="Twitter" />
						</a>
					</td>
				</tr>
				
				<tr>
					<td class="username"><a href="http://www.linkedin.com/in/terrencepryan" title="LinkedIn: Terrence Ryan">TerrencePRyan</a> </td>
					<td>
						<a href="http://www.linkedin.com/in/terrencepryan" title="LinkedIn: Terrence Ryan">
						<img src="/static/img/linkedin-icon.png" height="35" width="121" alt="LinkedIn" />
					</a>	
					</td>
				</tr>
				
				<tr>
					<td class="username"><a href="https://github.com/tpryan" title="github: Terrence Ryan">tpryan</a> </td>
					<td>
						<a href="https://github.com/tpryan" title="github: Terrence Ryan">
						<img src="/static/img/githublogo.png" height="45" width="100" alt="github" />
					</a>	
					</td>
				</tr>
			
			</table>
			</section>
			
		</section>
	
</cf_wrapper>