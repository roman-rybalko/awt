<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="history">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="history" mode="menu">
	<script src="ui-en/js/jquery.dataTables.min.js" type="text/javascript"></script>
	<link href="ui-en/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
	<script src="ui-en/js/dataTables.responsive.min.js" type="text/javascript"></script>
	<link href="ui-en/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/responsive.bootstrap.min.js" type="text/javascript"></script>
	<xsl:call-template name="js_task_types"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">History</h1>
				<xsl:apply-templates select="//message"/>
				<div class="apply-data-display-period">
					<xsl:if test="count(event) &gt; 500">
						<div class="alert alert-info alert-dismissable">
							<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-display-period">&#215;</button>
							<b>Tip:</b>
							Use <b>Data Display Period</b> option in <a href="./?settings=1">Settings</a> to reduce displayed data and speed up the UI.
						</div>
					</xsl:if>
				</div>
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
				<xsl:if test="event">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-purge-period">&#215;</button>
						<b>Tip:</b>
						History data is purged after 42 days.
					</div>
				</xsl:if>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
