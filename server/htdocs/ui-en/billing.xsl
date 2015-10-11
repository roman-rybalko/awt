<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="billing">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="billing" mode="menu">
	<link href="css/dataTables.bootstrap.css" rel="stylesheet"/>
	<script src="js/jquery.dataTables.min.js"></script>
	<script src="js/dataTables.bootstrap.min.js"></script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Billing</h1>
				<xsl:if test="//message">
					<div class="row">
						<div class="col-lg-12">
							<xsl:apply-templates select="//message"/>
						</div>
					</div>
				</xsl:if>
				<xsl:call-template name="helper_tip">
					<xsl:with-param name="state">
						billing-email
					</xsl:with-param>
					<xsl:with-param name="text">
						Please, set up E-Mail in Settings to receive Billing notifications.
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-3">
				<div class="panel panel-red">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3">
								<i class="fa fa-money fa-5x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<div class="huge">
									<xsl:value-of select="@actions_available"/>
								</div>
								<div>Available Actions</div>
							</div>
						</div>
					</div>
					<a href="#" data-toggle="modal" data-target="#modal-top-up">
						<div class="panel-footer">
							<span class="pull-left">Top Up</span>
							<span class="pull-right">
								<i class="fa fa-arrow-circle-right"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
				<div class="panel panel-info">
					<div class="panel-body">
						<a href="" data-toggle="modal" data-target="#modal-service">
							Service
						</a>
					</div>
				</div>
			</div>
			<div class="col-lg-9">
				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="fa fa-credit-card"></i>
						Transactions
					</div>
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable" data-order='[[1, "desc"]]'>
							<xsl:if test="count(transaction) &lt;= 10">
								<xsl:attribute name="data-paging">false</xsl:attribute>
							</xsl:if>
							<thead>
								<tr>
									<th>#</th>
									<th>Time</th>
									<th>Transaction</th>
									<th>Before</th>
									<th>Charge/Credit</th>
									<th>After</th>
									<th data-orderable="false">Data</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="transaction">
									<tr>
										<xsl:attribute name="class">
											<xsl:apply-templates select="." mode="severity"/>
										</xsl:attribute>
										<td>
											#<xsl:value-of select="@id"/>
										</td>
										<td class="time-unix2human">
											<xsl:value-of select="@time"/>
										</td>
										<td>
											<xsl:apply-templates select="." mode="title"/>
										</td>
										<td>
											<xsl:value-of select="@actions_before"/>
										</td>
										<td>
											<xsl:value-of select="@actions"/>
										</td>
										<td>
											<xsl:value-of select="@actions_after"/>
										</td>
										<td>
											<xsl:apply-templates select="." mode="data"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<xsl:call-template name="helper_tip">
					<xsl:with-param name="state">
						billing-clear
					</xsl:with-param>
					<xsl:with-param name="text">
						Transaction data is cleared after 2 years.
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>
	</div>
	<div class="modal" id="modal-top-up" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					Top Up
				</div>
				<div class="panel-body">
					<form role="form" method="post" class="form-inline">
						<div class="form-group space-x">
							<input type="text" class="form-control" name="actions"
								placeholder="Actions Count"/>
						</div>
						<div class="form-group space-x">
							<input type="text" class="form-control" name="amount"
								placeholder="Amount"/>
						</div>
						<div class="form-group">
							<button type="submit" name="top_up" class="btn btn-block btn-danger">
								<i class="fa fa-credit-card"></i>
								Top Up
							</button>
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
	<div class="modal" id="modal-service" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="panel panel-info">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					Service
				</div>
				<div class="panel-body">
					<form role="form" method="post" class="form-inline">
						<div class="form-group space-x">
							<input type="text" class="form-control" name="actions" placeholder="Actions Count"/>
						</div>
						<div class="form-group space-x">
							<input type="text" class="form-control" name="data" placeholder="Data"/>
						</div>
						<div class="form-group">
							<button type="submit" name="service" class="btn btn-block btn-danger">
								<i class="fa fa-credit-card"></i>
								Charge
							</button>
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
</xsl:template>

</xsl:stylesheet>
