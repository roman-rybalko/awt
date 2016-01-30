<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="logout">
	<xsl:choose>
		<xsl:when test="//message">
			<xsl:call-template name="redirect">
				<xsl:with-param name="timeout">5</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="redirect"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
