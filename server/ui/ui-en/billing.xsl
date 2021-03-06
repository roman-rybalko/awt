<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="billing">
	<xsl:choose>
		<xsl:when test="//message[@value='payment_pending']">
			<xsl:call-template name="redirect">
				<xsl:with-param name="url"><xsl:value-of select="//pending_transaction[@payment_type = //message[@value='payment_pending']/@payment_type and @id = //message[@value='payment_pending']/@id]/@url"/></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="//message[contains(@value, 'paypal') or contains(@value, 'webmoney')]">
			<xsl:call-template name="redirect">
				<xsl:with-param name="url">?billing=1&amp;time=<xsl:value-of select="@time"/></xsl:with-param>
				<xsl:with-param name="timeout">3</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="menu"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="billing" mode="menu">
	<script src="ui-en/js/jquery.dataTables.min.js" type="text/javascript"></script>
	<link href="ui-en/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
	<script src="ui-en/js/dataTables.responsive.min.js" type="text/javascript"></script>
	<link href="ui-en/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/responsive.bootstrap.min.js" type="text/javascript"></script>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Billing</h1>
				<xsl:apply-templates select="//message"/>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="set-email">&#215;</button>
					<b>Tip:</b>
					Please, check your email in &quot;<a href="./?settings=1">Settings</a>&quot;.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-4">
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="./file.php?billing=1">
							<i class="fa fa-archive"></i>
							Export transactions (CSV)
						</a>
						<br/>
						<a href="mailto:billing@advancedwebtesting.com?subject=Billing%20Support%20Request:%20&amp;body=Login:%20{../@login}%0aTransaction ID:%20%0aPending Transaction ID:%20%0aSubscription ID:%20%0a">
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
						100 Browser Actions = $1 USD
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
								<div>Available Actions (Account Balance)</div>
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
		<div class="modal" id="modal-top_up" role="dialog">
			<div class="modal-dialog modal-md">
				<div class="panel panel-danger">
					<div class="panel-heading">
						<button type="button" class="close" data-dismiss="modal">&#215;</button>
						Top Up
					</div>
					<div class="panel-body">
						<div class="alert alert-warning">
							<b>Limits:</b><br/>
							<b>PayPal:</b> MIN = $2 USD (200 Actions), MAX = $5 USD (500 Actions)<br/>
							<b>WebMoney:</b> MIN = $0.01 USD (1 Action), MAX = $2 USD (200 Actions)
						</div>
						<form role="form" method="post">
							<div class="form-group">
								<table style="width:100%;">
									<tr>
										<td>
											<input type="radio" id="modal-top_up-payment_type-paypal" name="payment_type" value="2" checked=""/>
										</td>
										<td>
											<label for="modal-top_up-payment_type-paypal">
												<img src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_200x51.png" alt="PayPal"/>
											</label>
										</td>
									</tr>
									<tr>
										<td>
											<input type="radio" id="modal-top_up-payment_type-webmoney" name="payment_type" value="3"/>
										</td>
										<td>
											<label for="modal-top_up-payment_type-webmoney">
												<img src="ui-en/webmoney/wmlogo.png" alt="WebMoney"/>
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
									<input type="checkbox" name="subscription" value="1"/>
									Subscription/Recurring payments/Auto top up when the account balance gets low
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
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-success">
					<div class="panel-heading">
						<i class="fa fa-refresh"></i>
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
											<a href="#" data-toggle="modal" data-target="#modal-subscription-modify-{@payment_type}-{@id}" class="btn btn-xs btn-primary">
												<i class="fa fa-edit"></i>
												Modify
											</a>
										</td>
										<td>
											<a href="#" data-toggle="modal" data-target="#modal-subscription-top_up-{@payment_type}-{@id}" class="btn btn-xs btn-success">
												<i class="glyphicon glyphicon-credit-card"></i>
												Top Up
											</a>
										</td>
										<td>
											<a href="#" data-toggle="modal" data-target="#modal-subscription-cancel-{@payment_type}-{@id}" class="btn btn-xs btn-danger">
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
				<xsl:if test="count(subscription) &gt; 1">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="billing-subscription-order">&#215;</button>
						<b>Tip:</b>
						Firstly is processed the subscription with a higher amount.
					</div>
				</xsl:if>
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
											<xsl:if test="@transaction_id">
												<a href="./?billing_archive=1#{@transaction_id}">
													#<xsl:value-of select="@transaction_id"/>
												</a>
											</xsl:if>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="@code">
													<a href="#" data-toggle="modal" data-target="#modal-pending-transaction-code-{@payment_type}-{@id}">
														<xsl:value-of select="@actions_cnt"/>
													</a>
												</xsl:when>
												<xsl:when test="@url">
													<a href="{@url}">
														<xsl:value-of select="@actions_cnt"/>
													</a>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@actions_cnt"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="@code">
													<a href="#" data-toggle="modal" data-target="#modal-pending-transaction-code-{@payment_type}-{@id}">
														<xsl:value-of select="@payment_amount"/>
													</a>
												</xsl:when>
												<xsl:when test="@url">
													<a href="{@url}">
														<xsl:value-of select="@payment_amount"/>
													</a>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@payment_amount"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="@code">
													<a href="#" data-toggle="modal" data-target="#modal-pending-transaction-code-{@payment_type}-{@id}">
														<xsl:value-of select="@payment_data"/>
													</a>
												</xsl:when>
												<xsl:when test="@url">
													<a href="{@url}">
														<xsl:value-of select="@payment_data"/>
													</a>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@payment_data"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="@code">
													<a href="#" data-toggle="modal" data-target="#modal-pending-transaction-code-{@payment_type}-{@id}" class="btn btn-xs btn-primary">
														<i class="fa fa-gear"></i>
														Process
													</a>
												</xsl:when>
												<xsl:otherwise>
													<form method="post" style="display: inline;">
														<input type="hidden" name="payment_type" value="{@payment_type}"/>
														<input type="hidden" name="id" value="{@id}"/>
														<button type="submit" name="process_pending_transaction" class="btn btn-xs btn-primary">
															<i class="fa fa-gear"></i>
															Process
														</button>
													</form>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<form method="post" style="display: inline;">
												<input type="hidden" name="payment_type" value="{@payment_type}"/>
												<input type="hidden" name="id" value="{@id}"/>
												<button type="submit" name="cancel_pending_transaction" class="btn btn-xs btn-danger">
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
				<xsl:if test="pending_transaction">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="billing-pending-transactions-process">&#215;</button>
						<b>Tip:</b>
						Pending Transactions are also processed every minute automatically.
					</div>
				</xsl:if>
			</div>
		</div>
		<xsl:for-each select="pending_transaction">
			<xsl:if test="@code">
				<div class="modal modal-pending-transaction-code" id="modal-pending-transaction-code-{@payment_type}-{@id}" role="dialog">
					<div class="modal-dialog modal-md">
						<div class="panel panel-primary">
							<div class="panel-heading">
								<button type="button" class="close" data-dismiss="modal">&#215;</button>
								Processing Pending Transaction
								<xsl:call-template name="billing_payment_type"/>
								#<xsl:value-of select="@id"/>
							</div>
							<div class="panel-body">
								<p>
									<xsl:value-of select="@payment_data"/>
								</p>
								<p>
									You should have received the authorization code for the transaction.
								</p>
								<form role="form" method="post">
									<input type="hidden" name="payment_type" value="{@payment_type}"/>
									<input type="hidden" name="id" value="{@id}"/>
									<div class="form-group">
										<label for="modal-pending-transaction-code-{@payment_type}-{@id}-code">Enter the code:</label>
										<input type="text" id="modal-pending-transaction-code-{@payment_type}-{@id}-code" class="form-control" name="code" placeholder="code"/>
									</div>
									<div class="form-group">
										<button type="submit" name="process_pending_transaction" class="btn btn-block btn-primary">
											<i class="fa fa-gear"></i>
											Process
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
			</xsl:if>
		</xsl:for-each>
		<div class="row">
			<div class="col-lg-12">
				<xsl:if test="count(transaction) &gt; 500">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="data-display-period">&#215;</button>
						<b>Tip:</b>
						Use <b>Data Display Period</b> option in <a href="./?settings=1">Settings</a> to reduce displayed data and speed up the UI.
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
									<th data-orderable="false"></th>
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
												<a href="#" data-toggle="modal" data-target="#modal-transaction-refund-{@id}" class="btn btn-xs btn-danger">
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
				<xsl:if test="transaction">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close tip-state" data-dismiss="alert" aria-hidden="true" data-tip-state="billing-transactions-display-period">&#215;</button>
						<b>Tip:</b>
						Transactions displayed here are for 42 days max. Please, use <a href="./file.php?billing=1">Export transactions (CSV)</a> for a full list.
					</div>
				</xsl:if>
			</div>
		</div>
	</div>
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
