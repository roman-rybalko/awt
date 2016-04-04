<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template name="menu">
	<link href="ui-en/css/metisMenu.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/metisMenu.min.js" type="text/javascript"></script>
	<script src="ui-en/js/moment.min.js" type="text/javascript"></script>
	<xsl:if test="@time">
		<script type="text/javascript">
			var awt_time = "<xsl:value-of select="@time"/>";
		</script>
	</xsl:if>
	<div id="wrapper">
		<nav class="navbar navbar-default navbar-static-top" role="navigation"
			style="margin-bottom: 0">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="./../">Advanced Web Testing</a>
			</div>
			<ul class="nav navbar-top-links navbar-right">
				<xsl:if test="../@login = ''">
					<li>
						<div class="navbar-button-wrap">
							<form action="./" method="get">
								<input type="hidden" name="register" value="1"/>
								<button class="btn btn-success">Create Account</button>
							</form>
						</div>
					</li>
				</xsl:if>
				<li>
					<a href="http://www.youtube.com/channel/UCQWs8D0AqvofSedL_4g4DIw" target="_blank">
						<i class="fa fa-life-bouy fa-fw"></i>
						Tutorial
					</a>
				</li>
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						<i class="fa fa-user fa-fw"></i>
						<span class="space-x">
							<xsl:value-of select="../@login"/>
						</span>
						<i class="fa fa-caret-down"></i>
					</a>
					<ul class="dropdown-menu dropdown-user">
						<li>
							<a href="./?settings=1">
								<i class="fa fa-gear fa-fw"></i>
								Settings
							</a>
						</li>
						<li class="divider"></li>
						<li>
							<a href="./?logout=1">
								<i class="fa fa-sign-out fa-fw"></i>
								Logout
							</a>
						</li>
					</ul>
				</li>
			</ul>
			<div class="navbar-default sidebar" role="navigation">
				<div class="sidebar-nav navbar-collapse">
					<ul class="nav" id="side-menu">
						<li>
							<a href="./?stats=1">
								<i class="fa fa-bar-chart-o fa-fw"></i>
								Stats
							</a>
						</li>
						<li>
							<a href="./?tests=1">
								<i class="fa fa-code fa-fw"></i>
								Tests
							</a>
						</li>
						<li>
							<a href="./?test_groups=1">
								<i class="fa fa-file-code-o fa-fw"></i>
								Test Groups
							</a>
						</li>
						<li>
							<a href="./?tasks=1" class="apply-data-display-period">
								<i class="fa fa-play fa-fw"></i>
								Tasks
							</a>
						</li>
						<li>
							<a href="./?schedule=1">
								<i class="fa fa-clock-o fa-fw"></i>
								Schedule
							</a>
						</li>
						<li>
							<a href="./?billing=1" class="apply-data-display-period">
								<i class="fa fa-money fa-fw"></i>
								Billing
							</a>
						</li>
						<li>
							<a href="./?history=1" class="apply-data-display-period">
								<i class="fa fa-calendar fa-fw"></i>
								History
							</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<div id="page-wrapper">
			<xsl:apply-templates select="." mode="menu"/>
		</div>
	</div>
	<div id="footer">
		<div class="container-fluid">
			<p class="footer-line-1">
				© 2015 Advanced Web Testing
			</p>
			<p class="footer-line-2">
				<a href="mailto:support@advancedwebtesting.com?subject=UI%20Support%20Request:%20&amp;body=Login:%20{../@login}%0a">
					Support
				</a>
			</p>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>