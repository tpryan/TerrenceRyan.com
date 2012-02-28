<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">

<cfset title = request.blogManager.getPostsManager().getPostByNAme(request.externalData.postName).getTitle() />

<cf_wrapper id="blogpost" class="blog" title="#title# - TerrenceRyan.com">
<mango:Event name="beforeHtmlBodyStart" />
<mango:Post>	

	<section id="content">	
		<article>
			<header>
				<h1><mango:PostProperty title /></h1>
				<time datetime="<mango:PostProperty date dateformat='yyyy-mm-dd' />" pubdate><mango:PostProperty date dateformat="mmmm dd, yyyy" /></time>
				<p><mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#respond" title="Comment on <mango:PostProperty title />"><mango:PostProperty ifCommentCountGT="0"><mango:PostProperty commentCount /> Comment<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></mango:PostProperty><mango:PostProperty ifCommentCountLT="1">No Comments</mango:PostProperty></a></mango:PostProperty></p>
			</header>
			
			<mango:PostProperty body />
			
			<footer>
				<mango:Event name="beforePostContentEnd" template="post" mode="full" />
				
				<section class="tagged">
						
					<h3>Tags:</h3> 
					<p><mango:Categories><mango:Category>
					<a href="<mango:CategoryProperty link />" title="View all posts in  <mango:CategoryProperty title />" rel="category tag">
						<mango:CategoryProperty title />
					</a> <mango:Category ifCurrentIsNotLast>&middot; </mango:Category></mango:Category>
					</mango:Categories>
					</p>
				</section>
			</footer>
			
			
			<section id="comments">
				<p class="comments_headers"><mango:PostProperty commentCount /> response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty><mango:PostProperty ifCommentCountLT="1">s</mango:PostProperty><mango:PostProperty ifcommentsallowed> so far &darr;</mango:PostProperty></p>
			
				<ul id="comment_list">
					<mango:Comments>
					<mango:Comment>
					<li class="comment <mango:CommentProperty ifIsAuthor> author</mango:CommentProperty>" id="comment-<mango:CommentProperty id />">
						<article class="comment">
							<p class="comment_meta">
								<span class="comment_num"><a href="#comment-<mango:CommentProperty id />" title="Permalink to this comment"><mango:CommentProperty currentCount /></a></span>
								<strong><mango:CommentProperty ifhasurl><a href='<mango:CommentProperty url />' rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty></strong>
								<time datetime="<mango:CommentProperty date dateformat='yyyy-mm-dd' />" ><mango:CommentProperty date dateformat="mmm d, yyyy" /> at <mango:CommentProperty time /></time>
							</p>
						
							<mango:CommentProperty content />
						</article>
					</li>
					</mango:Comment>
					</mango:Comments>
					
					<mango:PostProperty ifcommentsallowed ifCommentCountLT="1">
					<!-- If comments are open, but there are no comments. -->
					<li class="comment">
						<div class="entry">
							<p>There are no comments yet...Kick things off by filling out the form below.</p>
						</div>
					</li>
					</mango:PostProperty>
				</ul>
		
				<mango:PostProperty ifcommentsallowed>
					<!-- Comment Form -->
					<h3 id="respond" class="comments_headers">Leave a Comment</h3>
					<mango:Message ifMessageExists type="comment" status="error">
						<p class="error">There was a problem: <mango:Message text /></p>
					</mango:Message>
					<mango:Message ifMessageExists type="comment" status="success">
						<p class="message"><mango:Message text /></p>
					</mango:Message>
					
					<form method="post" action="#respond" id="comment_form">
						<input type="hidden" name="action" value="addComment" />
						<input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
						<input type="hidden" name="comment_parent" value="" />
						<mango:AuthenticatedAuthor ifIsLoggedIn>
						<p>You are logged in as <mango:AuthorProperty name /></p>
						<input type="hidden" name="comment_name" value="<mango:AuthorProperty name />" />
						<input type="hidden" name="comment_email" value="<mango:AuthorProperty email />" />
						<input type="hidden" name="comment_website" value="<mango:Blog url />" />
						</mango:AuthenticatedAuthor>
						
						<mango:AuthenticatedAuthor ifNotIsLoggedIn>
						<input id="author" class="text_input" type="text" name="comment_name" value="<mango:RequestVar name='comment_name' />" /> <label for="author"><strong>Name</strong></label><br />
						<input class="text_input" type="text" id="email" name="comment_email" value="<mango:RequestVar name='comment_email' />" /> <label for="email"><strong>Mail</strong> (it will not be displayed)</label><br />
						<input class="text_input" type="text" id="url" name="comment_website" size="30" value="<mango:RequestVar name='comment_website' />"  /> <label for="url"><strong>Website</strong></label><br />
						</mango:AuthenticatedAuthor>
						
						<textarea class="text_input text_area" id="comment" name="comment_content" rows="7"><mango:RequestVar name="comment_content" /></textarea><br />
						<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label><br />
						<mango:Event name="beforeCommentFormEnd" /></p>
						<input name="submit" class="form_submit" type="submit" id="submit" src="<mango:Blog skinurl />assets/images/submit_comment.gif" value="Submit" /><br />
					</form>
				</mango:PostProperty>
		
			</section> <!-- Close #comments container -->
	
		</article>			
		</mango:Post>	
		<section id="archives">
			<mangox:PodGroup locationId="sidebar" template="index">
				<template:sidebar />
			</mangox:PodGroup>	
		</section>
	
	</section>	
		
<mango:Event name="beforeFooterEnd" />
<mango:Event name="beforeHtmlBodyEnd" />
</cf_wrapper>