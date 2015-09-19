<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="action[@type = 'open']" mode="html">
	<div class="col-lg-2">
		<b>Open URL</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>URL</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'open']" mode="text">
	<xsl:text/>Open URL: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'open']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Open URL
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				URL
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="html">
	<div class="col-lg-2">
		<b>Element exists</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>Element XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="text">
	<xsl:text/>Element exists, Element XPATH: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'exists']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Element exists
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Element XPATH
			</label>
			<input class="form-control action-xpath-element" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="html">
	<div class="col-lg-2">
		<b>Click</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>Element XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="text">
	<xsl:text/>Click, Element XPATH: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'click']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Click
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Element XPATH
			</label>
			<input class="form-control action-xpath-element" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="html">
	<div class="col-lg-2">
		<b>Enter data</b>
	</div>
	<div class="col-lg-6" title="{@selector}">
		<b>Input XPATH</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-4" title="{@data}">
		<b>Value</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="text">
	<xsl:text/>Enter data, Input XPATH: <xsl:value-of select="@selector"/>, Value: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'enter']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Enter data
			</label>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Input XPATH
			</label>
			<input class="form-control action-xpath-element" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				Value
			</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="html">
	<div class="col-lg-2">
		<b>Modify XPATH</b>
	</div>
	<div class="col-lg-6" title="{@selector}">
		<b>XPATH Expression</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-4" title="{@data}">
		<b>Value</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="text">
	<xsl:text/>Modify XPATH, XPATH Expression: <xsl:value-of select="@selector"/>, Value: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'modify']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Modify XPATH
			</label>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				XPATH Expression
			</label>
			<input class="form-control action-xpath-expression" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				Value
			</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'url']" mode="html">
	<div class="col-lg-2">
		<b>Match URL</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>RegExp</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'url']" mode="text">
	<xsl:text/>Match URL: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'url']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Match URL
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				RegExp
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'title']" mode="html">
	<div class="col-lg-2">
		<b>Match Title</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>RegExp</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'title']" mode="text">
	<xsl:text/>Match Title: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'title']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Match Title
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				RegExp
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_regexp']" mode="html">
	<div class="col-lg-2">
		<b>Apply RegExp to Variable</b>
	</div>
	<div class="col-lg-4" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-6" title="{@data}">
		<b>RegExp</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_regexp']" mode="text">
	<xsl:text/>Apply RegExp to Variable, Variable: <xsl:value-of select="@selector"/>, RegExp: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'var_regexp']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Apply RegExp to Variable
			</label>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Variable
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				RegExp
			</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="html">
	<div class="col-lg-2">
		<b>Save XPATH to Variable</b>
	</div>
	<div class="col-lg-4" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
	<div class="col-lg-6" title="{@data}">
		<b>XPATH Expression</b>: <xsl:value-of select="@data"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="text">
	<xsl:text/>Save XPATH to Variable, Variable: <xsl:value-of select="@selector"/>, XPATH Expression: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action[@type = 'var_xpath']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Save XPATH to Variable
			</label>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Variable
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-6">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				XPATH Expression
			</label>
			<input class="form-control action-xpath-expression" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_url']" mode="html">
	<div class="col-lg-2">
		<b>Save URL to Variable</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_url']" mode="text">
	<xsl:text/>Save URL to Variable, Variable: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'var_url']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Save URL to Variable
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Variable
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_title']" mode="html">
	<div class="col-lg-2">
		<b>Save Title to Variable</b>
	</div>
	<div class="col-lg-10" title="{@selector}">
		<b>Variable</b>: <xsl:value-of select="@selector"/>
	</div>
</xsl:template>

<xsl:template match="action[@type = 'var_title']" mode="text">
	<xsl:text/>Save Title to Variable, Variable: <xsl:value-of select="@selector"/>
</xsl:template>

<xsl:template match="action[@type = 'var_title']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Save Title to Variable
			</label>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Variable
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="action" mode="html">
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

<xsl:template match="action" mode="text">
	<xsl:value-of select="@type"/>, Selector: <xsl:value-of select="@selector"/>, Data: <xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="action" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{$id}">
				<xsl:value-of select="@type"/>
			</label>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Selector
			</label>
			<input class="form-control" type="text" name="selector" value="{@selector}" id="action-selector-{@type}-{$id}"/>
		</div>
	</div>
	<div class="col-lg-5">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				Data
			</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}"/>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
