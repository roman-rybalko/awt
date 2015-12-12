<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="schedule">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="schedule" mode="menu">
	<link href="css/dataTables.bootstrap.css" rel="stylesheet"/>
	<script src="js/jquery.dataTables.min.js"></script>
	<script src="js/dataTables.bootstrap.min.js"></script>
	<link rel="stylesheet" href="css/bootstrap-datetimepicker.min.css"/>
	<script type="text/javascript" src="js/bootstrap-datetimepicker.min.js"></script>
	<xsl:call-template name="js_task_types"/>
	<script type="text/javascript">
		sched_tests = [  // global
			<xsl:for-each select="test">
				{name: "<xsl:value-of select="@name"/>", id: "<xsl:value-of select="@id"/>"},
			</xsl:for-each>
		];
	</script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Schedule</h1>
				<xsl:apply-templates select="//message"/>
				<xsl:if test="not(task)">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="schedule-create-test">&#215;</button>
						<b>Tip:</b>
						Create a <a href="../?tests=1">test</a> to make schedule available.
					</div>
				</xsl:if>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="schedule-set-email">&#215;</button>
					<b>Tip:</b>
					Set E-Mail in <a href="../?settings=1">Settings</a> to receive regular Task Reports.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable"
							data-order='[[4, "asc"]]'>
							<xsl:if test="count(task) &lt;= 10">
								<xsl:attribute name="data-paging">false</xsl:attribute>
							</xsl:if>
							<thead>
								<tr>
									<th>#</th>
									<th>Name</th>
									<th>Test</th>
									<th>Type</th>
									<th>Start time</th>
									<th>Execution period</th>
									<th data-orderable="false"></th>
									<th data-orderable="false"></th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="task">
									<tr>
										<td>
											#<xsl:value-of select="@id"/>
										</td>
										<td>
											<xsl:value-of select="@name"/>
										</td>
										<td>
											<a href="../?test={@test_id}" class="test-id2name">
												<xsl:value-of select="@test_id"/>
											</a>
										</td>
										<td class="task-type">
											<xsl:value-of select="@type"/>
										</td>
										<td class="time-unix2human">
											<xsl:value-of select="@start"/>
										</td>
										<td class="period-unix2human">
											<xsl:value-of select="@period"/>
										</td>
										<td>
											<button type="button" class="btn btn-xs btn-primary"
												data-toggle="modal" data-target="#modal-task-modify-{@id}">
												<i class="fa fa-pencil"></i>
												Modify
											</button>
										</td>
										<td>
											<button type="button" class="btn btn-xs btn-danger"
												data-toggle="modal" data-target="#modal-task-delete-{@id}">
												<i class="glyphicon glyphicon-trash"></i>
												Delete
											</button>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
						<xsl:for-each select="task">
							<div class="modal" id="modal-task-modify-{@id}" role="dialog">
								<div class="modal-dialog modal-lg">
									<div class="panel panel-primary">
										<div class="panel-heading">
											<button type="button" class="close" data-dismiss="modal">&#215;</button>
											Modify:
											<xsl:value-of select="@name"/>
										</div>
										<div class="panel-body">
											<form role="form" method="post" class="form-schedule-task">
												<input type="hidden" name="id" value="{@id}"/>
												<div class="row">
													<div class="col-lg-2">
														<div class="form-group">
															<label>Name</label>
															<input class="form-control" placeholder="Name" name="name"
																type="text" value="{@name}"/>
														</div>
													</div>
													<div class="col-lg-2">
														<div class="form-group">
															<label>Test</label>
															<select class="form-control" name="test_id">
																<xsl:call-template name="opts_task_tests">
																	<xsl:with-param name="value" select="@test_id"/>
																</xsl:call-template>
															</select>
														</div>
													</div>
													<div class="col-lg-2">
														<div class="form-group">
															<label>Type</label>
															<select class="form-control" name="type">
																<xsl:call-template name="opts_task_types">
																	<xsl:with-param name="value" select="@type"/>
																</xsl:call-template>
															</select>
														</div>
													</div>
													<div class="col-lg-4">
														<div class="form-group">
															<label>Start time</label>
															<div class="input-group date">
																<input class="form-control" placeholder="Start time"
																	name="start" type="text" value="{@start}"/>
																<span class="input-group-addon">
																	<span class="glyphicon glyphicon-time"></span>
																</span>
															</div>
														</div>
													</div>
													<div class="col-lg-2">
														<div class="form-group">
															<label>Execution period</label>
															<select class="form-control" name="period">
																<xsl:call-template name="opts_periods">
																	<xsl:with-param name="value" select="@period"/>
																</xsl:call-template>
															</select>
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-lg-12">
														<button type="submit" name="modify"
															class="btn btn-block btn-primary">
															<i class="fa fa-pencil"></i>
															Modify
														</button>
													</div>
												</div>
											</form>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default"
												data-dismiss="modal">
												<i class="fa fa-undo"></i>
												Cancel
											</button>
										</div>
									</div>
								</div>
							</div>
							<div class="modal" id="modal-task-delete-{@id}" role="dialog">
								<div class="modal-dialog modal-sm">
									<div class="panel panel-danger">
										<div class="panel-heading">
											<button type="button" class="close" data-dismiss="modal">&#215;</button>
											Delete:
											<xsl:value-of select="@name"/>
										</div>
										<div class="panel-body">
											<p>
												<b>
													Delete ?
												</b>
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
											<button type="button" class="btn btn-default"
												data-dismiss="modal">
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
		<xsl:if test="test">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-success">
						<div class="panel-body">
							<form role="form" method="post" class="form-schedule-task">
								<div class="row">
									<div class="col-lg-2">
										<div class="form-group">
											<label>Name</label>
											<input class="form-control" placeholder="Name" name="name" type="text" autofocus="1"/>
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Test</label>
											<select class="form-control" name="test_id">
												<xsl:call-template name="opts_task_tests"/>
											</select>
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Type</label>
											<select class="form-control" name="type">
												<xsl:call-template name="opts_task_types"/>
											</select>
										</div>
									</div>
									<div class="col-lg-4">
										<div class="form-group">
											<label>Start time</label>
											<div class="input-group date">
												<input class="form-control" placeholder="Start time" name="start" type="text"/>
												<span class="input-group-addon">
													<span class="glyphicon glyphicon-time"></span>
												</span>
											</div>
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Execution period</label>
											<select class="form-control" name="period">
												<xsl:call-template name="opts_periods"/>
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

