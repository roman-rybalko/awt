<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="message[@type='notice']">
	<div style="color: green;">
		<xsl:value-of select="@value"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='error']">
	<div style="color: red;">
		<xsl:value-of select="@value"/>
	</div>
</xsl:template>

</xsl:stylesheet>