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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Open a site.
			<br/>
			<i>URL</i> may be with or without a scheme (http/https/ftp).
			If the scheme is not set - "http://" will be used.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>URL</i>: <code>http://example.com/</code>
			<br/>
			<i>URL</i>: <code>example.com</code>
			<br/>
			<i>URL</i>: <code>{scheme}://{user}:{password}@{site}:{port}/{page}</code> (variable substitution)
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Check an element is present on the page.
			<br/>
			<i>Element XPATH</i> must specify an xpath to the element, not an attribute or a text.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Element XPATH</i>: <code>//table</code> (find a table in the document)
			<br/>
			<i>Element XPATH</i>: <code>//input[@name = "search"]</code> (find an input with attribute name="search")
			<br/>
			<i>Element XPATH</i>: <code>//{element}[@id = "{element_id}" and contains(@class, "in")]</code> (variable substitution)
			<br/>
			<i>Element XPATH</i>: <code>//input[@name = "search"]/@value</code> - <span class="text-failure">wrong</span>
			<br/>
			<i>Element XPATH</i>: <code>//table//text()</code> - <span class="text-failure">wrong</span>
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_syntax.asp" target="_blank">XPath Syntax</a>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_axes.asp" target="_blank">XPath Axes</a>
			<br/>
			<a href="http://developer.mozilla.org/en-US/docs/Web/XPath/Functions" target="_blank">XPath Functions</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Click on an element. The element may be any visible element, not only an input or a link. If the element is not visible an error will be raised.
			<br/>
			<i>Element XPATH</i> must specify an xpath to the element, not an attribute or a text.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Element XPATH</i>: <code>//table//a</code> (click a link in a table)
			<br/>
			<i>Element XPATH</i>: <code>//button[@type = "submit" and @name = "search"]</code> (click a button with attributes name="search" and type="submit")
			<br/>
			<i>Element XPATH</i>: <code>//{element}[@id = "id123456" and contains(@{element_attr}, "{element_attr_value}")]</code> (variable substitution)
			<br/>
			<i>Element XPATH</i>: <code>//input[@name = "search"]/@value</code> - <span class="text-failure">wrong</span>
			<br/>
			<i>Element XPATH</i>: <code>//a/text()</code> - <span class="text-failure">wrong</span>
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_syntax.asp" target="_blank">XPath Syntax</a>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_axes.asp" target="_blank">XPath Axes</a>
			<br/>
			<a href="http://developer.mozilla.org/en-US/docs/Web/XPath/Functions" target="_blank">XPath Functions</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Enter a value into an input (via keyboard events).
			<br/>
			<i>Input XPATH</i> must specify an xpath to the input element.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			<i>Value</i> may contain variables {var}.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Input XPATH</i>: <code>//input</code>, <i>Value</i>: <code>test value</code>
			<br/>
			<i>Input XPATH</i>: <code>//input[@name = "q" and contains(@class, "search")]</code>, <i>Value</i>: <code>web testing</code>
			<br/>
			<i>Input XPATH</i>: <code>//form[ends-with(@action, "submit.cgi")]//input[@name = "data"]</code>, <i>Value</i>: <code>sample data</code>
			<br/>
			<i>Input XPATH</i>: <code>//div[@id = "{targetId}"]/input</code>, <i>Value</i>: <code>{targetValue}</code> (variable substitution)
			<br/>
			<i>Input XPATH</i>: <code>//input[@name = "search"]/@value</code> - <span class="text-failure">wrong</span>
			<br/>
			<i>Input XPATH</i>: <code>//a/text()</code> - <span class="text-failure">wrong</span>
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_syntax.asp" target="_blank">XPath Syntax</a>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_axes.asp" target="_blank">XPath Axes</a>
			<br/>
			<a href="http://developer.mozilla.org/en-US/docs/Web/XPath/Functions" target="_blank">XPath Functions</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Change an element body (innerHTML) or an attribute value.
			<br/>
			This is a pure hack. There is no user interaction that can lead to such page modification.
			<br/>
			May be used to fill an input where scripts prevent entering a specific value,
			to change the value of a hidden input,
			to make an element visible,
			to disable an event-triggered script,
			etc.
			<br/>
			<i>XPATH Expression</i> must specify an xpath to an element or an attribute.
			If an xpath to an element is specified, inner content of the element (el.innerHTML) will be replaced.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			<i>Value</i> may contain variables {var}.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>XPATH Expression</i>: <code>//input/@value</code>, <i>Value</i>: <code>100.01</code>
			<br/>
			<i>XPATH Expression</i>: <code>//div[@id = "trash-body" and contains(@class, "collapse")]/@style</code>, <i>Value</i>: <code>display: initial</code> (show the element)
			<br/>
			<i>XPATH Expression</i>: <code>//a[contains(@href, "advancedwebtesting.com")]/@onmousedown</code>, <i>Value</i>: <code>return true;</code> (disable the script)
			<br/>
			<i>XPATH Expression</i>: <code>//div[@id = "{id}"]</code>, <i>Value</i>: <code>{data}</code> (variable substitution)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_syntax.asp" target="_blank">XPath Syntax</a>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_axes.asp" target="_blank">XPath Axes</a>
			<br/>
			<a href="http://developer.mozilla.org/en-US/docs/Web/XPath/Functions" target="_blank">XPath Functions</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Check the browser URL.
			<br/>
			<i>RegExp</i> is a <a href="http://wikipedia.org/wiki/Regular_expression" target="_blank">regular expression</a>
			without any language-specific wrapper clauses (<code>//</code>, <code>""</code>, <code>''</code>).
			POSIX &amp; Perl regexps are supported.
			The regexp is <i>case-insensitive</i> &amp; <i>greedy</i>.
			May contain variables {var}. The variable is initialized in another action.
			<code>{}</code> regexp clause is not supported due to variable substitution.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>RegExp</i>: <code>example.com</code>
			<br/>
			<i>RegExp</i>: <code>https://</code>
			<br/>
			<i>RegExp</i>: <code>x\d+\.example\.com</code>
			<br/>
			<i>RegExp</i>: <code>h[[:digit:]]+\.{site}</code> (<i>site</i> variable substitution, the variable itself may contain a regexp)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://wikipedia.org/wiki/Regular_expression#Syntax" target="_blank">RegExp Syntax</a>
			<br/>
			<a href="http://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/RegExp#character-classes" target="_blank">Character Classes</a>
			<br/>
			<a href="http://perldoc.perl.org/perlre.html#Extended-Patterns" target="_blank">Perl Extended Patterns</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Check the page title.
			<br/>
			<i>RegExp</i> is a <a href="http://wikipedia.org/wiki/Regular_expression" target="_blank">regular expression</a>
			without any language-specific wrapper clauses (<code>//</code>, <code>""</code>, <code>''</code>).
			POSIX &amp; Perl regexps are supported.
			The regexp is <i>case-insensitive</i> &amp; <i>greedy</i>.
			May contain variables {var}. The variable is initialized in another action.
			<code>{}</code> regexp clause is not supported due to variable substitution.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>RegExp</i>: <code>Search</code> (substring)
			<br/>
			<i>RegExp</i>: <code>\d</code>
			<br/>
			<i>RegExp</i>: <code>[[:alpha:]][[:digit:]]</code>
			<br/>
			<i>RegExp</i>: <code>{site}</code> (<i>site</i> variable substitution, the variable itself may contain a regexp)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://wikipedia.org/wiki/Regular_expression#Syntax" target="_blank">RegExp Syntax</a>
			<br/>
			<a href="http://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/RegExp#character-classes" target="_blank">Character Classes</a>
			<br/>
			<a href="http://perldoc.perl.org/perlre.html#Extended-Patterns" target="_blank">Perl Extended Patterns</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Apply <i>RegExp</i> to a variable value and place the first match into the variable, replacing the whole variable.
			<br/>
			<i>Variable</i> - variable name. May contain other variables {var}.
			<br/>
			<i>RegExp</i> is a <a href="http://wikipedia.org/wiki/Regular_expression" target="_blank">regular expression</a>
			without any language-specific wrapper clauses (<code>//</code>, <code>""</code>, <code>''</code>).
			POSIX &amp; Perl regexps are supported.
			The regexp is <i>case-insensitive</i> &amp; <i>greedy</i>.
			May contain variables {var}.
			<code>{}</code> regexp clause is not supported due to variable substitution.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Variable</i>: <code>title</code>, <i>RegExp</i>: <code>.+Search</code> (remove the part of the string after the "Search")
			<br/>
			<i>Variable</i>: <code>line</code>, <i>RegExp</i>: <code>\d+</code> (find a numbr and remove everything else)
			<br/>
			<i>Variable</i>: <code>{varname}</code>, <i>RegExp</i>: <code>(ht|f)tps?://{site}</code> (variable substitution, variables: <i>varname</i> &amp; <i>site</i>)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://wikipedia.org/wiki/Regular_expression#Syntax" target="_blank">RegExp Syntax</a>
			<br/>
			<a href="http://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/RegExp#character-classes" target="_blank">Character Classes</a>
			<br/>
			<a href="http://perldoc.perl.org/perlre.html#Extended-Patterns" target="_blank">Perl Extended Patterns</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Take a value of the element or attribute, selected by <i>XPATH Expression</i>, and copy the value into a variable.
			Initializes a new variable if it does not exist.
			<br/>
			<i>Variable</i> - variable name. May contain other variables {var}. If the variable exists it will be replaced.
			<br/>
			<i>XPATH Expression</i> must specify an xpath to an element or an attribute.
			If an xpath to an element is specified, inner content of the element (el.innerHTML) will be saved.
			May contain variables {var}.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Variable</i>: <code>price</code>, <i>XPATH Expression</i>: <code>//span[@id = "price"]</code>
			<br/>
			<i>Variable</i>: <code>url</code>, <i>XPATH Expression</i>: <code>//a[contains(text(), "Hosting")]/@href</code>
			<br/>
			<i>Variable</i>: <code>url2</code>, <i>XPATH Expression</i>: <code>//a[contains(text(), "Hosting") and @href != "{url}"]/@href</code> (variable substitution)
			<br/>
			<i>Variable</i>: <code>classes_{id}</code>, <i>XPATH Expression</i>: <code>//div[@id = "{id}"]/@class</code> (variable substitution)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_syntax.asp" target="_blank">XPath Syntax</a>
			<br/>
			<a href="http://www.w3schools.com/xsl/xpath_axes.asp" target="_blank">XPath Axes</a>
			<br/>
			<a href="http://developer.mozilla.org/en-US/docs/Web/XPath/Functions" target="_blank">XPath Functions</a>
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Take the browser URL and copy it into a variable.
			Initializes a new variable if it does not exist.
			<br/>
			<i>Variable</i> - variable name. May contain other variables {var}. If the variable exists it will be replaced.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Variable</i>: <code>url</code>
			<br/>
			<i>Variable</i>: <code>url_{id}</code> (variable substitution)
		</div>
	</div>
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
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Take the page title and copy it into a variable.
			Initializes a new variable if it does not exist.
			<br/>
			<i>Variable</i> - variable name. May contain other variables {var}. If the variable exists it will be replaced.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Variable</i>: <code>title</code>
			<br/>
			<i>Variable</i>: <code>title_{id}</code> (variable substitution)
		</div>
	</div>
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

<xsl:template name="proxy_location_name">
	<xsl:param name="selected_value"/>
	<xsl:choose>
		<xsl:when test="document('proxy.xml')//location[@value = $selected_value]">
			<xsl:value-of select="document('proxy.xml')//location[@value = $selected_value]/@name"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$selected_value"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="action[@type = 'proxy']" mode="html">
	<div class="col-lg-2">
		<b>Set Proxy</b>
	</div>
	<div class="col-lg-4" title="{@selector}">
		<b>Location</b>:
		<xsl:call-template name="proxy_location_name">
			<xsl:with-param name="selected_value">
				<xsl:value-of select="@selector"/>
			</xsl:with-param>
		</xsl:call-template>
	</div>
	<xsl:if test="@selector = 'custom'">
		<div class="col-lg-6" title="{@data}">
			<b>Address</b>: <xsl:value-of select="@data"/>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="action[@type = 'proxy']" mode="text">
	<xsl:text/>Set Proxy, Location: <xsl:text/>
	<xsl:call-template name="proxy_location_name">
		<xsl:with-param name="selected_value">
			<xsl:value-of select="@selector"/>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:if test="@selector = 'custom'">
		<xsl:text/>, Address: <xsl:value-of select="@data"/>
	</xsl:if>
</xsl:template>

<xsl:template name="proxy_select_options">
	<xsl:param name="selected_value"/>
	<xsl:for-each select="document('proxy.xml')//location">
		<option value="{@value}">
			<xsl:if test="@value = $selected_value">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:value-of select="@name"/>
		</option>
	</xsl:for-each>
</xsl:template>

<xsl:template match="action[@type = 'proxy']" mode="form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="col-lg-12">
		<div class="well well-sm">
			<b>Usage:</b><br/>
			Change Proxy-server. All subsequent browser requests will come from an IP address of the proxy. 
			May be used to see how the site is looking in different cuntries, to mimic a firewall.
			<br/>
			The action will restart the browser. All windows will be closed.
			Session cookies (transient), local storage, history, etc. will be lost.
			Persistent cookies &amp; local storage will be preserved.
			<br/>
			<i>Location</i> - territorial location of the proxy server. Country of the source IP address.
			<br/>
			<i>Address</i> is activated when <i>Location</i> is set to <code>Custom</code>.
			Must specify a custom address of the proxy in the format <code>host:port</code>
			or an URL to a <a href="http://wikipedia.org/wiki/Proxy_auto-config" target="_blank">PAC-file</a>
			or set empty.
			The proxy-server must support <a href="http://wikipedia.org/wiki/Proxy_server#Web_proxy_servers" target="_blank">HTTP</a> protocol
			(<a href="http://wikipedia.org/wiki/SOCKS" target="_blank">SOCKS</a> protocol is not supported).
			The proxy-server must NOT use <a href="http://tools.ietf.org/html/rfc2617" target="_blank">HTTP authentication</a>.
			May contain variables {var}. The variable is initialized in another action.
			<br/>
			If <i>Location</i> is set to <code>Custom</code> and <i>Address</i> is clear - the proxy will be disabled.
			<br/>
			<b>Examples:</b>
			<br/>
			<i>Address</i>: <code>121.120.80.215:3128</code>
			<br/>
			<i>Address</i>: <code>104.155.194.251:8888</code>
			<br/>
			<i>Address</i>: <code>{host}:{port}</code> (variable substitution)
			<br/>
			<i>Address</i>: <code>{proxy}</code> (variable substitution)
			<br/>
			<b>Reference:</b>
			<br/>
			<a href="http://wikipedia.org/wiki/Proxy_server" target="_blank">Proxy server</a>
			<br/>
			<a href="http://google.com/search?q=proxy+list" target="_blank">Proxy list</a> (please, test the proxy before use)
		</div>
	</div>
	<div class="col-lg-2">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
				Set Proxy
			</label>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="form-group">
			<label for="action-selector-{@type}-{$id}">
				Location
			</label>
			<select class="form-control" name="selector" id="action-selector-{@type}-{$id}">
				<xsl:call-template name="proxy_select_options">
					<xsl:with-param name="selected_value">
						<xsl:value-of select="@selector"/>
					</xsl:with-param>
				</xsl:call-template>
			</select>
		</div>
	</div>
	<div class="col-lg-6 action-wrap-data-{@type}" data-id="{$id}">
		<div class="form-group">
			<label for="action-data-{@type}-{$id}">
				Address
			</label>
			<input class="form-control" type="text" name="data" value="{@data}" id="action-data-{@type}-{$id}" placeholder="host:port | http://url/to/file.pac | empty (disable)"/>
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
			<label for="action-selector-{@type}-{$id}" id="action-type-{@type}-{$id}">
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
