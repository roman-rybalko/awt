<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="event[@name='login']" mode="title">
	Sign in
</xsl:template>

<xsl:template match="event[@name='logout']" mode="title">
	Sign out
</xsl:template>

<xsl:template match="event[@name='login' or @name='logout']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">IP:</b>
				<xsl:value-of select="@ip"/>
			</div>
			<div class="col-lg-9">
				<b class="space-x">User-Agent:</b>
				<i><xsl:value-of select="@ua"/></i>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='password_change']" mode="title">
	Change Password
</xsl:template>

<xsl:template match="event[@name='password_change']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">IP:</b>
				<xsl:value-of select="@ip"/>
			</div>
			<div class="col-lg-9">
				<b class="space-x">User-Agent:</b>
				<i><xsl:value-of select="@ua"/></i>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='email_change']" mode="title">
	Change E-Mail
</xsl:template>

<xsl:template match="event[@name='email_change']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">E-Mail Address:</b>
				<xsl:value-of select="@old_email"/>
				-&gt;
				<xsl:value-of select="@email"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">IP:</b>
				<xsl:value-of select="@ip"/>
			</div>
			<div class="col-lg-9">
				<b class="space-x">User-Agent:</b>
				<i><xsl:value-of select="@ua"/></i>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='settings_change']" mode="title">
	Change Settings
</xsl:template>

<xsl:template match="event[@name='settings_change']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<xsl:if test="@task_fail_email_report">
				<div class="col-lg-6">
					<b class="space-x">Task Fail E-Mail Report:</b>
					<xsl:if test="@old_task_fail_email_report">
						<xsl:value-of select="@old_task_fail_email_report"/>
						-&gt;
					</xsl:if>
					<xsl:value-of select="@task_fail_email_report"/>
				</div>
			</xsl:if>
			<xsl:if test="@task_success_email_report">
				<div class="col-lg-6">
					<b class="space-x">Task Success E-Mail Report:</b>
					<xsl:if test="@old_task_success_email_report">
						<xsl:value-of select="@old_task_success_email_report"/>
						-&gt;
					</xsl:if>
					<xsl:value-of select="@task_success_email_report"/>
				</div>
			</xsl:if>
		</div>
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">IP:</b>
				<xsl:value-of select="@ip"/>
			</div>
			<div class="col-lg-9">
				<b class="space-x">User-Agent:</b>
				<i><xsl:value-of select="@ua"/></i>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_add']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='test_add']" mode="title">
	New Test
</xsl:template>

<xsl:template match="event[@name='test_add']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_delete']" mode="severity">
	danger
</xsl:template>

<xsl:template match="event[@name='test_delete']" mode="title">
	Delete Test
</xsl:template>

<xsl:template match="event[@name='test_delete']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_restore']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='test_restore']" mode="title">
	Restore Test
</xsl:template>

<xsl:template match="event[@name='test_restore']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_rename']" mode="severity">
	info
</xsl:template>

<xsl:template match="event[@name='test_rename']" mode="title">
	Rename Test
</xsl:template>

<xsl:template match="event[@name='test_rename']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}">
					<xsl:value-of select="@old_test_name"/>
				</a>
				-&gt;
				<a href="../?test={@test_id}">
					<xsl:value-of select="@test_name"/>
				</a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_copy']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='test_copy']" mode="title">
	Copy Test
</xsl:template>

<xsl:template match="event[@name='test_copy']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Test:</b>
				<a href="../?test={@orig_test_id}">
					<xsl:value-of select="@orig_test_name"/>
				</a>
				-&gt;
				<a href="../?test={@test_id}">
					<xsl:value-of select="@test_name"/>
				</a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_action_add']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='test_action_add']" mode="title">
	Add Test Action
</xsl:template>

<xsl:template match="event[@name='test_action_add']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}#{@action_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<xsl:value-of select="@type"/>
			</div>
			<xsl:if test="@selector">
				<div class="col-lg-3">
					<b class="space-x">Selector:</b>
					<xsl:value-of select="@selector"/>
				</div>
			</xsl:if>
			<xsl:if test="@data">
				<div class="col-lg-3">
					<b class="space-x">Data:</b>
					<xsl:value-of select="@data"/>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_action_delete']" mode="severity">
	danger
</xsl:template>

<xsl:template match="event[@name='test_action_delete']" mode="title">
	Delete Test Action
