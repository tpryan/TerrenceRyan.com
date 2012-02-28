<cfset root = "/" />
<cfset posts = application.blogService.listposts('desc') />
<cfset categories = application.blogService.listcategories() />
    
<cfsetting showdebugoutput="false" >
<cf_wrapper id="sitemap" class="focus">
		<section id="content">
			<h2>Sitemap</h2>
			
			<h3>All my content</h3>
		
			<ul>
				<cfoutput><li><a href="#root#index.cfm">Home<a/></cfoutput>
					<ul>
						<cfoutput>
						<li><a href="#root#about">About<a/></li>
						<li><a href="#root#book">Book<a/></li>
						<li><a href="#root#job">Job<a/></li>
						<li><a href="#root#blog/index.cfm">Blog<a/>
						</cfoutput>
							<ul>
								<li>Categories
									<ul>
									<cfoutput query="categories"><li><a href="#root#blog/archives.cfm/category/#name#">#title#<a/></li></cfoutput>
									</ul>
								</li>
								<li>Posts by Month
									<ul>
									<cfoutput query="posts" group="month">
									<li>#MonthAsString(month)# #year#
										<ul>
											<cfoutput><li><a href="#root#blog/post.cfm/#name#">#title#<a/></li></li></cfoutput>
										</ul>
									</li>
									</cfoutput>
									</ul>
								</li>
							</ul>	
						</li>
					</ul>
				
				</li>
			</ul> 
		
		</section>
</cf_wrapper>		    