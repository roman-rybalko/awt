<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="test">
	<xsl:choose>
		<xsl:when test="//message[@value='test_action_add_ok' or @value='test_action_insert_ok']">
			<xsl:call-template name="redirect"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="menu"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="test" mode="menu">
	<script src="ui-en/js/messaging.js" type="text/javascript"></script>
	<script type="text/javascript">
		var messaging;
		error_handler(function() {
			messaging = new Messaging();
			messaging.ping();
		})();
	</script>
	<script src="ui-en/js/error-client.js" type="text/javascript"></script>
	<script src="ui-en/js/xpath-browser.js" type="text/javascript"></script>
	<script src="ui-en/js/xpath-composer.js" type="text/javascript"></script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Test</h1>
				<xsl:apply-templates select="//message"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-info">
					<div class="panel-body">
						<div class="row">
							<div class="col-lg-3">
								<b>Name</b>:
								<xsl:value-of select="@name"/>
							</div>
							<div class="col-lg-3">
								<b>Time</b>:
								<span class="time-unix2human">
									<xsl:value-of select="@time"/>
								</span>
							</div>
							<div class="col-lg-3">
								<b>Actions Count</b>:
								<span>
									<xsl:if test="count(action) &gt; @max_actions_cnt">
										<xsl:attribute name="class">text-failure</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="count(action)"/>
								</span>/<xsl:value-of select="@max_actions_cnt"/>
							</div>
							<xsl:if test="@deleted">
								<div class="col-lg-1">
									<b class="text-failure">Deleted</b>
								</div>
								<div class="col-lg-1">
									<form role="form" method="post" action="./?tests=1">
										<input type="hidden" name="id" value="{@id}"/>
										<button type="submit" name="restore" class="btn btn-xs btn-success">
											<i class="fa fa-recycle"></i>
											Restore
										</button>
									</form>
								</div>
							</xsl:if>
							<xsl:if test="not(@deleted)">
								<div class="col-lg-1">
									<button type="button" class="btn btn-xs btn-block btn-success" data-toggle="modal" data-target="#modal-test-run">
										<i class="fa fa-play"></i>
										Run
									</button>
								</div>
								<xsl:call-template name="modal_new_task">
									<xsl:with-param name="modal_id">modal-test-run</xsl:with-param>
									<xsl:with-param name="test_name"><xsl:value-of select="@name"/></xsl:with-param>
									<xsl:with-param name="test_id"><xsl:value-of select="@id"/></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
		<xsl:if test="not(@deleted)">
			<div class="row">
				<div class="col-lg-4">
					<div class="form-group">
						<a href="./file.php?test={@id}" class="btn btn-block btn-primary">
							<i class="glyphicon glyphicon-export"></i>
							Export
						</a>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="form-group">
						<a href="#" class="btn btn-block btn-success" data-toggle="modal" data-target="#modal-import">
							<i class="glyphicon glyphicon-import"></i>
							Import
						</a>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="form-group">
						<a href="#" class="btn btn-block btn-danger" data-toggle="modal" data-target="#modal-clear">
							<i class="glyphicon glyphicon-trash"></i>
							Clear
						</a>
					</div>
				</div>
			</div>
			<div class="modal" id="modal-import" role="dialog">
				<div class="modal-dialog modal-sm">
					<div class="panel panel-success">
						<div class="panel-heading">
							<button type="button" class="close" data-dismiss="modal">&#215;</button>
							Import
						</div>
						<div class="panel-body">
							<div class="alert alert-info alert-dismissable">
								<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="test-import-max-fsize">&#215;</button>
								<b>Tip:</b>
								Max. file size: 1 Mb
							</div>
							<form role="form" method="post" enctype="multipart/form-data">
								<input type="hidden" name="MAX_FILE_SIZE" value="1048576" />
								<p>
									<input name="data" type="file" accept=".json,application/json"/>
								</p>
								<button type="submit" name="import" class="btn btn-block btn-success">
									<i class="glyphicon glyphicon-import"></i>
									Import
								</button>
							</form>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">
								<i class="fa fa-undo"></i>
								Cancel
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="modal" id="modal-clear" role="dialog">
				<div class="modal-dialog modal-sm">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<button type="button" class="close" data-dismiss="modal">&#215;</button>
							Clear
						</div>
						<div class="panel-body">
							<form role="form" method="post">
								<p>
									<b>
										Delete All Actions ?
									</b>
								</p>
								<button type="submit" name="clear" class="btn btn-block btn-danger">
									<i class="glyphicon glyphicon-trash"></i>
									Clear
								</button>
							</form>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">
								<i class="fa fa-undo"></i>
								Cancel
							</button>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:for-each select="action">
			<xsl:sort select="@id" data-type="number" order="ascending"/>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-9">
									<div class="row">
										<xsl:apply-templates select="." mode="html"/>
									</div>
								</div>
								<xsl:if test="not(../@deleted)">
									<div class="col-lg-3">
										<button type="button" class="btn btn-xs btn-primary space-x space-y" data-toggle="modal" data-target="#modal-action-modify-{@id}">
											<i class="fa fa-edit"></i>
											Modify
										</button>
										<button type="button" class="btn btn-xs btn-success space-x space-y" data-toggle="modal" data-target="#modal-action-insert-{@id}">
											<i class="fa fa-expand"></i>
											Insert
										</button>
										<button type="button" class="btn btn-xs btn-danger space-x space-y" data-toggle="modal" data-target="#modal-action-delete-{@id}">
											<i class="glyphicon glyphicon-trash"></i>
											Delete
										</button>
									</div>
									<div class="modal" id="modal-action-modify-{@id}" role="dialog">
										<div class="modal-dialog modal-lg">
											<div class="panel panel-primary">
												<div class="panel-heading">
													<button type="button" class="close" data-dismiss="modal">&#215;</button>
													Modify:
													<xsl:value-of select="@name" />
												</div>
												<div class="panel-body">
													<form role="form" method="post">
														<input type="hidden" name="id" value="{@id}" />
														<input type="hidden" name="user_data" value="{@user_data}" id="action-user-data-modify-{@id}"/>
														<div class="row">
															<xsl:apply-templates select="." mode="form">
																<xsl:with-param name="id">modify-<xsl:value-of select="@id"/></xsl:with-param>
															</xsl:apply-templates>
														</div>
														<div class="form-group">
															<button type="submit" name="modify" class="btn btn-block btn-primary">
																<i class="fa fa-pencil"></i>
																Modify
															</button>
														</div>
													</form>
													<xsl:call-template name="xpath_browser">
														<xsl:with-param name="id">modify-<xsl:value-of select="@id"/></xsl:with-param>
													</xsl:call-template>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">
														<i class="fa fa-undo"></i>
														Cancel
													</button>
												</div>
											</div>
										</div>
									</div>
									<div class="modal" id="modal-action-insert-{@id}" role="dialog">
										<div class="modal-dialog modal-lg">
											<div class="panel panel-success">
												<div class="panel-heading">
													<button type="button" class="close" data-dismiss="modal">&#215;</button>
													Insert
												</div>
												<div class="panel-body">
													<form role="form" method="post" id="action-form-{@id}">
														<input type="hidden" name="id" value="{@id}"/>
														<input type="hidden" name="user_data" id="action-user-data-insert-{@id}"/>  <!-- no value -->
														<xsl:call-template name="new_action_form">
															<xsl:with-param name="id">insert-<xsl:value-of select="@id"/></xsl:with-param>
														</xsl:call-template>
														<div class="form-group">
															<button type="submit" name="insert" class="btn btn-block btn-success">
																<i class="fa fa-expand"></i>
																Insert
															</button>
														</div>
													</form>
													<xsl:call-template name="xpath_browser">
														<xsl:with-param name="id">insert-<xsl:value-of select="@id"/></xsl:with-param>
													</xsl:call-template>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">
														<i class="fa fa-undo"></i>
														Cancel
													</button>
												</div>
											</div>
										</div>
									</div>
									<div class="modal" id="modal-action-delete-{@id}" role="dialog">
										<div class="modal-dialog">
											<div class="panel panel-danger">
												<div class="panel-heading">
													<button type="button" class="close" data-dismiss="modal">&#215;</button>
													Delete
												</div>
												<div class="panel-body">
													<div class="row">
														<xsl:apply-templates select="." mode="html"/>
													</div>
													<div class="row">
														<div class="col-lg-12">
															<form role="form" method="post">
																<input type="hidden" name="id" value="{@id}" />
																<button type="submit" name="delete" class="btn btn-block btn-danger">
																	<i class="glyphicon glyphicon-trash"></i>
																	Delete
																</button>
															</form>
														</div>
													</div>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">
														<i class="fa fa-undo"></i>
														Cancel
													</button>
												</div>
											</div>
										</div>
									</div>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:for-each>
		<div id="action-autoadd-container"></div>
		<xsl:if test="not(@deleted)">
			<div class="row" id="action-add">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<form role="form" method="post" id="action-form">
								<input type="hidden" name="user_data" id="action-user-data-add"/>
								<xsl:call-template name="new_action_form">
									<xsl:with-param name="id">add</xsl:with-param>
								</xsl:call-template>
								<div class="form-group">
									<button type="submit" name="add" class="btn btn-block btn-success">
										<i class="fa fa-plus"></i>
										Add
									</button>
								</div>
							</form>
							<xsl:call-template name="xpath_browser">
								<xsl:with-param name="id">add</xsl:with-param>
							</xsl:call-template>
						</div>
					</div>
				</div>
			</div>
			<xsl:call-template name="xpath_composer"/>
		</xsl:if>
	</div>
	<div style="display: none;">
		<div id="action-autoadd-template-click">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-warning">
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-9">
									<div class="row">
										<div class="col-lg-2">
											<b>Click</b>
										</div>
										<div class="col-lg-10">
											<b>Element XPath</b>: <span class="action-autoadd-click-xpath"></span>
										</div>
									</div>
								</div>
								<div class="col-lg-3">
									<a href="#" class="btn btn-xs btn-primary location-href">
										<i class="fa fa-pencil"></i>
										Edit
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="action-autoadd-template-enter">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-warning">
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-9">
									<div class="row">
										<div class="col-lg-2">
											<b>Enter data</b>
										</div>
										<div class="col-lg-6">
											<b>Input XPath</b>: <span class="action-autoadd-enter-xpath"></span>
										</div>
										<div class="col-lg-4">
											<b>Value</b>: <span class="action-autoadd-enter-value"></span>
										</div>
									</div>
								</div>
								<div class="col-lg-3">
									<a href="#" class="btn btn-xs btn-primary location-href">
										<i class="fa fa-pencil"></i>
										Edit
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template name="new_action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="form-group">
		<label for="action-type-{$id}">Type</label>
		<select class="form-control action-type" name="type" id="action-type-{$id}" data-id="{$id}">
			<xsl:for-each select="document('actions.xml')//action">
				<option value="{@type}">
					<xsl:value-of select="@type"/>
				</option>
			</xsl:for-each>
		</select>
	</div>
	<xsl:for-each select="document('actions.xml')//action">
		<div class="row" id="action-wrap-type-{@type}-{$id}">
			<xsl:apply-templates select="." mode="form">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</div>
	</xsl:for-each>
