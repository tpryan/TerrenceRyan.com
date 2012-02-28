<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.count" default="0" type="numeric" >
	
<cfif thisTag.executionMode is "start">
<cfelse>
	<cfscript>
	
		events = cacheGet("terrenceryan_lanyrd_events");
		
		if (isNull(events) or not IsNull(url.reset_cache)){
			try{
				lanyrdurl = application.lanyrdSettings.getUrl();	
				httpService = new http(url=lanyrdurl);
				result = httpService.send().getPrefix().fileContent;
				
				ical = new terrenceryan.cfc.utility.ical(result);
				present = now();
				today = CreateDate(year(present), month(present), day(present));
				 
				events = ical.getEvents(today);
				cachePut("terrenceryan_lanyrd_events", events, CreateTimeSpan(1,0,0,0));
		
			}
			catch(any e){
				events = queryNew('');
			}
		
		}	
	
	if (attributes.count < 1){
		attributes.count = events.recordCount;
	}
	
	caller.actualEventCount = events.recordcount;	
		
	</cfscript>
	<cfif events.recordCount gt 0>
		<cfoutput query="events" maxrows="#attributes.count#">
			<cfsilent>
			<cfset endDateMod = dateAdd("d",-1,endDate) />
			
			<cfset desc = replace(description, "\n\n", "$", "one") />
			<cfset desc = getToken(desc, 1, "$")/>
			
			<cfif FindNoCase("http://", desc) eq 1>
				<cfset desc = "" />
			</cfif>
			
			<cfif DateCompare(endDateMod,startDate) eq 0>
				<cfset formattedDate = DateFormat(startDate,"mmmm d") />
			<cfelse>	
				<cfif CompareNoCase(month(startDate), month(endDate)) neq 0>
					<cfset formattedDate = "#DateFormat(startDate,"mmmm d")# - #DateFormat(endDateMod,"mmmm d")#" />
				<cfelse>
					<cfset formattedDate = "#DateFormat(startDate,"mmmm d")# - #DateFormat(endDateMod,"d")#" />
				</cfif>
			</cfif>	
			
			
			</cfsilent>
			<div class="event item">
				<h3><a href="#events.url[events.currentRow]#">#summary#</a></h3>
				<time>#formattedDate#</time>
				<address>#location#</address>
				<cfif len(desc) gt 0><p>#Replace(desc, "/","/ ", "all")#</p></cfif>
			</div>
		</cfoutput>	
	<cfelse>
		<p>Whoa, there are no upcoming events.  I'll actually be at home for awhile. </p>
	</cfif>
</cfif>
</cfprocessingdirective>