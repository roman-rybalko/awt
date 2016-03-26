<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="mail">
<xsl:text/>MIME-Version: 1.0
From: Advanced Web Testing &lt;<xsl:value-of select="@from"/>&gt;
To: <xsl:value-of select="php:function('composer_mime_encode', string(@to))"/>
Message-Id: &lt;<xsl:value-of select="@message_id"/>&gt;
Date: <xsl:value-of select="@date"/>
List-Unsubscribe: &lt;mailto:support@advancedwebtesting.com?subject=Mail%20Unsubscribe%20Request:%20&amp;body=Login:%20<xsl:value-of select="*/@login"/>%0aEmail:%20<xsl:value-of select="php:function('composer_url_encode', string(@to))"/>%0a&gt;
<xsl:apply-templates select="*" mode="headers"/>
<xsl:call-template name="related"/>
</xsl:template>

<xsl:template name="related">
	<xsl:param name="boundary"><xsl:value-of select="php:function('composer_random')"/></xsl:param>
<xsl:text/>Content-Type: multipart/related; boundary="<xsl:value-of select="$boundary"/>"

This is a multi-part message in MIME format.

--<xsl:value-of select="$boundary"/><xsl:text>
</xsl:text>
<xsl:call-template name="alternative"/>
<xsl:apply-templates select="*" mode="attachments">
	<xsl:with-param name="boundary" select="$boundary"/>
</xsl:apply-templates>
--<xsl:value-of select="$boundary"/>--
</xsl:template>

<xsl:template name="alternative">
	<xsl:param name="boundary"><xsl:value-of select="php:function('composer_random')"/></xsl:param>
<xsl:text/>Content-Type: multipart/alternative; boundary="<xsl:value-of select="$boundary"/>"


--<xsl:value-of select="$boundary"/><xsl:text>
</xsl:text>
<xsl:apply-templates select="*" mode="text"/>
--<xsl:value-of select="$boundary"/><xsl:text>
</xsl:text>
<xsl:apply-templates select="*" mode="html"/>
--<xsl:value-of select="$boundary"/>--
</xsl:template>

</xsl:stylesheet>
