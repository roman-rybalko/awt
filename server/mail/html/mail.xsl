<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="mail">
<html>
<head>
	<meta charset="utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<meta name="description" content="Advanced Web Testing / Web Automation Service"/>
</head>
<body>
	<link href="cid:bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<link href="cid:awt.css" rel="stylesheet" type="text/css"/>
	<div id="wrapper">
		<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
			<div class="navbar-header">
				<a class="navbar-brand" href="{@root_url}">Advanced Web Testing</a>
			</div>
		</nav>
		<div id="mail-page-wrapper">
			<div class="container-fluid">
				<xsl:apply-templates/>
			</div>
		</div>
	</div>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
