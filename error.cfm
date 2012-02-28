<cfsetting showdebugoutput="false" >
<cf_wrapper id="book" class="focus" >	
	
	<section id="content">
	
		<h2>Error</h2>

		<h3>Something has gone wrong...</h3>
		<p>Sorry about that. If it is any consolation, an email has been sent to an administrator. </p>
	

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



