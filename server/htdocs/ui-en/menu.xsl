<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template name="menu">
	<link href="css/metisMenu.min.css" rel="stylesheet" />
	<script src="js/metisMenu.min.js"></script>
	<script src="js/jquery.cookie.min.js"></script>
	<script src="js/jquery.storageapi.min.js"></script>
	<script src="js/storage.js"></script>
	<script src="js/moment.min.js"></script>
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
				<a class="navbar-brand" href="../">Advanced Web Testing</a>
			</div>
			<ul class="nav navbar-top-links navbar-right">
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						<i class="fa fa-user fa-fw"></i>
						<i class="fa fa-caret-down"></i>
					</a>
					<ul class="dropdown-menu dropdown-user">
						<li>
							<a href="../?settings=1">
								<i class="fa fa-gear fa-fw"></i>
								Settings
							</a>
						</li>
						<li class="divider"></li>
						<li>
							<a href="../?logout=1">
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
							<a href="../">
								<i class="fa fa-dashboard fa-fw"></i>
								Dashboard
							</a>
						</li>
						<li>
							<a href="../?tests=1">
								<i class="fa fa-code fa-fw"></i>
								Tests
							</a>
						</li>
						<li>
							<a href="../?tasks=1">
								<i class="fa fa-play fa-fw"></i>
								Tasks
							</a>
						</li>
						<li>
							<a href="../?schedule=1">
								<i class="fa fa-clock-o fa-fw"></i>
								Schedule
							</a>
						</li>
						<li>
							<a href="../?history=1">
								<i class="fa fa-calendar fa-fw"></i>
								History
							</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<div id="page-wrapper">
			<xsl:apply-templates select="." mode="menu" />
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>