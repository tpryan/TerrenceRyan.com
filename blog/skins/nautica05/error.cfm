<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title><mango:Message title /> | Error</title>
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />	
	<meta name="robots" content="noindex, nofollow" />

	<link rel="stylesheet" href="skins/nautica05/assets/styles/main.css" type="text/css" title="Style" media="screen" />

 	<link rel="stylesheet" type="text/css" href="skins/nautica05/assets/styles/layout.css" media="screen, projection, tv " />
	<link rel="stylesheet" type="text/css" href="skins/nautica05/assets/styles/html.css" media="screen, projection, tv " />
</head>
<body>
<!-- #content: holds all except site footer - causes footer to stick to bottom -->
<div id="content">

  <!-- #header: holds the logo and top links -->
  <div id="header" class="width">
	<h1>Error</h1>
  </div>
  <!-- #header end -->


  <!-- #headerImg: holds the main header image or flash -->
  <div id="headerImg" class="width"></div>

  <!-- #menu: the main large box site menu -->
  <div id="menu" class="width">

  </div>
  <!-- #menu end -->

  <!-- #page: holds the page content -->
  <div id="page">


    <!-- #columns: holds the columns of the page -->
    <div id="columns" class="widthPad">


    <!-- Left  column -->
    <div class="floatLeft width100">
		<h1><mango:Message title /></h1>
        
		<div class="post">
			<mango:Message text />
			<mango:Message data />
		</div>
				
	 </div>
    <!-- Single column end -->


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

		<ul>
			<li><a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Powered by Mango Blog</a></li>
			<li>Design by <a href="http://www.studio7designs.com">studio7designs.com</a> ported by <a href="http://www.asfusion.com">AsFusion</a></li>
		</ul>

  	</div>
  <!-- #bg end -->

</div>
<!-- #footer end -->
</body>	
</html>
