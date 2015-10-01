<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="sched_fail">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Schedule Job Failed</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-6">
			<div class="panel panel-info">
				<div class="panel-body">
					<div class="row">
						<div class="col-lg-6">
							<b>Schedule Job</b>:
							<a href="{../@root_url}?schedule=1#{@sched_id}">
								<xsl:value-of select="@sched_name"/>
							</a>
						</div>
						<div class="col-lg-6">
							<b>Test</b>:
							<a href="{../@root_url}?test={@test_id}">
								<xsl:value-of select="@test_name"/>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="alert alert-danger">
				<span class="text-failure">
					<b class="space-x">Failure:</b>
					<xsl:value-of select="@message"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
