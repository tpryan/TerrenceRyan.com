component{

	public query function convertTwitterXMLToQuery(required string twitterXML){
		var content = XMLParse(arguments.twitterXML);
		var result = QueryNew("title,pubdate,link");
		
		var i = 0;
		
		for (i=1; i <= ArrayLen(content.rss.channel.item); i++){
			QueryAddRow(result);
			QuerySetCell(result, "title", replace(content.rss.channel.item[i].title.XMLText, "tpryan:", "", "once"));
			QuerySetCell(result, "pubdate", parseTwitterDate(content.rss.channel.item[i].pubdate.XMLText));
			QuerySetCell(result, "link", content.rss.channel.item[i].link.XMLText);
		}
		
		
		
		return result;
	}
	
	private date function parseTwitterDate(required string date){
		local.start = find(", ", arguments.date) + 2;
		local.end = find(" ", arguments.date, local.start);
		local.date = mid(arguments.date, local.start, local.end - local.start);
		local.month = mid(arguments.date, local.end + 1, 3);
		local.year = mid(arguments.date, local.end + 5, 4);
		
		switch(local.month) {
		    case "Jan":
		         local.month = 1;
		         break;
		    case "Feb":
		         local.month = 2;
		         break;
		    case "Mar":
		         local.month = 3;
		         break;
		    case "Apr":
		         local.month = 4;
		         break;
		    case "May":
		         local.month = 5;
		         break;
		    case "Jun":
		         local.month = 6;
		         break;
		    case "Jul":
		         local.month = 7;
		         break;
		    case "Aug":
		         local.month = 8;
		         break;
		    case "Sep":
		         local.month = 9;
		         break;
		    case "Oct":
		         local.month = 10;
		         break;
		    case "Nov":
		         local.month = 11;
		         break;
		    case "Dec":
		         local.month = 12;
		         break;                
		}
		return createdate(local.year, local.month, local.date);
		
	}


}
