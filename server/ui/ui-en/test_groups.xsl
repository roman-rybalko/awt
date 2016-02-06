<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="test_groups">
	<xsl:choose>
		<xsl:when test="//message[@value='test_group_add_ok']">
			<xsl:call-template name="redirect">
				<xsl:with-param name="url">?test_group=<xsl:value-of select="//message[@value='test_group_add_ok']/@id"/></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="menu"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="test_groups" mode="menu">
	<script src="ui-en/js/jquery.dataTables.min.js" type="text/javascript"></script>
	<link href="ui-en/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
	<script src="ui-en/js/dataTables.responsive.min.js" type="text/javascript"></script>
	<link href="ui-en/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/responsive.bootstrap.min.js" type="text/javascript"></script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Test Groups</h1>
				<xsl:apply-templates select="//message"/>
			</div>
		</div>
		<xsl:if test="test_group[not(@deleted)]">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[1, "desc"]]'>
								<xsl:if test="count(test_group[not(@deleted)]) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>#</th>
										<th>Time</th>
										<th>Name</th>
										<th data-orderable="false"></th>
										<th data-orderable="false"></th>
										<th data-orderable="false"></th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="test_group[not(@deleted)]">
										<tr>
											<td>
												#<xsl:value-of select="@id"/>
											</td>
											<td class="time-unix2human">
												<xsl:value-of select="@time"/>
											</td>
											<td>
												<a href="./?test_group={@id}">
													<xsl:value-of select="@name"/>
												</a>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-primary" data-toggle="modal" data-target="#modal-test_group-rename-{@id}">
													<i class="fa fa-pencil"></i>
													Rename
												</button>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-primary" data-toggle="modal" data-target="#modal-test_group-copy-{@id}">
													<i class="fa fa-copy"></i>
													Copy
												</button>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-danger" data-toggle="modal" data-target="#modal-test_group-delete-{@id}">
													<i class="glyphicon glyphicon-trash"></i>
													Delete
												</button>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-test_group-run-{@id}">
													<i class="fa fa-play"></i>
													Run
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<xsl:for-each select="test_group">
								<div class="modal" id="modal-test_group-rename-{@id}" role="dialog">
									<div class="modal-dialog modal-sm">
										<div class="panel panel-primary">
											<div class="panel-heading">
												<button type="button" class="close" data-dismiss="modal">&#215;</button>
												Rename: <xsl:value-of select="@name"/>
											</div>
											<div class="panel-body">
												<form role="form" method="post">
													<input type="hidden" name="id" value="{@id}"/>
													<div class="form-group">
														<input class="form-control" placeholder="New Name" name="name" type="text" value="{@name}"/>
													</div>
													<button type="submit" name="rename" class="btn btn-block btn-primary">
														<i class="fa fa-pencil"></i>
														Rename
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
								<div class="modal" id="modal-test_group-copy-{@id}" role="dialog">
									<div class="modal-dialog modal-sm">
										<div class="panel panel-primary">
											<div class="panel-heading">
												<button type="button" class="close" data-dismiss="modal">&#215;</button>
												Copy: <xsl:value-of select="@name"/>
											</div>
											<div class="panel-body">
												<form role="form" method="post">
													<input type="hidden" name="id" value="{@id}"/>
													<div class="form-group">
														<input class="form-control" placeholder="New Name" name="name" type="text"/>
													</div>
													<button type="submit" name="copy" class="btn btn-block btn-primary">
														<i class="fa fa-copy"></i>
														Copy
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
								<div class="modal" id="modal-test_group-delete-{@id}" role="dialog">
									<div class="modal-dialog modal-sm">
										<div class="panel panel-danger">
											<div class="panel-heading">
												<button type="button" class="close" data-dismiss="modal">&#215;</button>
												Delete: <xsl:value-of select="@name"/>
											</div>
											<div class="panel-body">
												<p>
													Delete <b><xsl:value-of select="@name"/></b> ?
												</p>
												<form role="form" method="post">
													<input type="hidden" name="id" value="{@id}"/>
													<button type="submit" name="delete" class="btn btn-block btn-danger">
														<i class="glyphicon glyphicon-trash"></i>
														Delete
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
								<div class="modal" id="modal-test_group-run-{@id}" role="dialog">
									<div class="modal-dialog modal-sm">
										<div class="panel panel-success">
											<div class="panel-heading">
												<button type="button" class="close" data-dismiss="modal">&#215;</button>
												Run: <xsl:value-of select="@name"/>
											</div>
											<div class="panel-body">
												<p>
													Run <b><xsl:value-of select="@name"/></b> ?
												</p>
												<form role="form" method="post" action="./?tasks=1" class="apply-data-display-period">
													<input type="hidden" name="test_group_id" value="{@id}"/>
													<button type="submit" name="add" class="btn btn-block btn-success">
														<i class="fa fa-play fa-fw"></i>
														Run
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
							</xsl:for-each>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-success">
					<div class="panel-body">
						<form role="form" method="post" class="form-inline">
							<xsl:attribute name="onsubmit">
								/* <![CDATA[ */
								if (! $(this).find('input[name="name"]').val().match(/\S/)) {
									$(this).find('input[name="name"]').focus();
									return false;
								}
								/* ]]> */
							</xsl:attribute>
							<div class="form-group space-x">
								<input class="form-control" placeholder="Name" name="name" type="text"/>
							</div>
							<button type="submit" name="add" class="btn btn-success">
								<i class="fa fa-plus"></i>
								New
							</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		<xsl:if test="test_group[@deleted]">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel-group" id="trash">
						<div class="panel panel-danger">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a data-toggle="collapse" data-parent="#trash" href="#trash-body">
										<i class="glyphicon glyphicon-trash"></i>
										Deleted
									</a>
								</h4>
							</div>
							<div id="trash-body" class="panel-collapse collapse">
								<div class="panel-body">
									<table class="table table-striped table-hover table-dataTable" data-order='[[1, "desc"]]'>
										<xsl:if test="count(test_group[@deleted]) &lt;= 10">
											<xsl:attribute name="data-paging">false</xsl:attribute>
										</xsl:if>
										<thead>
											<tr>
												<th>#</th>
												<th>Time</th>
												<th>Name</th>
												<th data-orderable="false"></th>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="test_group[@deleted]">
												<tr>
													<td>
														#<xsl:value-of select="@id"/>
													</td>
													<td class="time-unix2human">
														<xsl:value-of select="@time"/>
													</td>
													<td>
														<a href="./?test_group={@id}">
															<xsl:value-of select="@name"/>
														</a>
													</td>
													<td>
														<form role="form" method="post" style="display: inline;">
															<input type="hidden" name="id" value="{@id}"/>
															<button type="submit" name="restore" class="btn btn-xs btn-success">
																<i class="fa fa-recycle"></i>
																Restore
															</button>
														</form>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="alert alert-info alert-dismissable">
				<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-purge-period">&#215;</button>
				<b>Tip:</b>
				Deleted Test Groups are purged after 42 days.
			</div>
		</xsl:if>
	</div>
</xsl:template>

</xsl:stylesheet>
