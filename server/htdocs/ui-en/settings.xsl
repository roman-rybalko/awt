<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="settings">
	<xsl:call-template name="menu" />
</xsl:template>

<xsl:template match="settings" mode="menu">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Settings</h1>
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
			<div class="col-lg-6">
				<div class="panel panel-info">
					<div class="panel-heading">
						Password
					</div>
					<div class="panel-body">
						<form role="form" method="post">
							<div class="form-group">
								<label>Password</label>
								<input class="form-control" placeholder="New password" name="password" type="password"/>
							</div>
							<div class="form-group">
								<label>Password (confirm)</label>
								<input class="form-control" placeholder="New password" name="password2" type="password"/>
							</div>
							<button type="submit" class="btn btn-success">
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
							<button type="submit" class="btn btn-success">
								<i class="fa fa-pencil"></i>
								Change E-Mail
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
									Send e-mail report when a task is failed.
								</label>
							</div>
							<button type="submit" name="task_fail_email_report" value="" class="btn btn-success">
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
									Send e-mail report when a task is succeeded.
								</label>
							</div>
							<button type="submit" name="task_success_email_report" value="" class="btn btn-success">
								<i class="fa fa-pencil"></i>
								Change E-Mail Report Setting
							</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
