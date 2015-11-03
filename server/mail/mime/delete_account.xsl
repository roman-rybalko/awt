<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="delete_account" mode="headers">
<xsl:text>Subject: Delete Account Confirmation
</xsl:text>
</xsl:template>

<xsl:template match="delete_account" mode="text">
<xsl:text/>Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi <xsl:value-of select="@login"/>,
Thank you for subscribing to Advanced Web Testing service.
We got a request to delete your account.

If you delete your account,
all your Pending Tasks will be canceled,
all your Schedule Jobs will be canceled,
all your Payment Subscriptions will be canceled,
your Available Actions (Balance) will be refunded.

Please, confirm your account deletion by visiting the link below.
<xsl:value-of select="@url"/>
If you cannot click the URL above, please copy and paste it into your web browser.

If you do not want to delete your account or this message was reached you by mistake, please ignore it.

--
Advanced Web Testing
</xsl:template>

<xsl:template match="delete_account" mode="html">
<xsl:text/>Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<xsl:value-of select="php:function('composer_transform', 'html/index.xsl', ..)"/>
</xsl:template>

<xsl:template match="delete_account" mode="attachments">
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