<xsl:template name="opts_task_types">
	<xsl:param name="value"></xsl:param>
	<xsl:for-each select="//task_types/type[not(@name = preceding::type/@name)]">
		<option value="{@name}" class="task-type">
			<xsl:if test="@name = $value">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:value-of select="@name"/>
		</option>
	</xsl:for-each>
</xsl:template>

<xsl:template name="opts_task_tests">
	<xsl:param name="value"></xsl:param>
	<xsl:for-each select="//schedule/test">
		<option value="{@id}">
			<xsl:if test="@id = $value">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:value-of select="@name"/>
		</option>
	</xsl:for-each>
</xsl:template>

<xsl:template name="opts_periods">
	<xsl:param name="value">86400</xsl:param>
	<option value="60">
		<xsl:if test="$value = 60">
			<xsl:attribute name="selected"/>
		</xsl:if>
		1 minute
	</option>
	<option value="600">
		<xsl:if test="$value = 600">
			<xsl:attribute name="selected"/>
		</xsl:if>
		10 minutes
	</option>
	<option value="1200">
		<xsl:if test="$value = 1200">
			<xsl:attribute name="selected"/>
		</xsl:if>
		20 minutes
	</option>
	<option value="1800">
		<xsl:if test="$value = 1800">
			<xsl:attribute name="selected"/>
		</xsl:if>
		30 minutes
	</option>
	<option value="3600">
		<xsl:if test="$value = 3600">
			<xsl:attribute name="selected"/>
		</xsl:if>
		1 hour
	</option>
	<option value="7200">
		<xsl:if test="$value = 7200">
			<xsl:attribute name="selected"/>
		</xsl:if>
		2 hours
	</option>
	<option value="14400">
		<xsl:if test="$value = 14400">
			<xsl:attribute name="selected"/>
		</xsl:if>
		4 hours
	</option>
	<option value="43200">
		<xsl:if test="$value = 43200">
			<xsl:attribute name="selected"/>
		</xsl:if>
		12 hours
	</option>
	<option value="86400">
		<xsl:if test="$value = 86400">
			<xsl:attribute name="selected"/>
		</xsl:if>
		1 day
	</option>
	<option value="172800">
		<xsl:if test="$value = 172800">
			<xsl:attribute name="selected"/>
		</xsl:if>
		2 days
	</option>
	<option value="259200">
		<xsl:if test="$value = 259200">
			<xsl:attribute name="selected"/>
		</xsl:if>
		3 days
	</option>
	<option value="604800">
		<xsl:if test="$value = 604800">
			<xsl:attribute name="selected"/>
		</xsl:if>
		1 week
	</option>
</xsl:template>

</xsl:stylesheet>