</xsl:template>

<xsl:template name="xpath_browser">
	<xsl:param name="id" select="generate-id()"/>
	<div id="xpath-browser-{$id}">
		<div class="panel panel-info last">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#xpath-browser-{$id}" href="#xpath-browser-collapse-{$id}">
						<i class="fa fa-globe"></i>
						XPath Browser
					</a>
				</h4>
			</div>
			<div id="xpath-browser-collapse-{$id}" class="panel-collapse collapse xpath-browser-collapse" data-id="{$id}">
				<div class="panel-body">
					<div class="container-fluid">
						<div class="row">
							<div class="col-lg-12">
								<div class="well well-sm">
									<b>Usage:</b><br/>
									<p>
										To enable XPath Browser/Composer functionality you need to inject the service script<br/>
										<code><span class="location-path">https://advancedwebtesting.com/ui/</span>ui-en/php/xpath-browser-composer.php</code><br/>
										into the target page.
									</p>
									<p>
										You may use the following javascript code snippet<br/>
										<code>var script = document.createElement('script');</code><br/>
										<code>script.src="<span class="location-path">https://advancedwebtesting.com/ui/</span>ui-en/php/xpath-browser-composer.php";</code><br/>
										<code>document.head.appendChild(script);</code><br/>
										with browser extensions like <a href="https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/" target="_blank">Greasemonkey</a>,
										<a href="https://chrome.google.com/webstore/detail/custom-javascript-for-web/poakhlngfciodnhlhhgnaaelnpjljija" target="_blank">Custom JavaScript for websites</a>
										or <a href="https://chrome.google.com/webstore/detail/jscript-tricks/odialddippdmebbfbflcneemfdglimod" target="_blank">JScript tricks</a>.
									</p>
									<p>
										Try the test page
										<a href="#" onmousedown="$('#xpath-browser-url-{$id}').val($(this).text()); return false;" onclick="return false;"><span class="location-path">https://advancedwebtesting.com/ui/</span>ui-en/xpath-browser-composer-test.html</a>
										to see how it works.
									</p>
								</div>
							</div>
						</div>
						<div class="row">
							<form action="#" onsubmit="$(this).find('button.xpath-browser-open').click(); return false;"> <!-- to make "enter" work -->
								<div class="col-lg-1">
									<div class="form-group">
										<button type="button" class="btn btn-block btn-primary xpath-browser-backward" title="Backward" data-id="{$id}">
											<i class="fa fa-backward"></i>
										</button>
									</div>
								</div>
								<div class="col-lg-1">
									<div class="form-group">
										<button type="button" class="btn btn-block btn-primary xpath-browser-forward" title="Forward" data-id="{$id}">
											<i class="fa fa-forward"></i>
										</button>
									</div>
								</div>
								<div class="col-lg-9">
									<div class="form-group">
										<input type="text" class="form-control" placeholder="URL" id="xpath-browser-url-{$id}"/>
									</div>
								</div>
								<div class="col-lg-1">
									<div class="form-group">
										<button type="button" class="btn btn-block btn-primary xpath-browser-open" title="Open" data-id="{$id}">
											<i class="fa fa-play"></i>
										</button>
									</div>
								</div>
							</form>
						</div>
						<div class="row">
							<div class="col-lg-12">
								<xsl:if test="$id = 'add'">
									<div class="checkbox">
										<label>
											<input type="checkbox" class="control-state action-autoadd-control" data-control-state="xpath-composer-autoadd" data-id="{$id}"/>
											Auto-add actions (XPath Composer will not be used)
										</label>
									</div>
								</xsl:if>
								<div class="alert alert-info alert-dismissable">
									<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="xpath-composer-rclick">&#215;</button>
									<b>Tip:</b>
									Use right-click on anchors to capture the tag and prevent page loading.
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template name="xpath_composer">
	<div class="modal" id="modal-xpath-composer" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="panel panel-info">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					<i class="fa fa-pencil"></i>
					XPath Composer
				</div>
				<div class="panel-body">
					<div class="panel-group" id="xpath-composer-tags" style="margin-bottom: 10px;"></div>
					<p>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-xs btn-success">
								<input type="checkbox" id="xpath-composer-optimization-notext" class="control-state" data-control-state="xpath-composer-optimization-notext"/>
								no text()
							</label>
							<label class="btn btn-xs btn-success">
								<input type="checkbox" id="xpath-composer-optimization-noattr" class="control-state" data-control-state="xpath-composer-optimization-noattr"/>
								no @attr
							</label>
							<label class="btn btn-xs btn-success">
								<input type="checkbox" id="xpath-composer-optimization-noindex" class="control-state" data-control-state="xpath-composer-optimization-noindex"/>
								no [index]
							</label>
							<label class="btn btn-xs btn-success">
								<input type="checkbox" id="xpath-composer-optimization-nocontains" class="control-state" data-control-state="xpath-composer-optimization-nocontains"/>
								no contains(...)
							</label>
						</div>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-xs btn-default">
								<input type="radio" name="xpath-composer-comments-tags" class="xpath-composer-comments control-state" data-control-state="xpath-composer-comments-tags-none"/>
								no comments
							</label>
							<label class="btn btn-xs btn-default active">
								<input type="radio" name="xpath-composer-comments-tags" checked="checked" id="xpath-composer-comments-tags-main" class="xpath-composer-comments control-state" data-control-state="xpath-composer-comments-tags-main"/>
								main tag
							</label>
							<label class="btn btn-xs btn-default">
								<input type="radio" name="xpath-composer-comments-tags" id="xpath-composer-comments-tags-all" class="xpath-composer-comments control-state" data-control-state="xpath-composer-comments-tags-all"/>
								all tags
							</label>
						</div>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-xs btn-default">
								<input type="radio" name="xpath-composer-comments-preds" id="xpath-composer-comments-preds-all" class="xpath-composer-comments control-state" data-control-state="xpath-composer-comments-preds-all"/>
								all predicates
							</label>
							<label class="btn btn-xs btn-default active">
								<input type="radio" name="xpath-composer-comments-preds" checked="checked" class="xpath-composer-comments control-state" data-control-state="xpath-composer-comments-preds-specific"/>
								specific predicates
							</label>
						</div>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-xs btn-success">
								<input type="radio" name="xpath-composer-algo" id="xpath-composer-optimization"/>
								Optimize
							</label>
							<label class="btn btn-xs btn-primary">
								<input type="radio" name="xpath-composer-algo" id="xpath-composer-guess"/>
								Guess
							</label>
							<label class="btn btn-xs btn-warning">
								<input type="radio" name="xpath-composer-algo"/>
								Manual
							</label>
							<label class="btn btn-xs btn-danger" id="xpath-composer-clear">
								<input type="radio" name="xpath-composer-algo"/>
								Clear
							</label>
						</div>
					</p>
					<div class="row">
						<div class="col-lg-10">
							<div class="form-group">
								<input type="text" class="form-control" placeholder="Element XPath" id="xpath-composer-result"/>
							</div>
						</div>
						<div class="col-lg-2">
							<button type="button" class="btn btn-block btn-primary" id="xpath-composer-ok" data-dismiss="modal">
								<i class="fa fa-check"></i>
								Ok
							</button>
						</div>
					</div>
					<div data-status="process" class="xpath-composer-validation text-progress" style="display:none;">Validating...</div>
					<div data-status="ok" class="xpath-composer-validation text-success" style="display:none;">A single element found.</div>
					<div data-status="fail-count" class="xpath-composer-validation text-failure" style="display:none;"><span class="xpath-composer-validation-count"></span> elements found.</div>
					<div data-status="fail-none" class="xpath-composer-validation text-failure" style="display:none;">No elements found.</div>
					<div data-status="fail-other" class="xpath-composer-validation text-failure" style="display:none;">Validation error: <span class="xpath-composer-validation-error"></span></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<i class="fa fa-undo"></i>
						Cancel
					</button>
				</div>
			</div>
		</div>
	</div>
	<div style="display: none;">
		<div id="xpath-composer-pred-template">
			<div class="checkbox">
				<label>
					<input type="checkbox" class="xpath-composer-pred-control"/>
					<span class="xpath-composer-pred-text"></span>
				</label>
			</div>
		</div>
		<div id="xpath-composer-tag-template">
			<div class="panel panel-default">
				<div class="panel-heading xpath-composer-tag-toggle">
					<h4 class="panel-title xpath-composer-tag-toggle">
						<span class="space-x">
							<input type="checkbox" class="xpath-composer-tag-control"/>
						</span>
						<span class="xpath-composer-tag-title"></span>
					</h4>
				</div>
				<div class="panel-collapse collapse xpath-composer-tag-collapsed">
					<div class="panel-body xpath-composer-tag-text"></div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