</xsl:template>

<xsl:template match="event[@name='test_action_delete']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}#{@action_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<xsl:value-of select="@type"/>
			</div>
			<xsl:if test="@selector">
				<div class="col-lg-3">
					<b class="space-x">Selector:</b>
					<xsl:value-of select="@selector"/>
				</div>
			</xsl:if>
			<xsl:if test="@data">
				<div class="col-lg-3">
					<b class="space-x">Data:</b>
					<xsl:value-of select="@data"/>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_action_modify']" mode="severity">
	info
</xsl:template>

<xsl:template match="event[@name='test_action_modify']" mode="title">
	Modify Test Action
</xsl:template>

<xsl:template match="event[@name='test_action_modify']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}#{@action_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<xsl:if test="@old_type">
					<xsl:value-of select="@old_type"/>
					-&gt;
				</xsl:if>
				<xsl:value-of select="@type"/>
			</div>
			<xsl:if test="@selector">
				<div class="col-lg-3">
					<b class="space-x">Selector:</b>
					<xsl:if test="@old_selector">
						<xsl:value-of select="@old_selector"/>
						-&gt;
					</xsl:if>
					<xsl:value-of select="@selector"/>
				</div>
			</xsl:if>
			<xsl:if test="@data">
				<div class="col-lg-3">
					<b class="space-x">Data:</b>
					<xsl:if test="@old_data">
						<xsl:value-of select="@old_data"/>
						-&gt;
					</xsl:if>
					<xsl:value-of select="@data"/>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='test_action_insert']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='test_action_insert']" mode="title">
	Insert Test Action
</xsl:template>

<xsl:template match="event[@name='test_action_insert']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}#{@action_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<xsl:value-of select="@type"/>
			</div>
			<xsl:if test="@selector">
				<div class="col-lg-3">
					<b class="space-x">Selector:</b>
					<xsl:value-of select="@selector"/>
				</div>
			</xsl:if>
			<xsl:if test="@data">
				<div class="col-lg-3">
					<b class="space-x">Data:</b>
					<xsl:value-of select="@data"/>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='task_add']" mode="severity">
	warning
</xsl:template>

<xsl:template match="event[@name='task_add']" mode="title">
	Manual Task
</xsl:template>

<xsl:template match="event[@name='task_add']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Type:</b>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='task_cancel']" mode="severity">
	danger
</xsl:template>

<xsl:template match="event[@name='task_cancel']" mode="title">
	Cancel Task
</xsl:template>

<xsl:template match="event[@name='task_cancel']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='sched_add']" mode="severity">
	success
</xsl:template>

<xsl:template match="event[@name='sched_add']" mode="title">
	New Schedule Job
</xsl:template>

<xsl:template match="event[@name='sched_add']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Schedule Job:</b>
				<a href="../?schedule=1#{@sched_id}"><xsl:value-of select="@sched_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Type:</b>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Start:</b>
				<span class="time-unix2human">
					<xsl:value-of select="@start"/>
				</span>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Period:</b>
				<span class="period-unix2human">
					<xsl:value-of select="@period"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='sched_delete']" mode="severity">
	danger
</xsl:template>

<xsl:template match="event[@name='sched_delete']" mode="title">
	Delete Schedule Job
</xsl:template>

<xsl:template match="event[@name='sched_delete']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Schedule Job:</b>
				<a href="../?schedule=1#{@sched_id}"><xsl:value-of select="@sched_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Type:</b>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Start:</b>
				<span class="time-unix2human">
					<xsl:value-of select="@start"/>
				</span>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Period:</b>
				<span class="period-unix2human">
					<xsl:value-of select="@period"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='sched_modify']" mode="severity">
	info
</xsl:template>

<xsl:template match="event[@name='sched_modify']" mode="title">
	Modify Schedule Job
</xsl:template>

