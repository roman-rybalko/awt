<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="stats">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="stats" mode="menu">
	<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="js/excanvas.min.js"></script><![endif]-->
    <script src="js/jquery.flot.min.js"></script>
    <script src="js/jquery.flot.resize.min.js"></script>
    <script src="js/jquery.flot.time.min.js"></script>
    <script src="js/jquery.flot.tooltip.min.js"></script>
	<script type="text/javascript">
		tasks_finished = [  // global
			<xsl:for-each select="stat">
				<xsl:sort select="@time" data-type="number" order="ascending"/>
				[<xsl:value-of select="@time"/>000, <xsl:value-of select="@tasks_finished"/>],
			</xsl:for-each>
		];
	</script>
	<script type="text/javascript">
		tasks_failed = [  // global
			<xsl:for-each select="stat">
				<xsl:sort select="@time" data-type="number" order="ascending"/>
				[<xsl:value-of select="@time"/>000, <xsl:value-of select="@tasks_failed"/>],
			</xsl:for-each>
		];
	</script>
	<script type="text/javascript">
		actions_executed = [  // global
			<xsl:for-each select="stat">
				<xsl:sort select="@time" data-type="number" order="ascending"/>
				[<xsl:value-of select="@time"/>000, <xsl:value-of select="@actions_executed"/>],
			</xsl:for-each>
		];
	</script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Stats</h1>
				<xsl:apply-templates select="//message"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-3 col-md-6">
				<div class="panel panel-green">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3">
								<i class="fa fa-code fa-5x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<div class="huge">
									<xsl:value-of select="@tests"/>
								</div>
								<div>Tests</div>
							</div>
						</div>
					</div>
					<a href="../?tests=1">
						<div class="panel-footer">
							<span class="pull-left">Details</span>
							<span class="pull-right">
								<i class="fa fa-arrow-circle-right"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
			</div>
			<div class="col-lg-3 col-md-6">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3">
								<i class="fa fa-clock-o fa-5x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<div class="huge">
									<xsl:value-of select="@scheds"/>
								</div>
								<div>Schedule Jobs</div>
							</div>
						</div>
					</div>
					<a href="../?schedule=1">
						<div class="panel-footer">
							<span class="pull-left">Details</span>
							<span class="pull-right">
								<i class="fa fa-arrow-circle-right"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
			</div>
			<div class="col-lg-3 col-md-6">
				<div class="panel panel-yellow">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3">
								<i class="fa fa-refresh fa-5x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<div class="huge">
									<xsl:value-of select="@spendings_monthly"/>
								</div>
								<div>Monthly Spendings (Tasks)</div>
							</div>
						</div>
					</div>
					<a href="../?tasks=1" class="apply-data-display-period">
						<div class="panel-footer">
							<span class="pull-left">Details</span>
							<span class="pull-right">
								<i class="fa fa-arrow-circle-right"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
			</div>
			<div class="col-lg-3 col-md-6">
				<div class="panel panel-red">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3">
								<i class="fa fa-money fa-5x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<div class="huge">
									<xsl:value-of select="@actions_available"/>
								</div>
								<div>Available Actions (Account Balance)</div>
							</div>
						</div>
					</div>
					<a href="../?billing=1" class="apply-data-display-period">
						<div class="panel-footer">
							<span class="pull-left">Details</span>
							<span class="pull-right">
								<i class="fa fa-arrow-circle-right"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<div class="panel panel-default">
					<div class="panel-heading">
						Tasks
					</div>
					<div class="panel-body">
						<div class="flot-chart">
							<div class="flot-chart-content" id="tasks-chart"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="panel panel-default">
					<div class="panel-heading">
						Actions
					</div>
					<div class="panel-body">
						<div class="flot-chart">
							<div class="flot-chart-content" id="task-actions-chart"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
