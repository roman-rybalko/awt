<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="user">
<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
		<meta name="description" content="Advanced Web Testing, Web Automation, Web Monitoring"/>
		<title>Advanced Web Testing</title>
		<link href="ui-en/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
		<link href="ui-en/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
		<!--[if lt IE 9]>
			<script src="ui-en/js/html5shiv.js" type="text/javascript"></script>
			<script src="ui-en/js/respond.min.js" type="text/javascript"></script>
		<![endif] -->
		<script src="ui-en/js/jquery.min.js" type="text/javascript"></script>
		<script src="ui-en/js/bootstrap.min.js" type="text/javascript"></script>
	</head>
	<body>
		<script type="text/javascript">
			var awt_login = "<xsl:value-of select="@login"/>";
		</script>
		<xsl:apply-templates select="*[not(self::message)]"/>
		<link href="ui-en/css/awt.css" rel="stylesheet" type="text/css"/>
		<script src="ui-en/js/awt.js" type="text/javascript"></script>
		<script type="text/javascript">
		  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		  ga('create', 'UA-71272598-1', 'auto');
		  ga('send', 'pageview');
		</script>
	</body>
</html>
</xsl:template>

</xsl:stylesheet>
