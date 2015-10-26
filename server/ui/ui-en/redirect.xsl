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
								<a href="../{@url}" id="redirect">Continue</a>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
