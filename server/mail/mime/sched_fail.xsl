<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="sched_fail" mode="headers">
<xsl:text/>Subject: [Report] Schedule Job "<xsl:value-of select="@sched_name"/>" start FAILED
</xsl:template>

<xsl:template match="sched_fail" mode="text">
<xsl:text/>Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Schedule Job: "<xsl:value-of select="@sched_name"/>" (<xsl:value-of select="../@root_url"/>?schedule=1#<xsl:value-of select="@sched_id"/>)
Test: "<xsl:value-of select="@test_name"/>" (<xsl:value-of select="../@root_url"/>?test=<xsl:value-of select="@test_id"/>)
Failure: <xsl:text/>
<xsl:call-template name="message">
	<xsl:with-param name="value" select="@message"/>
</xsl:call-template>

--
Advanced Web Testing / Web Automation
</xsl:template>

<xsl:template match="sched_fail" mode="html">
<xsl:text/>Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<xsl:value-of select="php:function('composer_transform', 'html/index.xsl', ..)"/>
</xsl:template>

<xsl:template match="sched_fail" mode="attachments">
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
</xsl:template>

</xsl:stylesheet>
