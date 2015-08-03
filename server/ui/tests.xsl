<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="tests">
	<h1>Tests</h1>
	<table>
	<tr><th>id</th><th>name</th></tr>
	<xsl:for-each select="test">
		<tr>
			<td><xsl:value-of select="@id"/></td>
			<td>
				<form method="post">
					<input type="hidden" name="test_id" value="{@id}"/>
					<input type="text" name="name" value="{@name}"/>
					<input type="submit" name="modify" value="Modify"/>
				</form>
			</td>
			<td>
				<form method="post">
					<input type="hidden" name="test_id" value="{@id}"/>
					<input type="submit" name="delete" value="Delete"/>
				</form>
			</td>
			<td>
				<a href="../?test={@id}">Test Actions</a>
			</td>
			<td>
				<form method="post" action="../?tasks=1">
					<input type="hidden" name="test_id" value="{@id}"/>
					<input type="text" name="type"/>
					debug: <input type="text" name="debug"/>
					<input type="submit" name="add" value="Task"/>
				</form>
			</td>
		</tr>
	</xsl:for-each>
	</table>
	<form method="post">
		<input type="text" name="name"/>
		<input type="submit" name="add" value="Add"/>
	</form>
	<a href="../?tasks=1">Tasks</a><br/>
	<a href="../">Dashboard</a><br/>
</xsl:template>
</xsl:stylesheet>
