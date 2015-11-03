<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="email_change" mode="headers">
<xsl:text>Subject: E-Mail Change Notification
</xsl:text>
</xsl:template>

<xsl:template match="email_change" mode="text">
<xsl:text/>Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi <xsl:value-of select="@login"/>,
Thank you for subscribing to Advanced Web Testing service.
This is an E-Mail change notification message.

We got a request to change the E-Mail address for your account.
The E-Mail has been changed to <xsl:value-of select="@new_email"/>.
You will no longer receive any further messages.

--
Advanced Web Testing
</xsl:template>

<xsl:template match="email_change" mode="html">
<xsl:text/>Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<xsl:value-of select="php:function('composer_transform', 'html/index.xsl', ..)"/>
</xsl:template>

<xsl:template match="email_change" mode="attachments">
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
