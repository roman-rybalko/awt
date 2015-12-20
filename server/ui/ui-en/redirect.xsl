<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="redirect">
	<div class="container">
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<div class="panel panel-default panel-login">
					<div class="panel-heading">
						<h3 class="panel-title">Redirect</h3>
					</div>
					<div class="panel-body">
						<xsl:apply-templates select="//message"/>
						<xsl:choose>
							<xsl:when test="contains(@url, '://')">
								<a href="{@url}" id="redirect">Continue</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="./{@url}" id="redirect">Continue</a>
							</xsl:otherwise>
						</xsl:choose>
						<script type="text/javascript">
							$(function() {
								window.setTimeout(function() {
									window.location = $('#redirect').attr('href');
								}, <xsl:value-of select="@timeout"/>000);
							});
						</script>
					</div>
				</div>
			</div>
		</div>
	</div>
	<xsl:if test="//message[@value='register_ok']">
		<script type="text/javascript">
		/* <![CDATA[ */
		var google_conversion_id = 935534777;
		var google_conversion_language = "en";
		var google_conversion_format = "3";
		var google_conversion_color = "ffffff";
		var google_conversion_label = "nWPwCLi5k2IQucGMvgM";
		var google_remarketing_only = false;
		/* ]]> */
		</script>
		<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
		</script>
		<noscript>
		<div style="display:inline;">
		<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/935534777/?label=nWPwCLi5k2IQucGMvgM&amp;guid=ON&amp;script=0"/>
		</div>
		</noscript>
	</xsl:if>
	<xsl:if test="//message[@value='paypal_ok' or @value='webmoney_ok']">
		<script type="text/javascript">
		/* <![CDATA[ */
		var google_conversion_id = 935534777;
		var google_conversion_language = "en";
		var google_conversion_format = "3";
		var google_conversion_color = "ffffff";
		var google_conversion_label = "Y_CWCJXoomIQucGMvgM";
		var google_remarketing_only = false;
		/* ]]> */
		</script>
		<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
		</script>
		<noscript>
		<div style="display:inline;">
		<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/935534777/?label=Y_CWCJXoomIQucGMvgM&amp;guid=ON&amp;script=0"/>
		</div>
		</noscript>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
