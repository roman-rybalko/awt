<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="test">
	<xsl:call-template name="menu" />
</xsl:template>

<xsl:template match="test" mode="menu">
    <xsl:call-template name="js_task_types"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Test</h1>
			</div>
		</div>
		<xsl:if test="//message">
			<div class="row">
				<div class="col-lg-12">
					<xsl:apply-templates select="//message" />
				</div>
			</div>
		</xsl:if>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-info">
					<div class="panel-body">
						<div class="row">
							<div class="col-lg-2">
								<b>Name</b>:
								<xsl:value-of select="@name" />
							</div>
							<div class="col-lg-3">
								<b>Time</b>:
								<xsl:value-of select="@time"/>
							</div>
							<xsl:if test="@deleted">
								<div class="col-lg-1">
									<b class="text-failure">Deleted</b>
								</div>
								<div class="col-lg-1">
									<form role="form" method="post" action="../?tests=1">
										<input type="hidden" name="test_id" value="{@id}"/>
										<button type="submit" name="undelete" class="btn btn-xs btn-success">
											<i class="fa fa-recycle"></i>
											Restore
										</button>
									</form>
								</div>
							</xsl:if>
							<xsl:if test="not(@deleted)">
								<div class="col-lg-1">
									<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-test-run">
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
		<xsl:for-each select="action">
			<xsl:sort select="@id" data-type="number" order="ascending"/>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-9">
									<div class="row">
										<xsl:apply-templates select="." mode="action_html" />
									</div>
								</div>
								<xsl:if test="not(../@deleted)">
									<div class="col-lg-3">
										<button type="button" class="btn btn-xs btn-primary space-x space-y" data-toggle="modal" data-target="#modal-action-modify-{@id}">
											<i class="fa fa-edit"></i>
											Modify
										</button>
										<div class="modal" id="modal-action-modify-{@id}" role="dialog">
											<div class="modal-dialog modal-lg">
												<div class="panel panel-primary">
													<div class="panel-heading">
														<button type="button" class="close" data-dismiss="modal">&#215;</button>
														Modify: <xsl:value-of select="@name" />
													</div>
													<div class="panel-body">
														<form role="form" method="post">
															<input type="hidden" name="action_id" value="{@id}" />
															<div class="row">
																<xsl:apply-templates select="." mode="action_form">
																	<xsl:with-param name="id">modify-<xsl:value-of select="@id"/></xsl:with-param>
																</xsl:apply-templates>
															</div>
															<button type="submit" name="modify" class="btn btn-block btn-primary">
																<i class="fa fa-pencil"></i>
																Modify
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
										<button type="button" class="btn btn-xs btn-success space-x space-y" data-toggle="modal" data-target="#modal-action-insert-{@id}">
											<i class="fa fa-expand"></i>
											Insert
										</button>
										<div class="modal" id="modal-action-insert-{@id}" role="dialog">
											<div class="modal-dialog modal-lg">
												<div class="panel panel-success">
													<div class="panel-heading">
														<button type="button" class="close" data-dismiss="modal">&#215;</button>
														Insert
													</div>
													<div class="panel-body">
														<form role="form" method="post" id="action-form-{@id}">
															<input type="hidden" name="action_id" value="{@id}" />
															<xsl:call-template name="new_action_form">
																<xsl:with-param name="id">insert-<xsl:value-of select="@id"/></xsl:with-param>
															</xsl:call-template>
															<div class="row">
																<div class="col-lg-12">
																	<button type="submit" name="insert" class="btn btn-block btn-success">
																		<i class="fa fa-expand"></i>
																		Insert
																	</button>
																</div>
															</div>
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
										<button type="button" class="btn btn-xs btn-danger space-x space-y" data-toggle="modal" data-target="#modal-action-delete-{@id}">
											<i class="glyphicon glyphicon-trash"></i>
											Delete
										</button>
										<div class="modal" id="modal-action-delete-{@id}" role="dialog">
											<div class="modal-dialog">
												<div class="panel panel-danger">
													<div class="panel-heading">
														<button type="button" class="close" data-dismiss="modal">&#215;</button>
														Delete
													</div>
													<div class="panel-body">
														<div class="row">
															<xsl:apply-templates select="." mode="action_html" />
														</div>
														<div class="row">
															<div class="col-lg-12">
																<form method="post">
																	<input type="hidden" name="action_id" value="{@id}" />
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
									</div>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:for-each>
		<xsl:if test="not(@deleted)">
			<div class="row" id="action-add">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<form role="form" method="post" id="action-form">
								<xsl:call-template name="new_action_form">
									<xsl:with-param name="id">add</xsl:with-param>
								</xsl:call-template>
								<div class="row">
									<div class="col-lg-3 col-lg-offset-9">
										<button type="submit" name="add" class="btn btn-xs btn-block btn-success">
											<i class="fa fa-plus"></i>
											Add
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template name="new_action_form">
	<xsl:param name="id" select="generate-id()"/>
	<div class="row">
		<div class="col-lg-12">
			<div class="form-group">
				<label for="action-type-{$id}">Type</label>
				<select class="form-control" name="type" id="action-type-{$id}" data-action-type-id="{$id}">
					<xsl:for-each select="document('actions.xml')//action">
						<option value="{@type}">
							<xsl:value-of select="@type"/>
						</option>
					</xsl:for-each>
				</select>
			</div>
		</div>
	</div>
	<xsl:for-each select="document('actions.xml')//action">
		<div class="row" data-action-type="{@type}" data-action-id="{$id}">
			<div class="col-lg-12">
				<div class="row">
					<xsl:apply-templates select="." mode="action_form">
						<xsl:with-param name="id" select="$id"/>
					</xsl:apply-templates>
				</div>
			</div>
		</div>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
