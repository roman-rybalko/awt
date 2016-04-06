<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="tasks">
	<xsl:choose>
		<xsl:when test="//message[@value='task_start_ok']">
			<xsl:call-template name="redirect"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="menu"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tasks" mode="menu">
	<script src="ui-en/js/jquery.dataTables.min.js" type="text/javascript"></script>
	<link href="ui-en/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
	<script src="ui-en/js/dataTables.responsive.min.js" type="text/javascript"></script>
	<link href="ui-en/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/responsive.bootstrap.min.js" type="text/javascript"></script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Tasks</h1>
				<xsl:apply-templates select="//message"/>
				<xsl:if test="not(task)">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="tasks-create-test1">&#215;</button>
						<b>Tip:</b>
						Create a <a href="./?tests=1">test</a> to run a task.
					</div>
				</xsl:if>
				<div class="apply-data-display-period">
					<xsl:if test="count(task) &gt; 500">
						<div class="alert alert-info alert-dismissable">
							<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-display-period">&#215;</button>
							<b>Tip:</b>
							Use <b>Data Display Period</b> option in <a href="./?settings=1">Settings</a> to reduce displayed data and speed up the UI.
						</div>
					</xsl:if>
				</div>
			</div>
		</div>
		<xsl:if test="task[@status = 'initial']">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-info">
						<div class="panel-heading">
							<i class="fa fa-spinner"></i>
							Pending
						</div>
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
								<xsl:if test="count(task[@status = 'initial']) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>Time</th>
										<th>Task</th>
										<th>Type</th>
										<th>Debug</th>
										<th>Test</th>
										<th data-orderable="false"></th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="task[@status = 'initial']">
										<tr>
											<td class="time-unix2human">
												<xsl:value-of select="@time"/>
											</td>
											<td>
												<a href="./?task={@id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td class="task-type">
												<xsl:value-of select="@type"/>
											</td>
											<td>
												<xsl:if test="@debug">
													<i class="fa fa-check-square"></i>
												</xsl:if>
											</td>
											<td>
												<a href="./?test={@test_id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td>
												<form role="form" method="post" style="display: inline;">
													<input type="hidden" name="task_id" value="{@id}"/>
													<button type="submit" name="cancel" class="btn btn-xs btn-danger">
														<i class="glyphicon glyphicon-trash"></i>
														Cancel
													</button>
												</form>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-task-restart-{@id}">
													<i class="fa fa-play"></i>
													Restart
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</div>
					</div>
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="tasks-pending">&#215;</button>
						<b>Tip:</b>
						Pending Tasks are processed every 5 seconds.
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="task[@status = 'starting' or @status = 'running']">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-warning">
						<div class="panel-heading">
							<i class="fa fa-play"></i>
							Running
						</div>
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
								<xsl:if test="count(task[@status = 'starting' or @status = 'running']) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>Time</th>
										<th>Task</th>
										<th>Type</th>
										<th>Debug</th>
										<th>Test</th>
										<th data-orderable="false"></th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="task[@status = 'starting' or @status = 'running']">
										<tr>
											<td class="time-unix2human">
												<xsl:value-of select="@time"/>
											</td>
											<td>
												<a href="./?task={@id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td class="task-type">
												<xsl:value-of select="@type"/>
											</td>
											<td>
												<xsl:if test="@debug">
													<i class="fa fa-check-square"></i>
												</xsl:if>
											</td>
											<td>
												<a href="./?test={@test_id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td>
												<form role="form" method="post" style="display: inline;">
													<input type="hidden" name="task_id" value="{@id}"/>
													<button type="submit" name="cancel" class="btn btn-xs btn-danger">
														<i class="glyphicon glyphicon-trash"></i>
														Cancel
													</button>
												</form>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-task-restart-{@id}">
													<i class="fa fa-play"></i>
													Restart
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</div>
					</div>
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="tasks-cancel">&#215;</button>
						<b>Tip:</b>
						Running Task may be cancelled after timeout (by default 10 seconds per action).
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="task[@status = 'succeeded' or @status = 'failed']">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-heading">
							<i class="fa fa-check-square-o"></i>
							Finished
						</div>
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
								<xsl:if test="count(task[@status = 'succeeded' or @status = 'failed']) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>Time</th>
										<th>Task</th>
										<th>Type</th>
										<th>Debug</th>
										<th>Status</th>
										<th>Test</th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="task[@status = 'succeeded' or @status = 'failed']">
										<tr>
											<xsl:if test="@status = 'succeeded'">
												<xsl:attribute name="class">success</xsl:attribute>
											</xsl:if>
											<xsl:if test="@status = 'failed'">
												<xsl:attribute name="class">danger</xsl:attribute>
											</xsl:if>
											<td class="time-unix2human">
												<xsl:value-of select="@time"/>
											</td>
											<td>
												<a href="./?task={@id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td>
												<xsl:value-of select="@type"/>
											</td>
											<td>
												<xsl:if test="@debug">
													<i class="fa fa-check-square"></i>
												</xsl:if>
											</td>
											<td>
												<xsl:if test="@status = 'succeeded'">
													<i class="fa fa-check text-success"></i>
													<span style="display: none;">1 (order data)</span>
												</xsl:if>
												<xsl:if test="@status = 'failed'">
													<i class="fa fa-times text-failure"></i>
													<span style="display: none;">2 (order data)</span>
												</xsl:if>
											</td>
											<td>
												<a href="./?test={@test_id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-task-restart-{@id}">
													<i class="fa fa-play"></i>
													Restart
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="task[@status = 'cancelled']">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<i class="fa fa-trash-o"></i>
							Cancelled
						</div>
						<div class="panel-body">
							<table class="table table-striped table-hover table-dataTable" data-order='[[0, "desc"]]'>
								<xsl:if test="count(task[@status = 'cancelled']) &lt;= 10">
									<xsl:attribute name="data-paging">false</xsl:attribute>
								</xsl:if>
								<thead>
									<tr>
										<th>Time</th>
										<th>Task</th>
										<th>Type</th>
										<th>Debug</th>
										<th>Test</th>
										<th data-orderable="false"></th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="task[@status = 'cancelled']">
										<tr>
											<td class="time-unix2human">
												<xsl:value-of select="@time"/>
											</td>
											<td>
												<a href="./?task={@id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td class="task-type">
												<xsl:value-of select="@type"/>
											</td>
											<td>
												<xsl:if test="@debug">
													<i class="fa fa-check-square"></i>
												</xsl:if>
											</td>
											<td>
												<a href="./?test={@test_id}">
													<xsl:value-of select="@test_name"/>
												</a>
											</td>
											<td>
												<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-task-restart-{@id}">
													<i class="fa fa-play"></i>
													Restart
												</button>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:for-each select="task">
			<xsl:call-template name="modal_new_task">
				<xsl:with-param name="modal_id">modal-task-restart-<xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="test_name"><xsl:value-of select="@test_name"/></xsl:with-param>
				<xsl:with-param name="test_id"><xsl:value-of select="@test_id"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:if test="task">
			<div class="row">
				<div class="col-lg-12">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-purge-period">&#215;</button>
						<b>Tip:</b>
						Tasks are purged after 42 days.
					</div>
				</div>
			</div>
		</xsl:if>
	</div>
</xsl:template>

</xsl:stylesheet>
