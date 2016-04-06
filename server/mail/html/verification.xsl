<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="verification">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Email Verification</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<h4>
				<p>Hi <b><xsl:value-of select="@login"/></b>,</p>
				<p>Thank you for subscribing to Advanced Web Testing service.</p>
				<p>This is an email verification message.</p>
			</h4>
			<p>
				<a href="{@url}" class="btn btn-success">Please, confirm your email.</a>
			</p>
			<div class="alert alert-info">
				If you cannot click the link/button above, please copy the URL
				<p>
					<xsl:value-of select="@url"/>
				</p>
				and paste it into your web browser.
			</div>
			<div class="alert alert-warning">
				If you do not want to confirm or this message was reached you by mistake, please ignore it.
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
