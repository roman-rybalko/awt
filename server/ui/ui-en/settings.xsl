<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="settings">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="settings" mode="menu">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Settings</h1>
				<xsl:if test="//message">
					<div class="row">
						<div class="col-lg-12">
							<xsl:apply-templates select="//message"/>
						</div>
					</div>
				</xsl:if>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<div class="panel panel-info">
					<div class="panel-heading">
						Password
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<div class="form-group">
								<label>Current Password</label>
								<input class="form-control" placeholder="current password" name="password" type="password"/>
							</div>
							<div class="form-group">
								<label>New Password</label>
								<input class="form-control" placeholder="New password" name="password1" type="password"/>
							</div>
							<div class="form-group">
								<label>New Password (confirm)</label>
								<input class="form-control" placeholder="New password" name="password2" type="password"/>
							</div>
							<button type="submit" class="btn btn-block btn-success">
								<i class="fa fa-pencil"></i>
								Change password
							</button>
						</form>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="panel panel-info">
					<div class="panel-heading">
						E-Mail
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<div class="form-group">
								<label>E-Mail</label>
								<input class="form-control" placeholder="New E-Mail" name="email" type="email" value="{@email}"/>
							</div>
							<button type="submit" class="btn btn-block btn-success">
								<i class="fa fa-pencil"></i>
								Set E-Mail
							</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<div class="panel panel-info">
					<div class="panel-heading">
						Task Fail E-Mail Report
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<xsl:attribute name="onsubmit"><![CDATA[
								$('[name="task_fail_email_report"]').val($('#task_fail_email_report').prop('checked') ? 1 : 0);
							]]></xsl:attribute>
							<div class="checkbox">
								<label>
									<input type="checkbox" id="task_fail_email_report">
										<xsl:if test="@task_fail_email_report > 0">
											<xsl:attribute name="checked"></xsl:attribute>
										</xsl:if>
									</input>
									Send e-mail report when the task is FAILED.
								</label>
							</div>
							<button type="submit" name="task_fail_email_report" value="" class="btn btn-block btn-success">
								<i class="fa fa-pencil"></i>
								Change E-Mail Report Setting
							</button>
						</form>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="panel panel-info">
					<div class="panel-heading">
						Task Success E-Mail Report
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<xsl:attribute name="onsubmit"><![CDATA[
								$('[name="task_success_email_report"]').val($('#task_success_email_report').prop('checked') ? 1 : 0);
							]]></xsl:attribute>
							<div class="checkbox">
								<label>
									<input type="checkbox" id="task_success_email_report">
										<xsl:if test="@task_success_email_report > 0">
											<xsl:attribute name="checked"></xsl:attribute>
										</xsl:if>
									</input>
									Send e-mail report when the task is succeeded.
								</label>
							</div>
							<button type="submit" name="task_success_email_report" value="" class="btn btn-block btn-success">
								<i class="fa fa-pencil"></i>
								Change E-Mail Report Setting
							</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<div class="panel panel-danger">
					<div class="panel-heading">
						Delete Account
					</div>
					<div class="panel-body">
						<a href="#" class="btn btn-block btn-danger" data-toggle="modal" data-target="#modal-delete_account">
							<i class="glyphicon glyphicon-trash"></i>
							Delete Account
						</a>

					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal" id="modal-delete_account" role="dialog">
		<div class="modal-dialog modal-md">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					Delete Account: <xsl:value-of select="../@login"/>
				</div>
				<div class="panel-body">
					When you delete your account,
					<ul>
						<li>
							all your <a href="../?tasks=1">Pending Tasks</a> will be canceled,
						</li>
						<li>
							all your <a href="../?schedule=1">Schedule Jobs</a> will be canceled,
						</li>
						<li>
							all your <a href="../?billing=1">Payment Subscriptions</a> will be canceled,
						</li>
						<li>
							your <a href="../?billing=1">Available Actions (Balance)</a> will be refunded.
						</li>
					</ul>
					During 42 days you may ask to restore your account via support.
					After 42 days all account data will be deleted permanently.
					<form role="form" method="post">
						<button type="submit" name="delete_account" class="btn btn-block btn-danger">
							<i class="glyphicon glyphicon-trash"></i>
							Delete Account
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
</xsl:template>

</xsl:stylesheet>
