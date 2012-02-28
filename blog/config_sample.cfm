<cfsilent><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE preferences SYSTEM "http://java.sun.com/dtd/preferences.dtd">
<preferences EXTERNAL_XML_VERSION="1.0">
	<root type="system">
		<map/>				    
	<node name="generalSettings"><map></map>
	<node name="dataSource">
		<map>
			<entry key="name" value="your_dsn"/>
			<entry key="username" value="if_your_connection_needs_username"/>
			<entry key="password" value="if_your_connection_needs_password"/>
			<entry key="type" value="mssql_or_mysql"/>
			<entry key="tablePrefix" value="some_prefix"/>
		</map>
	</node>
	<node name="system">
		<map>
			<entry key="enableThreads" value="1"/>
		</map>
	</node>
	<node name="mailServer"><map>
		<entry key="server" value=""/>
		<entry key="username" value=""/>
		<entry key="password" value=""/>
		<entry key="defaultFromAddress" value="your_email_address"/></map></node></node>
	
<node name="default"><map/>
		<node name="blogsettings">
			<map>
				<entry key="language" value="en"/>
				<entry key="searchUrl" value="archives.cfm/search/"/>
				<entry key="postUrl" value="post.cfm/{postName}"/>
				<entry key="authorUrl" value="author.cfm/{authorId}"/>
				<entry key="archivesUrl" value="archives.cfm/"/>
				<entry key="categoryUrl" value="archives.cfm/category/{categoryName}"/>
				<entry key="pageUrl" value="page.cfm/{pageHierarchyNames}{pageName}"/>
				<entry key="rssUrl" value="feeds/rss.cfm"/>
				<entry key="atomUrl" value="feeds/atom.cfm"/>
				<entry key="apiUrl" value="api"/>
				<entry key="assetsDirectory" value=""/>
				<entry key="skinsDirectory" value="your_skin_directory"/>
				<entry key="useFriendlyUrls" value="1"/>
			</map>
			
			<node name="assets">
				<map>
					<entry key="directory" value="your_assets_dirs"/>
					<entry key="path" value="assets/content"/>
				</map>
			</node>
			
			<node name="admin">
				<map/>
				<node name="customPanels">
				<map>
					<entry key="directory" value="your_admin_directory/custompanels/"/>
					<entry key="path" value="custompanels/"/>
				</map>
				</node>
			</node>
		</node>
		<node name="searchSettings">
			<map>
				<entry key="component" value="search.Verity"/>
			</map>
			<node name="settings">
				<map>
					<entry key="collectionsPath" value="your_verity_collections_dir"/>
				</map>
			</node>
		</node>
		<!-- alternative search settings for simple database search -->
		<!--
		<node name="searchSettings">
			<map>
				<entry key="component" value="search.DatabaseSimple"/>
			</map>
			<node name="settings">
				<map></map>
					<node name="dataSource">
					<map>
						<entry key="name" value="your_dsn"/>
						<entry key="username" value="if_your_connection_needs_username"/>
						<entry key="password" value="if_your_connection_needs_password"/>
						<entry key="type" value="mssql_or_mysql"/>
						<entry key="tablePrefix" value="some_prefix"/>
					</map>
					</node>
			</node>
		</node>
		-->
		<node name="authorization">
			<map>
				<entry key="methods" value="external"/>
				<!-- <entry key="mode" value="external"/>
				<entry key="mode" value="delegated"/> -->
			</map>
			<node name="settings">
				<map>
					<entry key="component" value="Authorizer"/>
					<!-- here you can add other settings you need,
					for example, the name of another datasource for your users or
					your LDAP server info: 
					<entry key="ldap_server" value="my_server"/>
					<entry key="users_dsn" value="userdatabase"/>
					-->
				</map>
			</node>
		</node>
		<node name="plugins">
		<map>
			<entry key="directory" value="your_plugins_directory"/>
			<entry key="path" value="components.plugins."/>
			<entry key="preferencesFile" value="your_plugins_preferences_file_full_path"/>
		</map>
		</node>
	</node>

	</root>
			
</preferences></cfsilent>
