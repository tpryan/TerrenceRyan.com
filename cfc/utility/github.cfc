component{
	public query function convertToQuery(required string rawJSON){
		var content = DeSerializeJSON(arguments.rawJSON).repositories;
		var result = queryNew("name,language,createdAt, updatedAt,url,description");
		
		
		for (i=1; i <= ArrayLen(content); i++){
			QueryAddRow(result);
			QuerySetCell(result, "name", content[i].name );
			if (structKeyExists(content[i], "language")){
				QuerySetCell(result, "language", content[i].language );
			}
			QuerySetCell(result, "description", content[i].description );
			QuerySetCell(result, "createdAt", parseGitHubDate(content[i]['created_at']) );
			QuerySetCell(result, "updatedAt", parseGitHubDate(content[i]['pushed_at']) );
			QuerySetCell(result, "url", content[i].url );
			
		}
		return result;
	
	}
	
	private date function parseGitHubDate(required string date){
		var dateSec = GetToken(arguments.date, 1);
		var year = 	GetToken(dateSec, 1, "/");
		var month = 	GetToken(dateSec, 2, "/");
		var day = 	GetToken(dateSec, 3, "/");
				
		return createDate(year, month, day);
		
	}

}