<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head profile="http://gmpg.org/xfn/11">
<mango:Post>
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<title><mango:PostProperty title /> &#8212; <mango:Blog title /></title>
	
	<meta name="generator" content="Mango <mango:Blog version />" />
	<mango:PostProperty ifHasCustomField='meta-description'>
		<meta name="description" content="<mango:PostProperty customfield='meta-description' />" />
	</mango:PostProperty>
	<mango:PostProperty ifNotHasCustomField='meta-description'>
		<meta name="description" content="<mango:Blog description />" />
	</mango:PostProperty>
	<link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/custom.css" type="text/css" media="screen" />
	<!--[if lte IE 7]>
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/ie7.css" media="screen" />
	<![endif]-->
	<!--[if lte IE 6]>
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/ie6.css" media="screen" />
	<![endif]-->
	<meta name="robots" content="index, follow" />
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	<mango:Event name="beforeHtmlHeadEnd" />
</head>
<body class="custom">
<mango:Event name="beforeHtmlBodyStart" />
<div id="container">
	<div id="masthead">
		<h1><a href="<mango:Blog url />"><mango:Blog title /></a></h1>
		<h3><mango:Blog tagline /></h3>
	</div>

	<ul id="nav">
		<li><a href="<mango:Blog basePath />">front page</a></li>
		<mango:Pages><mango:Page>
			<li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />">
				<mango:PageProperty title /></a></li>
			</mango:Page></mango:Pages>
		<li class="rss"><a href="<mango:Blog rssurl />">RSS</a></li>
	</ul>
	
	<div id="header_img">
		<img src="<mango:Blog skinurl />assets/images/header_2.jpg" width="770" height="140" alt="<mango:Blog title />" title="<mango:Blog title />" />
	</div>
	<div id="content_box">
		<div id="content" class="posts">
		
		<h2><mango:PostProperty title /></h2>
			<h4><mango:PostProperty date dateformat="mmmm d, yyyy" /> &middot; <mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#comments" title="Comment on <mango:PostProperty title />"><mango:PostProperty ifCommentCountGT="0"><mango:PostProperty commentCount /> Comment<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></mango:PostProperty><mango:PostProperty ifCommentCountLT="1">No Comments</mango:PostProperty></a></mango:PostProperty></h4>
			<div class="entry"><mango:PostProperty body /></div>
			
			<div class="entry-footer entry">
			<mango:Event name="beforePostContentEnd" template="post" mode="full" />
			</div>
			<p class="tagged"><strong>Tags:</strong> <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="View all posts in  <mango:CategoryProperty title />" rel="category tag"><mango:CategoryProperty title /></a> <mango:Category ifCurrentIsNotLast>&middot; </mango:Category></mango:Category></mango:Categories></p>
			<div class="clear"></div>

	<div id="comments">
		<h3 class="comments_headers"><mango:PostProperty commentCount /> response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty><mango:PostProperty ifCommentCountLT="1">s</mango:PostProperty><mango:PostProperty ifcommentsallowed> so far &darr;</mango:PostProperty></h3>
	
		<ul id="comment_list">
			<mango:Comments>
			<mango:Comment>
			<li class="comment <mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>" id="comment-<mango:CommentProperty id />">
				<p class="comment_meta">
					<span class="comment_num"><a href="#comment-<mango:CommentProperty id />" title="Permalink to this comment"><mango:CommentProperty currentCount /></a></span>
						<strong><mango:CommentProperty ifhasurl><a href='<mango:CommentProperty url />' rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> </strong>
						<span class="comment_time">// <mango:CommentProperty date dateformat="mmm d, yyyy" /> at <mango:CommentProperty time /></span>
				</p>
				<div class="entry">
					 <mango:CommentProperty content />
				</div>
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
		<p><input id="author" class="text_input" type="text" name="comment_name" value="<mango:RequestVar name='comment_name' />" /><label for="author"><strong>Name</strong></label></p>
		<p><input class="text_input" type="text" id="email" name="comment_email" value="<mango:RequestVar name='comment_email' />" /><label for="email"><strong>Mail</strong> (it will not be displayed)</label></p>
		<p><input class="text_input" type="text" id="url" name="comment_website" size="30" value="<mango:RequestVar name='comment_website' />"  /><label for="url"><strong>Website</strong></label></p>
		</mango:AuthenticatedAuthor>
		
		<p><textarea class="text_input text_area" id="comment" name="comment_content" rows="7"><mango:RequestVar name="comment_content" /></textarea></p>
		<p><input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label></p>
		<p><mango:Event name="beforeCommentFormEnd" /></p>
		<p><input name="submit" class="form_submit" type="submit" id="submit" src="<mango:Blog skinurl />assets/images/submit_comment.gif" value="Submit" /></p>
		</form>
</mango:PostProperty>
		
</div> <!-- Close #comments container -->
<div class="clear flat"></div>
</mango:Post>
				
		</div>
		
<div id="sidebar">
	<ul class="sidebar_list">
		<mangox:PodGroup locationId="sidebar" template="post">
			<template:sidebar />
		</mangox:PodGroup>	
	</ul>
	</div>
	</div>

	<div id="footer"><mango:Event name="afterFooterStart" />
		<p><mango:Blog title /> &mdash; <a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Powered by Mango Blog</a> &mdash; Design by <a href="http://www.tubetorial.com">Chris Pearson</a> ported by <a href="http://www.asfusion.com">AsFusion</a></p>
	<mango:Event name="beforeFooterEnd" />
	</div>
</div>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>
