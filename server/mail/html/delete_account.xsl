<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="delete_account">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Delete Account Confirmation</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<h4>
				<p>Hi <b><xsl:value-of select="@login"/></b>,</p>
				<p>Thank you for subscribing to Advanced Web Testing service.</p>
				<p>We got a request to <b>delete your account</b>.</p>
			</h4>
			<div class="alert alert-danger">
				If you delete your account,
				<ul>
					<li>
						all your <a href="{../@root_url}?tests=1">Tests</a> will be deleted,
					</li>
					<li>
						all your <a href="{../@root_url}?tasks=1">Pending Tasks</a> will be canceled,
					</li>
					<li>
						all your <a href="{../@root_url}?schedule=1">Schedule Jobs</a> will be canceled,
					</li>
					<li>
						all your <a href="{../@root_url}?billing=1">Payment Subscriptions</a> will be canceled,
					</li>
					<li>
						your <a href="{../@root_url}?billing=1">Available Actions (Account Balance)</a> will be refunded.
					</li>
				</ul>
			</div>
			<p>
				<a href="{@url}" class="btn btn-danger">Please, confirm your account deletion.</a>
			</p>
			<div class="alert alert-info">
				If you cannot click the link/button above, please copy the URL
				<p>
					<xsl:value-of select="@url"/>
				</p>
				and paste it into your web browser.
			</div>
			<div class="alert alert-warning">
				If you do not want to delete your account or this message was reached you by mistake, please ignore it.
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
