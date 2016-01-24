<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="message[@type='notice']">
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@value='set_up_email']">
	<div class="alert alert-info alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='error']">
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:call-template name="message"/>
		Error Code: <b><xsl:value-of select="@code"/></b>.
		<a href="mailto:support@advancedwebtesting.com?subject=Error%20Code:%20{@code}&amp;body=Login:%20{//user/@login}%0aError%20Value:%20{@value}%0aError%20Code:%20{@code}%0a">Support.</a>
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
