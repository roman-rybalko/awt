<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="user">
<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
		<meta name="description" content="Advanced Web Testing / Web Automation"/>
		<base href="ui-en/"/>
		<title>Advanced Web Testing / Web Automation</title>
		<xsl:if test="redirect">
			<xsl:choose>
				<xsl:when test="redirect/@timeout">
					<xsl:choose>
						<xsl:when test="contains(redirect/@url, '://')">
							<meta http-equiv="refresh" content="{redirect/@timeout};url={redirect/@url}"/>
						</xsl:when>
						<xsl:otherwise>
							<meta http-equiv="refresh" content="{redirect/@timeout};url=../{redirect/@url}"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="contains(redirect/@url, '://')">
							<meta http-equiv="refresh" content="0;url={redirect/@url}"/>
						</xsl:when>
						<xsl:otherwise>
							<meta http-equiv="refresh" content="0;url=../{redirect/@url}"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<link href="css/bootstrap.min.css" rel="stylesheet"/>
		<link href="css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
		<!--[if lt IE 9]>
			<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
			<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
		<![endif] -->
		<script src="js/jquery.min.js"></script>
		<script src="js/bootstrap.min.js"></script>
	</head>
	<body>
		<xsl:apply-templates select="*[not(self::message)]"/>
		<link href="css/awt.css" rel="stylesheet"/>
		<script src="js/awt.js"></script>
	</body>
</html>
</xsl:template>

</xsl:stylesheet>
