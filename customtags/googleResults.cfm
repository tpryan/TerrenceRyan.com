<!---    googleResults.cfm.cfm

AUTHOR				: tpryan 
CREATED				: 9/20/2008 
DESCRIPTION			: Displays results from a custom google search.  
---->

<cfprocessingdirective suppresswhitespace="yes">

	<div id="cse-search-results"></div>
	<script type="text/javascript">
	  var googleSearchIframeName = "cse-search-results";
	  var googleSearchFormName = "cse-search-box";
	  var googleSearchFrameWidth = (window.innerWidth || document.body.offsetWidth) - 40;
	  var googleSearchDomain = "www.google.com";
	  var googleSearchPath = "/cse";
	</script>
	<script type="text/javascript" src="http://www.google.com/afsonline/show_afs_search.js"></script>






</cfprocessingdirective>
<!--- In case you call as a tag  --->
<cfexit method="exittag" />