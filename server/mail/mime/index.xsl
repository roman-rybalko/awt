<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" media-type="message/rfc822"/>
	<xsl:include href="mail.xsl"/>
	<xsl:include href="verification.xsl"/>
	<xsl:include href="../../ui/ui-en/actions.xsl"/>
	<xsl:include href="task.xsl"/>
	<xsl:include href="sched_fail.xsl"/>
	<xsl:include href="reset_password.xsl"/>
	<xsl:include href="delete_account.xsl"/>
</xsl:stylesheet>