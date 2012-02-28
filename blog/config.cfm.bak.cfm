<cfsilent><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE preferences SYSTEM "http://java.sun.com/dtd/preferences.dtd">
<preferences EXTERNAL_XML_VERSION="1.0">
		<root type="system">
			<map/>
			<node name="generalSettings">
				<map/>
				<node name="system">
					<map>
						<entry key="enableThreads" value="1"/>
					</map>
				</node>
				<node name="dataSource">
					<map>
						<entry key="name" value="trcom"/>
						<entry key="type" value="mysql"/>
						<entry key="username" value="trblog_user"/>
						<entry key="password" value="trblog_user"/>
						<entry key="tablePrefix" value=""/>
					</map>
				</node>
				<node name="mailServer">
					<map>
						<entry key="server" value=""/>
						<entry key="username" value=""/>
						<entry key="password" value=""/>
						<entry key="defaultFromAddress" value="terry@terrenceryan.com"/>
					</map>
				</node>
			</node>
			<node name="default">
				<map/>
				<node name="blogsettings">
					<map>
						<entry key="language" value="en"/>
						<entry key="searchUrl" value="archives.cfm/search/"/>
						<entry key="postUrl" value="post.cfm/{postName}"/>
						<entry key="authorUrl" value="author.cfm/{authorAlias}"/>
						<entry key="archivesUrl" value="archives.cfm/"/>
						<entry key="categoryUrl" value="archives.cfm/category/{categoryName}"/>
						<entry key="pageUrl" value="page.cfm/{pageHierarchyNames}{pageName}"/>
						<entry key="rssUrl" value="feeds/rss.cfm"/>
						<entry key="atomUrl" value="feeds/atom.cfm"/>
						<entry key="apiUrl" value="api"/>
						<entry key="skinsDirectory" value="{baseDirectory}skins/"/>
						<entry key="useFriendlyUrls" value="1"/>
					</map>
					<node name="admin">
						<map/>
						<node name="customPanels">
							<map>
								<entry key="directory" value="{baseDirectory}admin/custompanels/"/>
								<entry key="path" value="custompanels/"/>
							</map>
						</node>
					</node>
					<node name="assets">
						<map>
							<entry key="directory" value="{baseDirectory}assets/content/"/>
							<entry key="path" value="assets/content/"/>
						</map>
					</node>
				</node>
				<node name="plugins">
					<map>
						<entry key="directory" value="{componentsDirectory}plugins/"/>
						<entry key="path" value="plugins."/>
					</map>
				</node>
				<node name="searchSettings">
					<map>
						<entry key="component" value="search.DatabaseSimple"/>
					</map>
					<node name="settings">
						<map/>
						<node name="dataSource">
							<map>
								<entry key="name" value="trmangoblog"/>
								<entry key="type" value="mysql"/>
								<entry key="username" value="trblog_user"/>
								<entry key="password" value="trblog_user"/>
								<entry key="tablePrefix" value=""/>
							</map>
						</node>
					</node>
				</node>
				<node name="authorization">
					<map>
						<entry key="methods" value="native"/>
					</map>
					<node name="settings">
						<map>
							<entry key="component" value=""/>
						</map>
					</node>
				</node>
			<node name="logging"><map><entry key="level" value="warning"/></map></node></node>
		</root>
	</preferences></cfsilent>
