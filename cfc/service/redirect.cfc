component{


	public function init(required string baseurl){
		variables.baseurl = arguments.baseurl;
    	variables.redirects = {};
		
		redirects['/blog/rss.cfm'] = baseurl & "blog/feeds/rss.cfm";
		redirects['/search.cfm'] = baseurl & "search";
		redirects['/about.cfm'] = baseurl & "about";
		redirects['/contact.cfm'] = baseurl & "contact";
		redirects['/sitemap.cfm'] = baseurl & "sitemap";
		redirects['/blog/rss.cfm'] = baseurl & "blog/feeds/rss.cfm";
			
    	return This;
    }
    

	public string function getRedirectURL(required string targetPage){
		
	
		if (structKeyExists(redirects, arguments.targetPage)){
			return redirects[arguments.targetPage];
		}
		else{
			return baseurl & "/404?page=#arguments.targetPage#";
		}
	
		
	}

}
