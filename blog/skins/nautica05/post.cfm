<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<mango:Post>
<head>
  <title><mango:PostProperty title /> | <mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="keywords" content="" />
	<meta name="robots" content="index, follow" />

	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />

 	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/layout.css" media="screen, projection, tv " />
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/html.css" media="screen, projection, tv " />
	<mango:Event name="beforeHtmlHeadEnd" />
</head>

<body>
<mango:Event name="beforeHtmlBodyStart" />
<!-- #content: holds all except site footer - causes footer to stick to bottom -->
<div id="content">

  <!-- #header: holds the logo and top links -->
  <div id="header" class="width">
	<h1><a href="<mango:Blog basePath />"><mango:Blog title /></a> <span class="tagline"><mango:Blog tagline /></span></h1>
    <ul>
      <li><a href="<mango:Blog rssurl />" class="last">RSS Feeds</a></li>
    </ul>

  </div>
  <!-- #header end -->

  <!-- #headerImg: holds the main header image or flash -->
  <div id="headerImg" class="width"></div>

  <!-- #menu: the main large box site menu -->
  <div id="menu" class="width">
    <ul>
        <li><a href="<mango:Blog basePath />"><span class="title">Home</span></a></li>
		<mango:Pages><mango:Page>
			<li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><span class="title"><mango:PageProperty title /></span></a></li></mango:Page></mango:Pages>	
    </ul>

  </div>
  <!-- #menu end -->

  <!-- #page: holds the page content -->
  <div id="page">
    <!-- #columns: holds the columns of the page -->
    <div id="columns" class="widthPad">

    <!-- Left column -->
    <div class="floatLeft width73">

	      <!-- Start Post -->
		 <div class="post">
			<div class="date">
				<span class="month"><mango:PostProperty date dateformat="mmm" /></span>
				<span class="day"><mango:PostProperty date dateformat="d" /></span>
				<span class="month"><mango:PostProperty date dateformat="yyyy" /></span>
			</div>
			<div class="postExcerpt">
				<h2><mango:PostProperty title /></h2>
				<p>Posted by <mango:PostProperty author /> at <mango:PostProperty time /><mango:PostProperty ifcommentsallowed><a href="#comments"><br />
				<mango:PostProperty commentCount /> comments</a> - Categories: </mango:PostProperty>
				<mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a><mango:Category ifCurrentIsNotLast> | </mango:Category></mango:Category></mango:Categories></p>
			</div>
			<mango:PostProperty body />
			
			<div class="post-footer"><mango:Event name="beforePostContentEnd" /></div>
		</div>
		<!-- End Post -->
		<a name="comments"></a>
		<mango:PostProperty ifcommentsallowed>
			<!-- Comments -->
			<h1>Comments</h1>
			
			<mango:Comments>
				<mango:Comment><a name="comment-<mango:CommentProperty id />"></a>
				<div class="commentblock<mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatLeft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />   
				</mango:Comment>
			</div>
 			<div class="clear"></div>
			</mango:Comments>
			
			<a name="commentForm"></a>
			<form method="post" action="#commentForm" name="comments_form">
				<input type="hidden" name="action" value="addComment" />
				<input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
				<input type="hidden" name="comment_parent" value="" />
				<h3>Write your comment</h3>
                <mango:Message ifMessageExists type="comment" status="error">
					<p class="error dark">There was a problem: <mango:Message text /></p>
				</mango:Message>
				<mango:Message ifMessageExists type="comment" status="success">
					<p class="message dark"><mango:Message text /></p>
				</mango:Message>
				 <p>
					<label for="comment-author">Name</label><br />
                    <input id="comment-author" name="comment_name" size="30" value="<mango:RequestVar name="comment_name" />"  />
				</p>
				<p>
					<label for="comment-email">Email Address </label><br />
					<input id="comment-email" name="comment_email" size="30" value="<mango:RequestVar name="comment_email" />" /> (it will not be displayed)
				</p>
				<p>
					<label for="comment-url">Website</label><br />
					<input id="comment-url" name="comment_website" size="30" value="<mango:RequestVar name="comment_website" />" />
				</p>
				<p>
					<label for="comment-text">Your Comments</label><br />
					<textarea id="comment-text" name="comment_content" rows="10" cols="50"><mango:RequestVar name="comment_content" /></textarea>
				</p>
				<p>					
					<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label>
				</p>
				
				<mango:Event name="beforeCommentFormEnd" />
				<p><input type="submit" accesskey="s" name="submit_comment" id="comment-post" value="Post comment" class="button" />	</p>
			
           </form>
			
		</mango:PostProperty>
		
		<mango:PostProperty ifNotcommentsallowed  ifCommentCountGT="0">
		<!--- even though comments are not allowed, there might be old comments --->
				<h1>Comments</h1>
				<mango:Comments>
				<mango:Comment>
				<div class="commentblock<mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatLeft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />   
				</mango:Comment>
			</div>
 			<div class="clear"></div>
			</mango:Comments>
		</mango:PostProperty>
    </div>
    <!-- Left column end -->
</mango:Post>
    <!-- Right link column -->
    <div class="floatRight width25 lightBlueBg horzPad">
     	<mango:Event name="afterSideBarStart" number="1" />
		<template:sidebar />
		<mango:Event name="beforeSideBarEnd" number="1" />
    </div>
    <!-- Right links column end -->

    </div>
    <!-- #columns end -->

  </div>
  <!-- #page end -->

</div>
<!-- #content end -->

<!-- #footer: holds the site footer (logo and links) -->
<div id="footer">

  <!-- #bg: applies the site width and footer background -->
	<div id="bg" class="width">
		<mango:Event name="afterFooterStart" />
		<ul>
			<li><a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Powered by Mango Blog</a></li>
			<li>Design by <a href="http://www.studio7designs.com">studio7designs.com</a> ported by <a href="http://www.asfusion.com">AsFusion</a></li>
		</ul>
		<mango:Event name="beforeFooterEnd" />
  	</div>
  <!-- #bg end -->

</div>
<!-- #footer end -->
<mango:Event name="beforeHtmlBodyEnd" />
</body>
	
</html>