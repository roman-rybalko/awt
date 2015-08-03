<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="tasks">
	<h1>Tasks</h1>
	<table>
	<tr><th>id</th><th>test id</th><th>type</th><th>status</th></tr>
	<xsl:for-each select="task">
		<tr>
			<td><xsl:value-of select="@id"/></td>
			<td><a href="../?test={@test_id}"><xsl:value-of select="@test_id"/></a></td>
			<td>
				<xsl:value-of select="@type"/>
				<xsl:if test="@debug">
					(debug)
				</xsl:if>
			</td>
			<td><xsl:value-of select="@status"/></td>
			<td>
				<form method="post">
					<input type="hidden" name="task_id" value="{@id}"/>
					<input type="submit" name="delete" value="Delete"/>
				</form>
			</td>
			<td>
				<a href="../?task={@id}">Results</a>
			</td>
		</tr>
	</xsl:for-each>
	</table>
	<a href="../?tests=1">Tests</a><br/>
	<a href="../">Dashboard</a><br/>
</xsl:template>
</xsl:stylesheet>
