<cfcomponent displayName="iCal" hint="A iCal processor." output="false">

	<cfset variables.data = "">
	
	<cffunction name="init" returnType="ical" access="public" output="false"
				hint="Init function for the CFC. Loads in the initial string data.">
		<cfargument name="data" type="string" required="true">
		
		<cfset variables.data = arguments.data>
		
		<cfreturn this>
	</cffunction>
	
	<cfscript>
		public query function getEventsFormatted(){
			var content = getEventsRaw();
			var i = 0;
			var results = queryNew("location,url,summary,startDate,endDate,description");
			
			for (i=1; i<=ArrayLen(content); i++){
				
				var start = content[i].dtstart.data;
				var startDate = CreateDate(left(start,4), mid(start,5,2) , right(start,2));
				var end = content[i].dtend.data;
				var endDate = CreateDate(left(end,4), mid(end,5,2) , right(end,2));	
						
				QueryAddRow(results);
				QuerySetCell(results, "location", content[i].location.data);
				QuerySetCell(results, "url", content[i].url.data);
				QuerySetCell(results, "summary", content[i].summary.data);
				QuerySetCell(results, "startDate", startDate);
				QuerySetCell(results, "endDate", endDate);
				QuerySetCell(results, "description", content[i].description.data);
			}
			
					
			
			return results;
		}	
	</cfscript>	
	
	<cffunction name="getEvents" returnType="query" access="public" output="false"
				hint="Gets the events from an iCal string.">
		<cfargument name="start" type="any" required="false" default="">
		<cfargument name="end" type="any" required="false" default="">		
		
		<cfset var data = getEventsFormatted() />
		
		<cfquery name="data" dbtype="query" >
			SELECT *
			FROM data
			WHERE 1=1	
			<cfif len(arguments.start)>
				AND startDate >= <cfqueryparam value="#arguments.start#" cfsqltype="cf_sql_timestamp" />
			</cfif>	
			
			<cfif len(arguments.end)>
				AND endDate <= <cfqueryparam value="#arguments.end#" cfsqltype="cf_sql_timestamp" />
			</cfif>
			ORDER BY startDate	
		</cfquery>
		
		<cfreturn data />	
					
	</cffunction>				
	
	
	<cffunction name="getEventsRaw" returnType="array" access="private" output="false"
				hint="Gets the events from an iCal string.">

		<cfset var marker = "BEGIN:VEVENT">
		<cfset var endmarker = "END:VEVENT">
		<cfset var eventStrArray = "">
		<cfset var eventSubString = "">
		<cfset var results = arrayNew(1)>
		<cfset var x = "">
		<cfset var eventStr = "">
		<cfset var line = "">
		<cfset var token = "">
		<cfset var eventData = "">
		<cfset var endPosition = "">
		<cfset var leftLine = "">
		<cfset var pos = "">
		<cfset var foundAt = "">
		<cfset var key = "">
		<cfset var value = "">
		<cfset var subline = "">

		<!--- Early exit if cached. --->
		<cfif structKeyExists(variables,"events")>
			<cfreturn variables.events>
		</cfif>

		<!--- translate the lines into packages of strings beginning and ending with our marker --->
		<!--- why didn't we use it in the var above? because it may be slow, and we have the
			  possibility to leave early if stuff is cached --->		
		<cfset eventStrArray = reGet(variables.data,"#marker#(.*?)#endmarker#")>	
		
		<cfloop index="x" from="1" to="#arrayLen(eventStrArray)#">
			<cfset eventSubString = replace(eventStrArray[x],marker,"")>
			<cfset eventSubString = replace(eventSubString,endmarker,"")>

			
			<!--- Now we have a format that looks like this:
			  KEY;PARAM:VALUE
			
			params are optional
			params can be multiple:   ;x=1;y=2
			params can have multiple values, but we don't care:   ;x=a,b;y=c,d
			VALUE can also be a list, but we don't need to parse it. It can also contain a :
			PARAM can also contain a :, but it will be quoted
				ex: DESCRIPTION;ALTREP="http://www.wiz.org":The Fall'98 Wild Wizards Conference - - Las Vegas, NV, USA			

			It is possible that a long line will "wrap". This means a line break and a line with a space in the beginning. 
			We can translate anly LINEBREAK+SPACE to just one line. 
			space can be ascii 32 or 9
			
			--->
			<!--- First, let's "fold" the lines in --->
			<cfset eventSubString = replace(eventSubString, chr(13) & chr(10) & chr(9), "", "all")>
			<cfset eventSubString = replace(eventSubString, chr(13) & chr(10) & chr(32), "", "all")>
			<!--- This makes it easier for our looping --->
			<cfset eventSubString = replace(eventSubString, chr(13), chr(10), "all")>
			<!--- get rid of blanks --->
			<cfset eventSubString = trim(replace(eventSubString, chr(10) & chr(10), chr(10), "all"))>
			
			<cfset eventData = structNew()>
			
			<cfloop index="line" list="#eventSubString#" delimiters="#chr(10)#">
				<!--- this token is the first entry before ; or : --->
				<cfset token = listFirst(line, ";,:")>
				<cfset eventData[token] = structNew()>
				<cfset eventData[token].params = structNew()>
				<cfset eventData[token].data = "">
				<!--- remove the token --->
				<cfset line = replace(line,token,"")>
				<!--- now we either have params or a value. We need to see if we have funky colons inside quotes --->
				<!--- we can do this by using a new UDF, findNotInQuotes. This will find a char that ISNT inside quotes. --->
				<!--- first though, do we have to bother? if we _start_ with a :, we just have data --->
				
				<cfif left(line,1) is ";">
					<cfset line = right(line, len(line)-1)>
					<!--- so, we need to move through LINE, going until we get a NON in quotes :, or a NON in quotes , --->
					<!--- let's first find the END of our section by getting the firstNonInQuotes colon --->
					<cfset endPosition = findNotInQuotes(line,":")>
					<cfset leftLine = mid(line, 1, endPosition-1)>
					<cfset eventData[token].data = mid(line, endPosition+1, len(line)-endPosition+1)>
					<!--- so, now we need to look for ; not in quotes. We can cheat though. 
						  I can replace semicolons not in a quote with chr(10) --->
					<cfset pos = 1>
					<cfloop condition="findNotInQuotes(leftLine,"";"",pos)">
						<cfset foundAt = findNotInQuotes(leftLine,";",pos)>
						<cfset leftLine = mid(leftLine,1,foundAt-1) & chr(10) & mid(leftLine, foundAt+1, len(leftLine)-foundAt+1)>
						<cfset pos = foundAt + 1>
					</cfloop>
					<!--- now split by chr(10) --->
					<cfloop index="subline" list="#leftLine#" delimiters="#chr(10)#">
						<!--- each line is foo=goo --->
						<cfset key = listFirst(subline,"=")>
						<cfset value = listRest(subline,"=")>
						<cfset eventData[token].params[key] = value>
					</cfloop>
	
				<cfelse>
					<cfif len(line)>
						<cfset eventData[token].data = right(line,len(line)-1)>
					</cfif>
				</cfif>
			</cfloop>
			<cfset arrayAppend(results, eventData)>
		</cfloop>
		
		<cfset variables.events = results>
		<cfreturn results>

	</cffunction>
	
	<cffunction name="iCalParseDateTime" returnType="date" access="public" output="false"
				hint="Takes a date/time string in the format YYYYMMDDTHHMMSS or YYYYMMDD and returns a date.">
		<cfargument name="str" type="string" required="true">
		<cfscript>
		var dateStr = "";
		var timeStr = "";
		var year = "";
		var month = "";
		var day = "";
		var hour = "";
		var minute = "";
		var second = "";
		
		if(find("T",str)) {
			dateStr = listFirst(str,"T");
			timeStr = listLast(str,"T");
		} else {
			dateStr = str;
			timeStr = "000000";
		}
		
		//first 4 digits are year
		year = left(dateStr,4);
		month = mid(dateStr,5,2);
		day = right(dateStr,2);
	
		hour = left(timeStr,2);
		minute = mid(timeStr,3,2);
		second = right(timeStr,2);
		
		return CreateDateTime(year,month,day,hour,minute,second);
		</cfscript>
	</cffunction>

	<cffunction name="iCalParseDuration" returnType="date" access="public" output="false"
				hint="Takes an iCal duration and adds it to a date.">
		<cfargument name="str" type="string" required="true">
		<cfargument name="date" type="date" required="true">
		
		<cfset var chrPos = "">
		<cfset var num = "">
		<cfset var chr = "">
		<cfset var parts = "">
		<cfset var x = "">
		<cfset var dir = "1">
		
		<!---
		iCal durations take the form of:
		PXXXXXXXXX
		where XXXXXXXX is the data we care about. 
		Each item in the string is a number and a type. 
		So an example is 7W, which is 7 weeks.
		Also, a "T" may be present, it means a hour/min/sec pair follows it. 
		However, we can ignore the T, and in general, just treat the strings
		as pairs of numbers and types. 	
		
		--->

		<!--- are we a negative duration? Although I don't understand how a duration can go -back- in time... --->
		<cfif left(arguments.str,1) is "-">
			<cfset dir = "-1">
		</cfif>
		
		<!--- remove potential + or - in front --->
		<cfset arguments.str = replace(arguments.str, "+", "")>
		<cfset arguments.str = replace(arguments.str, "-", "")>
		<!--- remove the P, and then a T --->
		<cfset arguments.str = replace(arguments.str, "P", "")>
		<cfset arguments.str = replace(arguments.str, "T", "")>

		<cfset parts = reGet(arguments.str,"[0-9]{1,}[A-Za-z]")>
		
		<!--- now we loop --->
		<cfloop index="x" from="1" to="#arrayLen(parts)#">
			<cfset chrPos = reFindNoCase("[A-Z]",parts[x])>
			<cfif chrPos is 0>
				<cfbreak>
			</cfif>
			<cfset num = left(parts[x], chrPos - 1)>
			<cfset chr = mid(parts[x], chrPos, 1)>
			<!--- The strings iCal uses don't match exactly with dateAdd, but close... --->
			<cfif chr is "W">
				<cfset chr = "WW">
			<cfelseif chr is "M">
				<cfset chr = "N">
			</cfif>
			<cfset arguments.date = dateAdd(chr, dir * num, arguments.date)>
		</cfloop>

		<cfreturn arguments.date>
	</cffunction>
	
	<cffunction name="reGet" returnType="array" access="private" output="false"
				hint="Returns all the matches of a regex from a string.">
		<cfargument name="str" type="string" required="true">
		<cfargument name="regex" type="string" required="true">

		<cfscript>
		var results = arrayNew(1);
		var test = REFind(regex,str,1,1);
		var pos = test.pos[1];
		var oldpos = 1;
		while(pos gt 0) {
			arrayAppend(results,mid(str,pos,test.len[1]));
			oldpos = pos+test.len[1];
			test = REFind(regex,str,oldpos,1);
			pos = test.pos[1];
		}
		return results;
		</cfscript>
	</cffunction>
		
	<cffunction name="findNotInQuotes" returnType="numeric" access="private" output="false"
				hint="Finds the instance of the character where it isn't in quotes.">
		<cfargument name="data" type="string" required="true">
		<cfargument name="target" type="string" required="true" hint="Must be just one character.">
		<cfargument name="start" type="numeric" required="false" default="1">

		<cfscript>
		var inQuotes = false;
		var c = "";
	
		for(; arguments.start lte len(arguments.data); arguments.start=arguments.start+1) {
			c = mid(data,arguments.start,1);
			if(c is """") {
				if(inQuotes) inQuotes=false;
				else inQuotes = true;
			}
			if(c is arguments.target and not inQuotes) return arguments.start;
		}
		return 0;
		</cfscript>
	</cffunction>
	
</cfcomponent>