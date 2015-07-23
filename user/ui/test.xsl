<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="test">
	<h1>Test <xsl:value-of select="@id"/></h1>
	<table>
	<tr><th>id</th><th>type</th><th>selector</th><th>data</th></tr>
	<xsl:for-each select="action">
		<tr>
			<td><xsl:value-of select="@id"/></td>
			<td>
				<form method="post">
					<input type="hidden" name="test_action_id" value="{@id}"/>
					<input type="text" name="type" value="{@type}"/>
					<input type="submit" name="modify" value="Modify"/>
				</form>
			</td>
			<td>
				<form method="post">
					<input type="hidden" name="test_action_id" value="{@id}"/>
					<input type="text" name="selector" value="{@selector}"/>
					<input type="submit" name="modify" value="Modify"/>
				</form>
			</td>
			<td>
				<form method="post">
					<input type="hidden" name="test_action_id" value="{@id}"/>
					<input type="text" name="data" value="{@data}"/>
					<input type="submit" name="modify" value="Modify"/>
				</form>
			</td>
			<td>
				<form method="post">
					<input type="hidden" name="test_action_id" value="{@id}"/>
					<input type="submit" name="delete" value="Delete"/>
				</form>
			</td>
		</tr>
	</xsl:for-each>
	</table>
	<form method="post">
		<table>
			<tr><th>id</th><th>type</th><th>selector</th><th>data</th></tr>
			<tr>
				<td><input type="text" name="test_action_id"/></td>
				<td><input type="text" name="type"/></td>
				<td><input type="text" name="selector"/></td>
				<td><input type="text" name="data"/></td>
				<td><input type="submit" name="add" value="Add"/></td>
				<td><input type="submit" name="insert" value="Insert"/></td>
			</tr>
		</table>
	</form>
</xsl:template>
</xsl:stylesheet>
