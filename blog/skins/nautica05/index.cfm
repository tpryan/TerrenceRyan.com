<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title><mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
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
	<h1><mango:Blog title /> <span class="tagline"><mango:Blog tagline /></span></h1>
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

      <h1>Recent <span class="dark">Posts</span></h1>

      <!-- Start Post -->
		<mango:Posts count="3">
			<mango:Post>
				 <div class="post">
					<div class="date">
						<span class="month"><mango:PostProperty date dateformat="mmm" /></span>
						<span class="day"><mango:PostProperty date dateformat="d" /></span>
						<span class="month"><mango:PostProperty date dateformat="yyyy" /></span>
	        		</div>
	        		<div class="postExcerpt">
						<h2><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></h2>
						<mango:PostProperty ifhasExcerpt excerpt>
							<p><strong><a href="<mango:PostProperty link />">Read more...</a></strong></p>
						</mango:PostProperty>
						<mango:PostProperty ifnothasExcerpt body />
						
						<p><mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#comments"><mango:PostProperty commentCount /> comments</a> - </mango:PostProperty>Posted by <mango:PostProperty author /> at <mango:PostProperty time /> - Categories: <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a><mango:Category ifCurrentIsNotLast> | </mango:Category></mango:Category></mango:Categories>
						</p>
					</div>
				</div>		
			</mango:Post>
		</mango:Posts>
      <!-- End Post -->
	
	<mango:Posts ifCountGT="0" count="1" from="4">
	<h1>Previous <span class="dark">Posts</span></h1></mango:Posts>
	<mango:Posts count="4" from="4">
		<mango:Post>
		<div class="post">
			<div class="date">
				<span class="month"><mango:PostProperty date dateformat="mmm" /></span>
				<span class="day"><mango:PostProperty date dateformat="d" /></span>
      		</div>
      		<div class="postExcerpt">
				<h2><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></h2>
				<p><mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#comments"><mango:PostProperty commentCount /> comments</a> - </mango:PostProperty>Posted by <mango:PostProperty author /> at <mango:PostProperty time /> - Categories: <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a> | </mango:Category></mango:Categories>
					</p>
			</div>
		</div>
		</mango:Post>
	</mango:Posts>
	
	<mango:Archive pageSize="7">
		<mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&lt; Previous Entries</a></mango:ArchiveProperty></mango:Archive>
	
    </div>
    <!-- Left column end -->

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
