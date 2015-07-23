<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="register">
	<form method="post">
		Login:<input type="text" name="user"/><br/>
		Password:<input type="password" name="password1"/><br/>
		Password(confirm):<input type="password" name="password2"/><br/>
		<input type="submit" name="register" value="Register"/>
	</form>
	<a href="../">login</a>
</xsl:template>
</xsl:stylesheet>
