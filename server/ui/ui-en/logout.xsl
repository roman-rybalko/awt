<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="logout">
	<xsl:call-template name="redirect">
		<xsl:with-param name="url">./</xsl:with-param>
	</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
