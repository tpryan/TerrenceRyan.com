<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">

<cfset title = request.archive.getTitle() />

    
<cf_wrapper id="bloghome" class="blog" title="#title# - TerrenceRyan.com">
<mango:Event name="beforeHtmlBodyStart" />

	
	<section id="content">
		
		
		<mango:Archive pageSize="10">
		<mango:ArchiveProperty ifIsType="category"><h2 class="archive_head">Entries Tagged as <em><mango:ArchiveProperty title /></em></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="month"><h2 class="archive_head">Entries for month: <em><mango:ArchiveProperty title dateformat="mmmm yyyy"  /></em></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="day"><h2 class="archive_head">Entries for day: <em><mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></em></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="year"><h2 class="archive_head">Entries for year: <em><mango:ArchiveProperty title dateformat="yyyy" /></em></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="search"><h2 class="archive_head">Search Results for <em><mango:ArchiveProperty title format="escapedHtml" /></em></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="author"><h2 class="archive_head">Entries by '<mango:ArchiveProperty title />'</h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="unknown"><h2 class="archive_head">No archives</h2></mango:ArchiveProperty>
						
		<mango:Posts count="10">
			<cf_listedPost />
		</mango:Posts>
		
		<div class="navigation">
			<div class="previous"><mango:ArchiveProperty ifHasNextPage><a href="<mango:ArchiveProperty link pageDifference="1" />">&larr; Previous Entries</a></mango:ArchiveProperty></div>
			<div class="next"><mango:ArchiveProperty ifHasPreviousPage><a href="<mango:ArchiveProperty link pageDifference="-1" />">Next Entries &rarr;</a></mango:ArchiveProperty></div>
		</div>
		</mango:Archive>

		<section id="archives">
			<mangox:PodGroup locationId="sidebar" template="index">
				<template:sidebar />
			</mangox:PodGroup>	
		</section>
	</section>		
<mango:Event name="beforeFooterEnd" />
<mango:Event name="beforeHtmlBodyEnd" />
</cf_wrapper>