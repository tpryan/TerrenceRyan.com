component{


	public function init(required string apikey, required string apiurl, required string userID){
		variables.apikey = arguments.apikey;
		variables.apiurl = arguments.apiurl;
		variables.userID = arguments.userID;
	
	}

	public function getSlideShows(){
		local.result = "";
		local.methodURL = variables.apiurl & "?method=getSlideShows" & "&apikey=" & variables.apikey & "&createdBy=" & variables.userID;
		local.httpObj = New http();
		
		httpObj.setURL(local.methodURL);
		result = httpObj.send();
		if (isJson(result.getprefix().FileContent)){
			local.returnQuery = DeserializeJSON(result.getprefix().FileContent, false);
		}	
		else{
			local.returnQuery = QueryNew("slideshowid,lastpublisheddate");
		}
		
		return returnQuery;
	}

}
