<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="action[@type = 'open']" mode="action_html">
	<div class="col-lg-2">
		<b>Open site</b>
	</div>
	<div class="col-lg-10" title="{@data}">
		<b>URL</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'open']" mode="action_text">
	Open URL: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'open']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}" id="action-type-{@type}-{$id}">Open site</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">URL</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="action_html">
	<div class="col-lg-2">
		<b>Element exists</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="action_text">
	Element exists, XPATH: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Element exists</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="action_html">
	<div class="col-lg-2">
		<b>Click</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="action_text">
	Click, XPATH: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Click</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="action_html">
	<div class="col-lg-2">
		<b>Enter</b>
	</div>
	<div class="col-lg-6" title="{@selector}">
		<b>XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-4" title="{@data}">
		<b>Value</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="action_text">
	Enter, XPATH: <xsl:value-of select="@selector"/>, Value: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Enter</label>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">Value</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'match']" mode="action_html">
	<div class="col-lg-2">
		<b>Match</b>
	</div>
	<div class="col-lg-6" title="{@selector}">
		<b>XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-4" title="{@data}">
		<b>RegExp</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'match']" mode="action_text">
	Match, XPATH: <xsl:value-of select="@selector"/>, RegExp: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'match']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Match</label>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">RegExp</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="action_html">
	<div class="col-lg-2">
		<b>Modify</b>
	</div>
	<div class="col-lg-6" title="{@selector}">
		<b>XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-4" title="{@data}">
		<b>Value</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="action_text">
	Modify, XPATH: <xsl:value-of select="@selector"/>, Value: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Modify</label>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">Value</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var']" mode="action_html">
	<div class="col-lg-2">
		<b>Set variable</b>
	</div>
	<div class="col-lg-5" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-5" title="{@data}">
		<b>Value</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var']" mode="action_text">
	Set variable, Variable: <xsl:value-of select="@selector"/>, Value: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'var']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Set variable</label>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">Variable</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">Value</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="action_html">
	<div class="col-lg-2">
		<b>Set variable to value from xpath</b>
	</div>
	<div class="col-lg-4" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-6" title="{@data}">
		<b>XPATH</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="action_text">
	Set variable to value from xpath, Variable: <xsl:value-of select="@selector"/>, XPATH: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">Set variable to value from xpath</label>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">Variable</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">XPATH</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action" mode="action_html">
	<div class="col-lg-2">
		<b><xsl:value-of select="@type"/></b>
	</div>
	<div class="col-lg-5" title="{@selector}">
		<b>Selector</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-5" title="{@data}">
		<b>Data</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action" mode="action_text">
	<xsl:value-of select="@type"/>, Selector: <xsl:value-of select="@selector"/>, Data: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action" mode="action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{$id}"><xsl:value-of select="@type"/></label>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">Selector</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">Data</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
