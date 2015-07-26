<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="login">
	<form method="post">
		Login:<input type="text" name="user"/><br/>
		Password:<input type="password" name="password"/><br/>
		<input type="submit" name="login" value="Enter"/>
	</form>
	<a href="../?register=1">register</a>
</xsl:template>
</xsl:stylesheet>
