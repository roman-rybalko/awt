<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="redirect">
	<a href="../{@url}" id="redirect">Continue</a>
	<script type="text/javascript">
		$(function(){
		<xsl:choose>
			<xsl:when test="@timeout">
				window.setTimeout(function(){
					window.location = $('#redirect').attr('href');
				}, <xsl:value-of select="@timeout" />000);
			</xsl:when>
			<xsl:otherwise>
				window.location = $('#redirect').attr('href');
			</xsl:otherwise>
		</xsl:choose>
		});
	</script>
</xsl:template>
</xsl:stylesheet>