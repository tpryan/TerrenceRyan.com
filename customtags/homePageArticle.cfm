<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.count" type="numeric" default="5">	
	
<cfelse>
	<cfsilent>
	
	<cfscript>
	
		posts = cacheGet("terrenceryan_homepage_posts");
		
		if (isNull(posts) or not IsNull(url.reset_cache) OR posts.recordcount != attributes.count){
			posts =  application.blogService.listPosts("desc", attributes.count);
			cachePut("terrenceryan_homepage_posts", posts, CreateTimeSpan(1,0,0,0));
			
		}	
		
	</cfscript>
	</cfsilent>
	<cfoutput query="posts">
			<article class="item">
				<h3><a href="blog/post.cfm/#name#">#title#</a></h3>
				<time>#DateFormat(posted_on, "mmmm d, yyyy")#</time>
				#excerpt#
			</article>		
	</cfoutput>	
</cfif>
</cfprocessingdirective>


<cfscript>
/**
 * Display N leading characters of a text block which may include HTML.
 * 
 * @param input      String to parse. (Required)
 * @param maxChars      Maximum number of characters. (Required)
 * @return Returns a string. 
 * @author Max Paperno (max@wdg.us) 
 * @version 1, June 18, 2010 
 */
function getLeadingHtml(input, maxChars) {
    // token matches a word, tag, or special character
    var    token = "[[:word:]]+|[^[:word:]<]|(?:<(\/)?([[:word:]]+)[^>]*(\/)?>)|<";
    var    selfClosingTag = "^(?:[hb]r|img)$";
    var    output = "";
    var    charCount = 0;
    var    openTags = ""; var strPos = 0; var tag = "";
    var i = 1;

    var    match = REFind(token, input, i, "true");

    while ( (charCount LT maxChars) AND match.pos[1] ) {
        // If this is an HTML tag
        if (match.pos[3]) {
            output = output & Mid(input, match.pos[1], match.len[1]);
            tag = Mid(input, match.pos[3], match.len[3]);
            // If this is not a self-closing tag
            if ( NOT ( match.pos[4] OR REFindNoCase(selfClosingTag, tag) ) ) {
                // If this is a closing tag
                if ( match.pos[2] AND ListFindNoCase(openTags, tag) ) {
                    openTags = ListDeleteAt(openTags, ListFindNoCase(openTags, tag)); 
                } else {
                    openTags = ListAppend(openTags, tag);
                }
            }
        } else {
            charCount = charCount +  match.len[1];
            if (charCount LTE maxChars) output = output & Mid(input, match.pos[1], match.len[1]);
        }
        
        i = i + match.len[1];
        match = REFind(token, input, i, "true");
    }

    // Close any tags which were left open
    while ( ListLen(openTags) ) {
        output = output & "</" & ListLast(openTags) & ">";
        openTags = ListDeleteAt(openTags, ListLen(openTags));
    }

    if ( Len(input) GT Len(output) )
        output = output & "...";
    
    return output;
}
</cfscript>

<!--- ************************  STRIP HTML  ************************ --->
    <cffunction name="stripHtml" displayname="Strip HTML" description="Strips out specified HTML tags." access="public" output="false" returntype="struct">
 
        <!--- ARGUMENTS --->
        <cfargument name="text" displayName="Text" type="string" hint="Text to strip out html tags from." required="true" />
        <cfargument name="tags" displayName="Tags" type="string" hint="Tags to be striped from the text.  Ex. '[string:tag name],[what to remove - {string:tag | string:content}],[is it a wrapping tag? {boolean}]'. Tags are delimited with semi-colons." required="true" />
 
        <!--- SET SOME LOCAL VARS --->
        <cfset var textbytes = "">
        <cfset var counter = 1>
        <cfset var delete = false>
        <cfset var temp = "">
        <cfset var tagtoberemoved = "">
        <cfset var whatgetsremoved = "">
        <cfset var wrappingtag = "">
 
        <!--- BUILD STRUCT --->
        <cfset var data = structNew()>
        <cfset data.success = true>
        <cfset data.message = "">
        <cfset data.orginaltext = ARGUMENTS.text>
        <cfset data.strippedtext = ARGUMENTS.text>
 
        <!--- CHECK IF ALL CONTENT SHOULD BE REMOVED --->
        <cfif ARGUMENTS.tags eq "all">
            <!--- REMOVE HTML TAGS --->
            <cfset data.strippedtext = rereplaceNoCase(ARGUMENTS.text, "<[^>]*>", "", "all")>
        <cfelse>
            <!--- LOOP OVER THE LIST OF TAGS TO BE REMOVED --->
            <cfloop list="#ARGUMENTS.tags#" index="VARIABLES.i" delimiters=";">
                <!--- SET ATTRIBUTES OF TAG TO BE DELETED --->
                <cfset tagtoberemoved = listFirst(VARIABLES.i, ",")>
                <cfset whatgetsremoved = listGetAt(VARIABLES.i, 2, ",")>
                <cfset wrappingtag = listLast(VARIABLES.i, ",")>
 
                <!--- IF REMOVING JUST THE TAG --->
                <cfif whatgetsremoved eq "tag">
                    <!--- CHECK IF IT IS A WRAPPING TAG --->
                    <cfif wrappingtag eq true>
                        <!--- REMOVE WRAPPING TAG, BUT NOT THE CONTENT --->
                        <cfset data.strippedtext = rereplaceNoCase(data.strippedtext, "<#tagtoberemoved#>", "", "all")>
                        <cfset data.strippedtext = rereplaceNoCase(data.strippedtext, "</#tagtoberemoved#>", "", "all")>
                    <cfelse>
                        <!--- REMOVE CONTAINED TAG --->
                        <cfset data.strippedtext = rereplaceNoCase(data.strippedtext, "<#tagtoberemoved# />", "", "all")>
                    </cfif>
 
                <!--- IF REMOVING TAG AND CONTENT --->
                <cfelseif whatgetsremoved eq "content">
                    <!--- CHECK IF IT IS A WRAPPING TAG --->
                    <cfif wrappingtag eq true>
                        <!--- REMOVE THE TAG AND CONTENT --->
                        <cfset data.strippedtext = rereplaceNoCase(data.strippedtext, "<#tagtoberemoved#>.*</#tagtoberemoved#>", "", "all")>
                    <cfelse>
                        <!--- REMOVE CONTAINED TAG --->
                        <cfset data.strippedtext = rereplaceNoCase(data.strippedtext, "<#tagtoberemoved# />", "", "all")>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
 
        <!--- RETURN STRUCT --->
        <cfreturn data>
 
    </cffunction>