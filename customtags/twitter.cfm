<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.count" default="0" type="numeric" >	
	
<cfif thisTag.executionMode is "start">
<cfelse>
	<cfscript>
	
		tweets = cacheGet("terrenceryan_tweets");
		
		if (isNull(tweets) or not IsNull(url.reset_cache)){
			try{
				
				lanyrdurl = "http://twitter.com/statuses/user_timeline/775187.rss";	
				httpService = new http(url=lanyrdurl);
				result = httpService.send().getPrefix().fileContent;
				tweetObj = new terrenceryan.cfc.utility.tweet();
			
				tweets = tweetObj.convertTwitterXMLToQuery(result);
				cachePut("terrenceryan_tweets", tweets, CreateTimeSpan(0,0,15,0));
			}
			catch(any e){
				tweets = queryNew('');
			}
		
		}	
	
	if (attributes.count < 1){
		attributes.count = tweets.recordCount;
	}	

 	
		
	</cfscript>
	
	<cfif tweets.recordCount gt 0>
		<cfoutput query="tweets" maxrows="#attributes.count#">
			<div class="tweet item">
				<blockquote>
				<p>#title#</p>
				</blockquote>
				<time><a href="#link#">#DateFormat(pubdate, "mmmm d, yyyy")#</a></time>
				
				
			</div>
		</cfoutput>	
	<cfelse>
		<p>No tweets.</p>
	</cfif>
</cfif>
</cfprocessingdirective>