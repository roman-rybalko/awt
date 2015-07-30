<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="task">
	<h1>Task <xsl:value-of select="@id"/></h1>
	<a href="../?test={@test_id}">Test</a><br/>
	Status: <xsl:value-of select="@status"/><br/>
	<xsl:if test="@vnc">
		vnc: <xsl:value-of select="@vnc"/><br/>
	</xsl:if>
	<xsl:if test="@node_id">
		node_id: <xsl:value-of select="@node_id"/><br/>
	</xsl:if>
	<xsl:if test="action">
		<table>
		<tr><th>id</th><th>type</th><th>selector</th><th>data</th></tr>
		<xsl:for-each select="action">
			<tr>
				<td><xsl:value-of select="@id"/></td>
				<td><xsl:value-of select="@type"/></td>
				<td><xsl:value-of select="@selector"/></td>
				<td><xsl:value-of select="@data"/></td>
				<xsl:if test="@scrn">
					<td><a href="../results/{@scrn}"><img src="../results/{@scrn}" style="width: 100px; height: auto;"/></a></td>
				</xsl:if>
				<xsl:if test="@failed">
					<td style="color: red;">Failed: <xsl:value-of select="@failed"/></td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
	</xsl:if>
	<xsl:apply-templates select="message" />
</xsl:template>
</xsl:stylesheet>
