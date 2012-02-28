<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cf_wrapper id="bloghome" class="blog" title="Blog - TerrenceRyan.com">
<mango:Event name="beforeHtmlBodyStart" />


	
	<section id="content">
		<h2>Blog</h2>
		<mango:Posts count="10">
			<cf_listedPost />
		</mango:Posts>
			
		<mango:Archive pageSize="10">
		<div class="navigation">
			<div class="previous"><mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&larr; Previous Entries</a></mango:ArchiveProperty></div>
			<div class="next"></div>
		</div>
		</mango:Archive>
	</section>	
	<section id="sidebar">
		<ul class="sidebar_list">
			<mangox:PodGroup locationId="sidebar" template="index">
				<template:sidebar />
			</mangox:PodGroup>	
		</ul>
	</section>	
<mango:Event name="beforeFooterEnd" />
<mango:Event name="beforeHtmlBodyEnd" />
</cf_wrapper>