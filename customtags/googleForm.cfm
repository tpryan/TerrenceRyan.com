<!---    googleForm.cfm.cfm

AUTHOR				: tpryan 
CREATED				: 9/20/2008 
DESCRIPTION			: Displays a custom google search form.  
---->

<cfprocessingdirective suppresswhitespace="yes">
		<form action="/search" id="cse-search-box">
		  <div>
		    <input type="hidden" name="cx" value="005516451334966889831:16iv_lqbbsc" />
		    <input type="hidden" name="cof" value="FORID:11" />
		    <input type="hidden" name="ie" value="UTF-8" />
		    <input type="text" name="q" size="31" />
		    <input type="submit" name="sa" value="Search" />
		  </div>
		</form>
		<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>
</cfprocessingdirective>
<!--- In case you call as a tag  --->
<cfexit method="exittag" />