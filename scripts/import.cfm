<cfsetting showdebugoutput="FALSE" />
<cfset targetDS = "trmangoblog" />
<cfset SourceDS = "trblogcfc" />

<cfflush interval="1" />

<p>Getting Author Information</p>
<cfquery name="author" datasource="#targetDS#">
	SELECT 	*
	FROM 	author
	WHERE	username = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="tpryan" />
</cfquery>

<p>Getting Blog Information</p>
<cfquery name="blog" datasource="#targetDS#">
	SELECT 	*
	FROM 	blog
</cfquery>


<p>Resetting Mango query caching</p>
<cfset datasource.name = targetDS />
<cfset datasource.username = "" />
<cfset datasource.password = "" />
<cfset datasource.tableprefix = "" />

<cfset CategoryManager = New terrenceryan.blog.components.model.dataaccess.CategoryGateway(datasource, 0) />
<cfset CategoryManager.getAll()/>


<cfset setting = StructNew() />
<cfset setting.blog = "default" />
<cfset setting.author = author.id />
<cfset categoryStruct = structNew() />
<cfset entryStruct = structNew() />	

<p>Clearing Data from MangoBlog</p>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM entry
</cfquery>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM post
</cfquery>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM category
</cfquery>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM post_category
</cfquery>

<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM comment
</cfquery>


<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM appearances
</cfquery>

<cfquery name="categories" datasource="#SourceDS#">
	SELECT 	blog,	categoryalias,	categoryid,	categoryname
	FROM 	tblblogcategories
</cfquery>

<!--- 	Loop through categories and create them in mango blog. 
		Put category information in a struct to join category_basename to mango guid.  --->
<p>Adding Categories</p>
<ul>		
<cfloop query="categories">
	<cfset categoryStruct[categoryalias] = CreateUUID() />

	<li>Inserting <cfoutput>#categoryname#</cfoutput></li>
	<cfquery name="insertcategory" datasource="#targetDS#">
		INSERT INTO category(id,name,title,blog_id,created_on)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#categoryStruct[categoryalias]#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#categoryalias#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#categoryname#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.blog#" />, 
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#CreateDate(2006,1,1)#" />
				)
	</cfquery>


</cfloop>
</ul>



<cfquery name="entries" datasource="#SourceDS#">
		SELECT 		title, alias, body, 
					morebody, posted , 
					posted, summary 
		FROM 		tblblogentries
		ORDER BY 	posted
</cfquery>



<!--- 	Loop through entries and create them in mango blog. 
		Put post information in a struct to join entry_basename to mango guid.  --->
<p>Adding Entries</p>
<ul>		
<cfloop query="entries">
	<cfset entryStruct[alias] = CreateUUID() />

	<li>Inserting <cfoutput>#title#</cfoutput></li>
	<cfquery name="insertentry" datasource="#targetDS#">
		INSERT INTO entry(id,name,title,blog_id,last_modified,comments_allowed,content,author_id,excerpt,status)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#entryStruct[alias]#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lCase(alias)#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#title#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.blog#" />, 
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#posted#" />,
				<cfqueryparam CFSQLType="CF_SQL_TINYINT" value="1" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#body# #morebody#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.author#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#summary#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="published" />)
	</cfquery>
	
	<cfquery name="insertpost" datasource="#targetDS#">
		INSERT INTO post(id,posted_on)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#entryStruct[alias]#" />, 
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#posted#" />)
	</cfquery>
	

</cfloop>		
</ul>		
		
		

<cfquery name="links" datasource="#SourceDS#">
	SELECT DISTINCT 	e.alias, c.categoryalias
	FROM 				tblblogentries e
	INNER JOIN 			tblblogentriescategories ec ON ec.entryidfk = e.id 
	INNER JOIN 			tblblogcategories c ON c.categoryid = ec.categoryidfk

</cfquery>	

<!--- 	Loop through link info and create them in mango blog. 
		use guid struct to make the link.   --->
		
<p>Adding Links</p>
<ul>		
<cfloop query="links">

	<li>Linking <cfoutput>#alias#</cfoutput> <-> <cfoutput>#categoryalias#</cfoutput></li>
	<cfquery name="insertpost" datasource="#targetDS#">
		INSERT INTO post_category(post_id,category_id)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#entryStruct[alias]#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#categoryStruct[categoryalias]#" />)
	</cfquery>

</cfloop>	
</ul>
<cfquery name="comments" datasource="#SourceDS#">
	SELECT 		e.alias, c.name, c.email, c.website, c.comment,c.posted
	FROM  		tblblogentries e
	INNER JOIN	tblblogcomments c ON e.id = c.entryidfk
</cfquery>


<!--- 	Loop through link info and create them in mango blog. 
		use guid struct to make the link.   --->
		
<p>Adding Links</p>
<ul>		
<cfloop query="comments">

	<li>Adding comment to entry <cfoutput>#alias#</cfoutput></li>
	<cfquery name="insertpost" datasource="#targetDS#">
		INSERT INTO comment(id, entry_id, creator_name, creator_email, creator_url, content,  created_on, approved, author_id,rating)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#CreateUUID()#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#entryStruct[alias]#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#name#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#website#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#comment#" />,
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#posted#" />,
				<cfqueryparam CFSQLType="CF_SQL_TINYINT" value="1" />,
				<cfif name eq "Terrence Ryan">
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.author#" />,
				<cfelse>	
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" null="TRUE" />,
				</cfif>
				<cfqueryparam CFSQLType="CF_SQL_TINYINT" value="0" />
				)
	</cfquery>

</cfloop>
</ul>	

<cfquery name="appearances" datasource="#SourceDS#">
	SELECT 		id,eventTitle,eventURL,eventLogo,eventLogoHeight,eventLogoWidth,
				sessionTitle,sessionStartTime,sessionEndTime,
				sessionDescription,sessionLocation,sessionOffset
	FROM  		appearances
</cfquery>

<p>Adding Appearances</p>
<ul>		
<cfloop query="appearances">

	<li>Adding <cfoutput>#eventTitle#:#sessionTitle#</cfoutput></li>
	<cfquery name="insertappearance" datasource="#targetDS#">
		INSERT INTO appearances(id,eventTitle,eventURL,eventLogo,eventLogoHeight,eventLogoWidth,
				sessionTitle,sessionStartTime,sessionEndTime,
				sessionDescription,sessionLocation,sessionOffset)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#eventTitle#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#eventURL#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#eventLogo#" />, 
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#eventLogoHeight#" />,
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#eventLogoWidth#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#sessionTitle#" />, 
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#sessionStartTime#" />,
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#sessionStartTime#" />,
				<cfqueryparam CFSQLType="cf_sql_longvarchar" value="#sessionDescription#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#sessionLocation#" />, 
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#sessionOffset#" />
				)
	</cfquery>

</cfloop>
</ul>	
		