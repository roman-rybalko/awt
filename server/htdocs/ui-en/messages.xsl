<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="message[@type='notice']">
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:apply-templates select="." mode="message" />
	</div>
</xsl:template>

<xsl:template match="message[@type='error']">
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:apply-templates select="." mode="message" />
	</div>
</xsl:template>

<xsl:template match="message[@value='bad_login']" mode="message">
	Invalid credentials
</xsl:template>

<xsl:template match="message[@value='task_add_ok']" mode="message">
	New task created
</xsl:template>

<xsl:template match="message[@value='task_add_fail']" mode="message">
	Task initialization error
</xsl:template>

<xsl:template match="message[@value='task_delete_ok']" mode="message">
	Task deleted
</xsl:template>

<xsl:template match="message[@value='task_delete_fail']" mode="message">
	Task delete error
</xsl:template>

<xsl:template match="message" mode="message">
	<xsl:value-of select="@value" />
</xsl:template>

</xsl:stylesheet>