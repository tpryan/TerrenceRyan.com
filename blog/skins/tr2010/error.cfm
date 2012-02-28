<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cf_wrapper id="bloghome" class="blog">
	<section id="content">
	
			<h2><mango:Message title /></h2>
			<div class="entry">
			<mango:Message text />
			<mango:Message data />
			</div>

	</section>
</cf_wrapper>