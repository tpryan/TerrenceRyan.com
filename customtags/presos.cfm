<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.count" default="0" type="numeric" >	
	
<cfif thisTag.executionMode is "start">
<cfelse>
	<cfscript>
	
		presos = cacheGet("terrenceryan_slideshare_presos");
		
		if (isNull(presos) or not IsNull(url.reset_cache)){
			try{
				key = application.slideshareSettings.getKey();
				secret = application.slideshareSettings.getSecret();
				ss = new terrenceryan.cfc.utility.slideshare(key,secret);
				presos = ss.getSlideShows(username='tpryan');
				cachePut("terrenceryan_slideshare_presos", presos, CreateTimeSpan(1,0,0,0));
		
			}
			catch(any e){
				presos = queryNew('');
			}
		}		
	
		if (attributes.count < 1){
			attributes.count = presos.recordCount;
		}	
		
	</cfscript>
	<cfif presos.recordCount gt 0>
		<cfquery name="presos" dbtype="query" maxrows="#attributes.count#">
			SELECT *
			FROM presos
		</cfquery>
		
		<cfoutput query="presos">
			<div class="item">
				<h3><a href="#permalink#">#title#</a></h3>
				<p>#description#</p>
			</div>
		</cfoutput>	
	<cfelse>
		<p>Either I have deleted all my presentations in a fit of rage, or 
		I'm having trouble talking to slideshre.net.  Neither is more likely then the other.</p>
	</cfif>
</cfif>
</cfprocessingdirective>