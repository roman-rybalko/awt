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
				<xsl:apply-templates select="//message"/>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="billing-email">&#215;</button>
					<b>Tip:</b>
					Please, check your E-Mail in <a href="../?settings=1">Settings</a>.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-4">
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="../?billing_archive=1">
							<i class="fa fa-archive"></i>
							Billing Archive
						</a>
						<br/>
						<a href="mailto:billing@advancedwebtesting.com?subject=Billing%20Support%20Request:&amp;body=Login:%20{../@login}%0aTransaction ID:%0a%20Pending Transaction ID:%0a%20Subscription ID:%0a%20">
							<i class="fa fa-support"></i>
							Billing Support
						</a>
					</div>
				</div>
				<div class="form-group">
					<a href="#" class="btn btn-block btn-danger" data-toggle="modal" data-target="#modal-top_up">
						<i class="glyphicon glyphicon-credit-card"></i>
						Top Up
					</a>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="fa fa-tags"></i>
						Pricing
					</div>
					<div class="panel-body">
						1 Test Action = 1 RUB
					</div>
				</div>
			</div>
			<div class="col-lg-4">
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
					<a href="#" data-toggle="modal" data-target="#modal-top_up">
						<div class="panel-footer">
							<span class="pull-left">
								Top Up
							</span>
							<span class="pull-right">
								<i class="glyphicon glyphicon-credit-card"></i>
							</span>
							<div class="clearfix"></div>
						</div>
					</a>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-success">
					<div class="panel-heading">
						<i class="fa fa-star"></i>
						Subscriptions
					</div>
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable" data-order='[[2, "desc"]]' data-paging="false">
							<thead>
								<tr>
									<th>Type</th>
									<th>ID</th>
									<th>Time</th>
									<th>Actions</th>
									<th>Amount</th>
									<th data-orderable="false">Data</th>
									<th data-orderable="false"></th>
									<th data-orderable="false"></th>
									<th data-orderable="false"></th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="subscription">
									<tr>
										<td>
											<xsl:call-template name="billing_payment_type"/>
										</td>
										<td>
											#<xsl:value-of select="@id"/>
										</td>
										<td class="time-unix2human">
											<xsl:value-of select="@time"/>
										</td>
										<td>
											<xsl:value-of select="@actions_cnt"/>
										</td>
										<td>
											<xsl:value-of select="@payment_amount"/>
										</td>
										<td>
											<xsl:value-of select="@payment_data"/>
										</td>
										<td>
											<a href="#" data-toggle="modal" data-target="#modal-subscription-modify-{@payment_type}-{@id}" class="btn btn-xs btn-block btn-primary">
												<i class="fa fa-edit"></i>
												Modify
											</a>
										</td>
										<td>
											<a href="#" data-toggle="modal" data-target="#modal-subscription-top_up-{@payment_type}-{@id}" class="btn btn-xs btn-block btn-success">
												<i class="glyphicon glyphicon-credit-card"></i>
												Top Up
											</a>
										</td>
										<td>
											<a href="#" data-toggle="modal" data-target="#modal-subscription-cancel-{@payment_type}-{@id}" class="btn btn-xs btn-block btn-danger">
												<i class="glyphicon glyphicon-trash"></i>
												Cancel
											</a>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="billing-subscription-order">&#215;</button>
					<b>Tip:</b>
					Firstly is processed the subscription with higher amount.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-warning">
					<div class="panel-heading">
						<i class="fa fa-spinner"></i>
						Pending Transactions
					</div>
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable" data-order='[[2, "desc"]]' data-paging="false">
							<thead>
								<tr>
									<th>Type</th>
									<th>ID</th>
									<th>Time</th>
									<th>Transaction</th>
									<th>Actions</th>
									<th>Amount</th>
									<th data-orderable="false">Data</th>
									<th data-orderable="false"></th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="pending_transaction">
									<tr>
										<td>
											<xsl:call-template name="billing_payment_type"/>
										</td>
										<td>
											#<xsl:value-of select="@id"/>
										</td>
										<td class="time-unix2human">
											<xsl:value-of select="@time"/>
										</td>
										<td>
											<a href="../?billing_archive=1#{@transaction_id}">
												#<xsl:value-of select="@transaction_id"/>
											</a>
										</td>
										<td>
											<a href="{@url}">
												<xsl:value-of select="@actions_cnt"/>
											</a>
										</td>
										<td>
											<a href="{@url}">
												<xsl:value-of select="@payment_amount"/>
											</a>
										</td>
										<td>
											<a href="{@url}">
												<xsl:value-of select="@payment_data"/>
											</a>
										</td>
										<td>
											<form method="post">
												<input type="hidden" name="payment_type" value="{@payment_type}"/>
												<input type="hidden" name="id" value="{@id}"/>
												<button type="submit" name="cancel_pending_transaction" class="btn btn-xs btn-block btn-danger">
													<i class="glyphicon glyphicon-trash"></i>
													Cancel
												</button>
											</form>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="billing-pending-transactions-process">&#215;</button>
					<b>Tip:</b>
					Pending Transactions are processed every minute.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<xsl:if test="count(transaction) &gt; 500">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="data-display-period">&#215;</button>
						<b>Tip:</b>
						Use <b>Data Display Period</b> option in <a href="../?settings=1">Settings</a> to reduce displayed data and speed up the UI.
					</div>
				</xsl:if>
				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="fa fa-credit-card"></i>
						Transactions
						<span class="apply-data-display-period"></span>
					</div>
					<div class="panel-body">
						<table class="table table-striped table-hover table-dataTable" data-order='[[1, "desc"]]'>
							<xsl:if test="count(transaction) &lt;= 10">
								<xsl:attribute name="data-paging">false</xsl:attribute>
							</xsl:if>
							<thead>
								<tr>
									<th>ID</th>
									<th>Time</th>
									<th>Transaction</th>
									<th>Before</th>
									<th>Credit/Charge</th>
									<th>After</th>
									<th data-orderable="false">Data</th>
									<th data-orderable="false">Refund</th>
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
											<xsl:value-of select="@actions_cnt"/>
										</td>
										<td>
											<xsl:value-of select="@actions_after"/>
										</td>
										<td>
											<xsl:apply-templates select="." mode="data"/>
										</td>
										<td>
											<xsl:if test="@refundable">
												<a href="#" data-toggle="modal" data-target="#modal-transaction-refund-{@id}" class="btn btn-xs btn-block btn-danger">
													<i class="fa fa-reply"></i>
													Refund
												</a>
											</xsl:if>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="billing-transactions">&#215;</button>
					<b>Tip:</b>
					Transactions are displayed for 42 days only. See <a href="../?billing_archive=1">Billing Archive</a> for the full list.
				</div>
			</div>
		</div>
	</div>
	<div class="modal" id="modal-top_up" role="dialog">
		<div class="modal-dialog modal-md">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					Top Up
				</div>
				<div class="panel-body">
					<form role="form" method="post">
						<div class="form-group">
							<table style="width:100%;">
								<tr>
									<td style="text-align:center;">
										<input type="radio" id="modal-top_up-payment_type-paypal" name="payment_type" value="2" checked=""/>
									</td>
									<td style="text-align:center;">
										<label for="modal-top_up-payment_type-paypal">
											<img src="https://www.paypalobjects.com/webstatic/mktg/logo/AM_mc_vs_dc_ae.jpg" border="0" alt="PayPal Acceptance Mark"/>
										</label>
									</td>
								</tr>
								<tr>
									<td style="text-align:center;">
										<input type="radio" id="modal-top_up-payment_type-assist" name="payment_type" value="3"/>
									</td>
									<td style="text-align:center;">
										<label for="modal-top_up-payment_type-assist">
											<img src="assist/assist.png" alt="ASSIST Electronic Payment System" style="height:50px;"/>
											<img src="assist/logos.png" style="height:50px;"/>
										</label>
									</td>
								</tr>
							</table>
						</div>
						<div class="form-group">
							<label for="modal-top_up-actions_cnt">Actions Count:</label>
							<input type="number" id="modal-top_up-actions_cnt" class="form-control" name="actions_cnt" placeholder="Actions Cnt" value="200"/>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" name="subscription" value="1" checked=""/>
								Subscription (auto Top Up when the account balance gets low)
							</label>
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
	<xsl:for-each select="subscription">
		<div class="modal" id="modal-subscription-modify-{@payment_type}-{@id}" role="dialog">
			<div class="modal-dialog modal-sm">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<button type="button" class="close" data-dismiss="modal">&#215;</button>
						Modify Subscription
						<xsl:call-template name="billing_payment_type"/>
						#<xsl:value-of select="@id"/>
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<input type="hidden" name="payment_type" value="{@payment_type}"/>
							<input type="hidden" name="id" value="{@id}"/>
							<div class="form-group">
								<label for="modal-subscription-modify-{@payment_type}-{@id}-actions_cnt">Actions Count:</label>
								<input type="number" id="modal-subscription-modify-{@payment_type}-{@id}-actions_cnt" class="form-control" name="actions_cnt"
									placeholder="New Actions Count" value="{@actions_cnt}"/>
							</div>
							<div class="form-group">
								<button type="submit" name="modify_subscription" class="btn btn-block btn-primary">
									<i class="fa fa-edit"></i>
									Modify
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
		<div class="modal" id="modal-subscription-top_up-{@payment_type}-{@id}" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="panel panel-success">
					<div class="panel-heading">
						<button type="button" class="close" data-dismiss="modal">&#215;</button>
						Top Up by Subscription
						<xsl:call-template name="billing_payment_type"/>
						#<xsl:value-of select="@id"/>
					</div>
					<div class="panel-body">
						<div class="container-fluid">
							<div class="row">
								<div class="col-lg-3">
									<b class="space-x">Actions Count:</b>
									<span class="space-x">
										<xsl:value-of select="@actions_cnt"/>
									</span>
								</div>
								<div class="col-lg-3">
									<b class="space-x">Payment Amount:</b>
									<span class="space-x">
										<xsl:value-of select="@payment_amount"/>
									</span>
								</div>
								<div class="col-lg-6">
									<b class="space-x">Payment Data:</b>
									<span class="space-x">
										<xsl:value-of select="@payment_data"/>
									</span>
								</div>
							</div>
						</div>
						<form method="post">
							<input type="hidden" name="payment_type" value="{@payment_type}"/>
							<input type="hidden" name="id" value="{@id}"/>
							<button type="submit" name="top_up_subscription" class="btn btn-block btn-success">
								<i class="fa fa-credit-card"></i>
								Top Up
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
		<div class="modal" id="modal-subscription-cancel-{@payment_type}-{@id}" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="panel panel-danger">
					<div class="panel-heading">
						<button type="button" class="close" data-dismiss="modal">&#215;</button>
						Terminate Subscription
						<xsl:call-template name="billing_payment_type"/>
						#<xsl:value-of select="@id"/>
					</div>
					<div class="panel-body">
						<div class="container-fluid">
							<div class="row">
								<div class="col-lg-3">
									<b class="space-x">Actions Count:</b>
									<xsl:value-of select="@actions_cnt"/>
								</div>
								<div class="col-lg-3">
									<b class="space-x">Payment Amount:</b>
									<xsl:value-of select="@payment_amount"/>
								</div>
								<div class="col-lg-6">
									<b class="space-x">Payment Data:</b>
									<xsl:value-of select="@payment_data"/>
								</div>
							</div>
						</div>
						<form method="post">
							<input type="hidden" name="payment_type" value="{@payment_type}"/>
							<input type="hidden" name="id" value="{@id}"/>
							<button type="submit" name="cancel_subscription" class="btn btn-block btn-danger">
								<i class="glyphicon glyphicon-trash"></i>
								Terminate
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
	<xsl:for-each select="transaction">
		<xsl:if test="@refundable">
			<div class="modal" id="modal-transaction-refund-{@id}" role="dialog">
				<div class="modal-dialog modal-lg">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<button type="button" class="close" data-dismiss="modal">&#215;</button>
							Refund #<xsl:value-of select="@id"/>
						</div>
						<div class="panel-body">
							<div class="container-fluid">
								<div class="row">
									<div class="col-lg-4">
										<b class="space-x">Actions Count:</b>
										<xsl:value-of select="@actions_cnt"/>
									</div>
									<div class="col-lg-4">
										<b class="space-x">Actions Available:</b>
										<xsl:value-of select="../@actions_available"/>
									</div>
									<xsl:if test="@actions_cnt &gt; ../@actions_available">
										<div class="col-lg-4">
											<b class="text-failure">Partial Refund</b>
										</div>
									</xsl:if>
								</div>
							</div>
							<xsl:apply-templates select="." mode="data"/>
							<form method="post">
								<input type="hidden" name="id" value="{@id}"/>
								<button type="submit" name="refund" class="btn btn-block btn-danger">
									<i class="fa fa-reply"></i>
									Refund
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
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
