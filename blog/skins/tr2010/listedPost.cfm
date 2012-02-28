<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">

    
    <mango:Post>	
		<article>
		    <header>
				<h3><a href="<mango:PostProperty link />" rel="bookmark" title="Permanent Link to <mango:PostProperty title />"><mango:PostProperty title /></a></h3>
				<h4><mango:PostProperty date dateformat="mmmm dd, yyyy" /> &middot; <mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#respond" title="Comment on <mango:PostProperty title />"><mango:PostProperty ifCommentCountGT="0"><mango:PostProperty commentCount /> Comment<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></mango:PostProperty><mango:PostProperty ifCommentCountLT="1">No Comments</mango:PostProperty></a></mango:PostProperty></h4>
			</header>
		
			<mango:PostProperty ifhasExcerpt excerpt>
			<p><a href="<mango:PostProperty link />" title="Read the rest of this entry">[Read more &rarr;]</a></p>
			</mango:PostProperty>
			<mango:PostProperty ifNotHasExcerpt body />
		
			<footer>
				<mango:Event name="beforePostContentEnd" template="index" mode="excerpt" />
			
				<p class="tagged"><span class="add_comment"><mango:PostProperty ifcommentsallowed>&rarr; <a href="<mango:PostProperty link />#respond" title="Comment on <mango:PostProperty title />"><mango:PostProperty ifCommentCountGT="0"><mango:PostProperty commentCount /> Comment<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></mango:PostProperty><mango:PostProperty ifCommentCountLT="1">No Comments</mango:PostProperty></a></mango:PostProperty></span> 
				<strong>Tags:</strong> 
				<mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="View all posts in  <mango:CategoryProperty title />" rel="category tag"><mango:CategoryProperty title /></a> <mango:Category ifCurrentIsNotLast>&middot; </mango:Category></mango:Category></mango:Categories>
				</p>
			</footer>
		</article>
	</mango:Post>    
    
<cfelse>
    
    
    
</cfif>
</cfprocessingdirective>