<xsl:template match="event[@name='sched_modify']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Schedule Job:</b>
				<xsl:if test="@old_sched_name">
					<a href="../?schedule=1#{@sched_id}">
						<xsl:value-of select="@old_sched_name"/>
					</a>
					-&gt;
				</xsl:if>
				<a href="../?schedule=1#{@sched_id}">
					<xsl:value-of select="@sched_name"/>
				</a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<xsl:if test="@old_test_name">
					<a href="../?test={@old_test_id}">
						<xsl:value-of select="@old_test_name"/>
					</a>
					-&gt;
				</xsl:if>
				<a href="../?test={@test_id}">
					<xsl:value-of select="@test_name"/>
				</a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Type:</b>
				<xsl:if test="@old_type">
					<span class="task-type">
						<xsl:value-of select="@old_type"/>
					</span>
					-&gt;
				</xsl:if>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Start:</b>
				<xsl:if test="@old_start">
					<span class="time-unix2human">
						<xsl:value-of select="@old_start"/>
					</span>
					-&gt;
				</xsl:if>
				<span class="time-unix2human">
					<xsl:value-of select="@start"/>
				</span>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Period:</b>
				<xsl:if test="@old_period">
					<span class="period-unix2human">
						<xsl:value-of select="@old_period"/>
					</span>
					-&gt;
				</xsl:if>
				<span class="period-unix2human">
					<xsl:value-of select="@period"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='task_sched']" mode="severity">
	warning
</xsl:template>

<xsl:template match="event[@name='task_sched']" mode="title">
	Scheduled Task
</xsl:template>

<xsl:template match="event[@name='task_sched']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Schedule Job:</b>
				<a href="../?schedule=1#{@sched_id}"><xsl:value-of select="@sched_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='sched_fail']" mode="severity">
	danger
</xsl:template>

<xsl:template match="event[@name='sched_fail']" mode="title">
	Scheduled Task start Failed
</xsl:template>

<xsl:template match="event[@name='sched_fail']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3">
				<b class="space-x">Schedule Job:</b>
				<a href="../?schedule=1#{@sched_id}"><xsl:value-of select="@sched_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
			<div class="col-lg-3">
				<b class="space-x">Type:</b>
				<span class="task-type">
					<xsl:value-of select="@type"/>
				</span>
			</div>
			<div class="col-lg-3 text-failure">
				<b class="space-x">Failure:</b>
				<xsl:call-template name="message">
					<xsl:with-param name="value" select="@message"/>
				</xsl:call-template>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='mail_verification' or @name='mail_password_reset' or @name='mail_delete_account']" mode="severity">
	warning
</xsl:template>

<xsl:template match="event[@name='mail_verification']" mode="title">
	Send E-Mail Verification
</xsl:template>

<xsl:template match="event[@name='mail_password_reset']" mode="title">
	Send Password Reset Confirmation
</xsl:template>

<xsl:template match="event[@name='mail_delete_account']" mode="title">
	Send Delete Account Confirmation
</xsl:template>

<xsl:template match="event[@name='mail_verification' or @name='mail_password_reset' or @name='mail_delete_account']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Recipient:</b>
				<xsl:value-of select="@rcpt"/>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Message-Id:</b>
				<xsl:value-of select="@message_id"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">SMTP Response:</b>
				<xsl:value-of select="@smtp_response"/>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='mail_task']" mode="severity">
	warning
</xsl:template>

<xsl:template match="event[@name='mail_task']" mode="title">
	Send Task Report
</xsl:template>

<xsl:template match="event[@name='mail_task']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Recipient:</b>
				<xsl:value-of select="@rcpt"/>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Message-Id:</b>
				<xsl:value-of select="@message_id"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">SMTP Response:</b>
				<xsl:value-of select="@smtp_response"/>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event[@name='mail_sched_fail']" mode="severity">
	warning
</xsl:template>

<xsl:template match="event[@name='mail_sched_fail']" mode="title">
	Send Schedule Job Fail Report
</xsl:template>

<xsl:template match="event[@name='mail_sched_fail']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Schedule Job:</b>
				<a href="../?schedule=1#{@sched_id}"><xsl:value-of select="@sched_name"/></a>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Test:</b>
				<a href="../?test={@test_id}"><xsl:value-of select="@test_name"/></a>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Recipient:</b>
				<xsl:value-of select="@rcpt"/>
			</div>
			<div class="col-lg-6">
				<b class="space-x">Message-Id:</b>
				<xsl:value-of select="@message_id"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">SMTP Response:</b>
				<xsl:value-of select="@smtp_response"/>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="event" mode="severity"/>

<xsl:template match="event" mode="title">
	<xsl:value-of select="@name"/>
</xsl:template>

<xsl:template match="event" mode="data"/>

</xsl:stylesheet>
