<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="history">
	<xsl:call-template name="menu" />
</xsl:template>

<xsl:template match="history" mode="menu">
	<link href="css/dataTables.bootstrap.css" rel="stylesheet"/>
	<script src="js/jquery.dataTables.min.js"></script>
	<script src="js/dataTables.bootstrap.min.js"></script>
	<xsl:call-template name="js_task_types"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">History</h1>
				<xsl:if test="//message">
					<div class="row">
						<div class="col-lg-12">
							<xsl:apply-templates select="//message" />
						</div>
					</div>
				</xsl:if>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-info">
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
							<xsl:if test="count(event) &lt;= 10">
								<xsl:attribute name="data-paging">false</xsl:attribute>
							</xsl:if>
							<thead>
								<tr>
									<th>Time</th>
									<th>Event</th>
									<th data-orderable="false">Data</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="event">
									<tr>
										<xsl:attribute name="class">
											<xsl:apply-templates select="." mode="severity"/>
										</xsl:attribute>
										<td class="time-unix2human">
											<xsl:value-of select="@time"/>
										</td>
										<td>
											<xsl:apply-templates select="." mode="title"/>
										</td>
										<td>
											<xsl:apply-templates select="." mode="data"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
				<xsl:call-template name="helper_tip">
					<xsl:with-param name="state">history-clear</xsl:with-param>
					<xsl:with-param name="text">
						History data is cleared after 42 days.
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
