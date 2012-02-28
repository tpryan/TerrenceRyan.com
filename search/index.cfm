<cfsetting showdebugoutput="false" >
<cf_wrapper id="searchpage" class="focus">
		<section id="content">
			<h2>Search</h2>
			
		<cfif structKeyExists(url, "q")>
			<h3 class="blurb">Results</h3>	
		<cfelse>
			<h3 class="blurb">Perform a search</h3>
		</cfif>
		<cf_googleForm /><br />
		
		<cf_googleResults />	
		
		</section>
</cf_wrapper>

<cfsavecontent variable="jsToInject">
	<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" >
		$(document).ready(function() {
			 resizeFooter();
		});
		
		$(window).resize(function() {
			 resizeFooter();
		});
		
		function resizeFooter(){
		
			var neededHeight = $(window).height() -($("footer").offset().top );
			$("footer").height(neededHeight);
		}
		
	</script>
</cfsavecontent>

<cfhtmlhead text="#jsToInject#">			    