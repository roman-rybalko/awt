<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="user">
	<html>
		<base href="ui/" />
		<script src="jquery-1.11.3.min.js"></script>
	<body>
		<xsl:apply-templates select="*" />
	</body>
	</html>
</xsl:template>
</xsl:stylesheet>
