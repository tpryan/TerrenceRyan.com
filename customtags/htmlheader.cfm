<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.title" type="string" default="TerrenceRyan.com" />
<cfif thisTag.executionMode is "start">
<cfelse>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<cfoutput><title>#attributes.title#</title></cfoutput>
<meta name="viewport" content="width=device-width" />
<link rel="stylesheet" href="/css/base.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/css/desktop.css" type="text/css" media="screen and (min-width: 768px) and (min-device-width: 768px)" />
<link rel="alternate" type="application/rss+xml" title="RSS Feeds" href="http://feeds.feedburner.com/Terrenceryan" />
<link rel="EditURI" type="application/rsd+xml" title="RSD" href="/blog/api" />
<link rel="shortcut icon" href="/favicon.ico" />

<cfif not structkeyExists(url, "disablewf") >
<script type="text/javascript" src="http://use.typekit.com/ceu6pwf.js"></script>
<script type="text/javascript">try{Typekit.load();}catch(e){}</script>
<style type="text/css">
  .wf-loading body {
    visibility: hidden;
  }
</style>
</cfif>
<!--[if lt IE 9]>

<script type="text/javascript">
 document.createElement('header');
 document.createElement('hgroup');
 document.createElement('nav');
 document.createElement('menu');
 document.createElement('section');
 document.createElement('article');
 document.createElement('aside');
 document.createElement('footer');
</script>
<![endif]-->

<!--[if IE]>
<link rel="stylesheet" href="/css/ie.css" type="text/css" />
<![endif]-->
</head>   
    
</cfif>
</cfprocessingdirective>
