<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="message[@type='info']">
	<div class="alert alert-info alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='notice']">
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='error']">
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
	</div>
</xsl:template>

<xsl:template name="message">
	<xsl:param name="value" select="@value"/>
	<xsl:choose>
		<xsl:when test="document('messages.xml')//message[@value=$value]">
			<xsl:value-of select="document('messages.xml')//message[@value=$value]"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$value"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
