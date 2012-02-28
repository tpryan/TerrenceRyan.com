<cfsetting showdebugoutput="true" />
<cfset sourceDS = "trmangoprod" />
<cfset targetDS = "trblogcfc" />

<cfset blog = CreateObject('component', 'terrenceryan.blog.org.camden.blog.blog').init() />

<cfflush interval="1" />


<p>Clearing Data from BlogCFC</p>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM tblblogentries
</cfquery>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM tblblogcategories
</cfquery>
<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM tblblogentriescategories
</cfquery>

<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM tblblogcomments
</cfquery>

<cfquery name="clean" datasource="#targetDS#">
	DELETE FROM tblusers
	WHERE	username = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="tpryan" />
</cfquery>

<cfset setting = StructNew() />
<cfset setting.blog = "Default" />
<cfset setting.author = "tpryan" />
<cfset entryStruct = structNew() />	

<p>Getting Author Information</p>

<cfquery name="author" datasource="#targetDS#">
	UPDATE  tblusers
	SET 	password = 'Adobe1'
	WHERE	username = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="admin" />
</cfquery>

<cfquery name="author" datasource="#targetDS#">
	INSERT INTO tblusers(username,password,name)
	VALUES('tpryan','Wharton1','Terrence Ryan')
</cfquery>


<p>Getting categories</p>
<cfquery name="categories" datasource="#SourceDS#">
	SELECT 	id, name, title
	FROM 	category
</cfquery>




<p>Adding Categories</p>
<ul>		
<cfloop query="categories">

	<li>Inserting <cfoutput>#title#</cfoutput></li>
	<cfquery name="insertcategory" datasource="#targetDS#">
		INSERT INTO tblblogcategories(categoryid,categoryname,categoryalias,blog)
		VALUES( 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#title#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#name#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.blog#" />
				)
	</cfquery>


</cfloop>
</ul>


<p>Getting entries</p>
<cfquery name="entries" datasource="#SourceDS#">
		SELECT 		e.id, e.name, e.content, e.excerpt, e.name, e.title, p.posted_on, e.last_modified
		FROM 		entry e
		INNER JOIN 	post p on e.id = p.id
</cfquery>


<p>Adding Entries</p>
<ul>		
<cfloop query="entries">

	<li>Inserting <cfoutput>#title#</cfoutput></li>
	<cfquery name="insertentry" datasource="#targetDS#">
		INSERT INTO tblblogentries(id,alias,title,blog,posted,allowcomments,body,username,released)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#name#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#title#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.blog#" />, 
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#posted_on#" />,
				<cfqueryparam CFSQLType="CF_SQL_TINYINT" value="1" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#content#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#setting.author#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="1" />) 
	</cfquery>
	

</cfloop>		
</ul>		


<p>Getting category entry links</p>
<cfquery name="links" datasource="#SourceDS#">
	SELECT 			category_id, post_id
	FROM 				post_category
</cfquery>	



<p>Adding Links</p>
<ul>		
<cfloop query="links">

	<cfquery name="insertpost" datasource="#targetDS#">
		INSERT INTO tblblogentriescategories(categoryidfk, entryidfk)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#category_id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#post_id#" />)
	</cfquery>

</cfloop>	


<p>Getting comments</p>
<cfquery name="comments" datasource="#SourceDS#">
	SELECT id, entry_id, content, creator_email, creator_name, creator_url, created_on
	from comment

</cfquery>



<p>Adding Links</p>
<ul>		
<cfloop query="comments">

	<li>Adding comment to entry</li>
	<cfquery name="insertpost" datasource="#targetDS#">
		INSERT INTO tblblogcomments(id, entryidfk, name, email, website, comment,  posted)
		VALUES(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#entry_id#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#creator_name#" />,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#creator_email#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#creator_url#" />, 
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#content#" />,
				<cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="#created_on#" />
				)
	</cfquery>

</cfloop>	