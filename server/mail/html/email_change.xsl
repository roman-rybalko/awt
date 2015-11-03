<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="email_change">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">E-Mail Change Notification</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<h4>
				<p>Hi <b><xsl:value-of select="@login"/></b>,</p>
				<p>Thank you for subscribing to Advanced Web Testing service.</p>
				<p>This is an E-Mail change notification message.</p>
			</h4>
			<div class="alert alert-danger">
				We got a request to change the E-Mail address for your account.
				The E-Mail has been changed to <b><xsl:value-of select="@new_email"/></b>.
				You will no longer receive any further messages.
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
