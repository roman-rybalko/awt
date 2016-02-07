<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="test_group">
	<xsl:choose>
		<xsl:when test="//message[@value='tg_test_add_ok']">
			<xsl:call-template name="redirect"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="menu"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="test_group" mode="menu">
	<script src="ui-en/js/jquery.dataTables.min.js" type="text/javascript"></script>
	<link href="ui-en/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
	<script src="ui-en/js/dataTables.responsive.min.js" type="text/javascript"></script>
	<link href="ui-en/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/responsive.bootstrap.min.js" type="text/javascript"></script>
	<xsl:call-template name="js_task_types"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Test Group</h1>
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
							<xsl:if test="@deleted">
								<div class="col-lg-3">
									<b class="text-failure">Deleted</b>
								</div>
								<div class="col-lg-3">
									<form role="form" method="post" action="./?test_groups=1">
										<input type="hidden" name="id" value="{@id}"/>
										<button type="submit" name="restore" class="btn btn-xs btn-block btn-success">
											<i class="fa fa-recycle"></i>
											Restore
										</button>
									</form>
								</div>
							</xsl:if>
							<xsl:if test="not(@deleted)">
								<div class="col-lg-3">
									<button type="button" class="btn btn-xs btn-block btn-success" data-toggle="modal" data-target="#modal-test_group-run">
										<i class="fa fa-play"></i>
										Run
									</button>
								</div>
								<div class="modal" id="modal-test_group-run" role="dialog">
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
													<button type="submit" name="start" class="btn btn-block btn-success">
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
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
		<xsl:if test="tg_test">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
								<xsl:if test="count(tg_test) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>Test</th>
										<th>Type</th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="tg_test">
										<tr>
											<td>
												<a href="./?test={@test_id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td class="task-type">
												<xsl:value-of select="@task_type"/>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-danger" data-toggle="modal" data-target="#modal-tg_test-delete-{@id}">
													<i class="glyphicon glyphicon-trash"></i>
													Delete
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<xsl:for-each select="tg_test">
								<div class="modal" id="modal-tg_test-delete-{@id}" role="dialog">
									<div class="modal-dialog modal-sm">
										<div class="panel panel-danger">
											<div class="panel-heading">
												<button type="button" class="close" data-dismiss="modal">&#215;</button>
												Delete: <xsl:value-of select="@test_name"/>
											</div>
											<div class="panel-body">
												<p>
													Delete <b><xsl:value-of select="@test_name"/></b> ?
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
							</xsl:for-each>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="not(@deleted)">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<form role="form" method="post">
								<div class="row">
									<div class="col-lg-6">
										<div class="form-group">
											<label>Test</label>
											<select class="form-control" name="test_id">
												<xsl:for-each select="//test_group/test">
													<option value="{@id}">
														<xsl:value-of select="@name"/>
													</option>
												</xsl:for-each>
											</select>
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Type</label>
											<select class="form-control" name="task_type">
												<xsl:for-each select="//task_types/type[not(@name = preceding::type/@name)]">
													<option value="{@name}" class="task-type">
														<xsl:value-of select="@name"/>
													</option>
												</xsl:for-each>
											</select>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-lg-12">
										<button type="submit" name="add" class="btn btn-block btn-success">
											<i class="fa fa-plus"></i>
											New
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

</xsl:stylesheet>
