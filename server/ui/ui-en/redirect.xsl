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
						<a href="../" id="redirect">Continue</a>
						<script type="text/javascript">
							$(function(){
								<xsl:choose>
									<xsl:when test="contains(@url, '://')">
										$('#redirect').attr('href', '<xsl:value-of select="@url"/>');
									</xsl:when>
									<xsl:otherwise>
										$('#redirect').attr('href', '../<xsl:value-of select="@url"/>');
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="@timeout">
										window.setTimeout(function(){
											window.location = $('#redirect').attr('href');
										}, <xsl:value-of select="@timeout"/>000);
									</xsl:when>
									<xsl:otherwise>
										window.location = $('#redirect').attr('href');
									</xsl:otherwise>
								</xsl:choose>
							});
						</script>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>