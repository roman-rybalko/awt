<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="task" mode="headers">
<xsl:text/>Subject: =?UTF-8?B?W9Cc0L7QvdC40YLQvtGA0LjQvdCzXSA=?= =?UTF-8?B?0JfQsNC00LDRh9Cw?= "<xsl:value-of select="@test_name"/><xsl:text>"</xsl:text>
<xsl:if test="@status = 'failed'">
<xsl:text> =?UTF-8?B?0L7QsdC90LDRgNGD0LbQuNC70LAg0J7QqNCY0JHQmtCj?=</xsl:text>
</xsl:if>
<xsl:if test="@status = 'succeeded'">
<xsl:text> =?UTF-8?B?0LfQsNCy0LXRgNGI0LjQu9Cw0YHRjCDRg9GB0L/QtdGI0L3Qvg==?=</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="task" mode="text">
<xsl:text/>Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Task: <xsl:value-of select="../@root_url"/>?task=<xsl:value-of select="@id"/>
Test: "<xsl:value-of select="@test_name"/>" (<xsl:value-of select="../@root_url"/>?test=<xsl:value-of select="@test_id"/>)
Type: <xsl:value-of select="@type"/>
Status: <xsl:value-of select="@status"/>
Debug: <xsl:choose>
	<xsl:when test="@debug">on
</xsl:when>
	<xsl:otherwise>off
</xsl:otherwise>
</xsl:choose>

<xsl:text>
</xsl:text>

<xsl:for-each select="action">
	<xsl:sort select="@id" data-type="number" order="ascending"/>
	<xsl:choose>
		<xsl:when test="@succeeded">
			<xsl:text>[succeeded] </xsl:text>
		</xsl:when>
		<xsl:when test="@failed">
			<xsl:text>[FAILED] </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>[skipped] </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="." mode="text"/>
	<xsl:if test="@scrn">
		<xsl:text> (</xsl:text>
		<xsl:value-of select="php:function('composer_basename', string(@scrn))"/>
		<xsl:text>)</xsl:text>
	</xsl:if>
	<xsl:text>
</xsl:text>
</xsl:for-each>
--
Advanced Web Testing
</xsl:template>

<xsl:template match="task" mode="html">
<xsl:text/>Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<xsl:value-of select="php:function('composer_transform', 'html/index.xsl', ..)"/>
</xsl:template>

<xsl:template match="task" mode="attachments">
	<xsl:param name="boundary"/>
--<xsl:value-of select="$boundary"/>
Content-Type: text/css
Content-Transfer-Encoding: base64
Content-Id: <![CDATA[<bootstrap.min.css>]]>

<xsl:value-of select="php:function('composer_file2b64', 'ui', 'ui-en/css/bootstrap.min.css')"/>
--<xsl:value-of select="$boundary"/>
Content-Type: text/css
Content-Transfer-Encoding: base64
Content-Id: <![CDATA[<awt.css>]]>

<xsl:value-of select="php:function('composer_file2b64', 'ui', 'ui-en/css/awt.css')"/>

<xsl:for-each select="action">
	<xsl:if test="@scrn">
--<xsl:value-of select="$boundary"/>
Content-Type: <xsl:value-of select="php:function('composer_fileName2mimeType', string(@scrn))"/>
Content-Transfer-Encoding: base64
Content-Id: <![CDATA[<]]><xsl:value-of select="@scrn"/><![CDATA[>]]>
Content-Disposition: attachment; filename="<xsl:value-of select="php:function('composer_basename', string(@scrn))"/>"

<xsl:value-of select="php:function('composer_file2b64', 'results', string(@scrn))"/>
	</xsl:if>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>