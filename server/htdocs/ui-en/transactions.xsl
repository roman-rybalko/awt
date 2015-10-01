<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="transaction[@type='top_up']" mode="severity">
	success
</xsl:template>

<xsl:template match="transaction[@type='top_up']" mode="title">
	Top Up
</xsl:template>

<xsl:template match="transaction[@type='top_up']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-4">
				<b class="space-x">Type:</b>
				<xsl:value-of select="@payment_type"/>
			</div>
			<div class="col-lg-4">
				<b class="space-x">Amount:</b>
				<xsl:value-of select="@payment_amount"/>
			</div>
			<div class="col-lg-4">
				<b class="space-x">Data:</b>
				<xsl:value-of select="@payment_data"/>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="transaction[@type='service']" mode="severity">
	warning
</xsl:template>

<xsl:template match="transaction[@type='service']" mode="title">
	Service Charge
</xsl:template>

<xsl:template match="transaction[@type='service']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<xsl:value-of select="@data"/>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="transaction[@type='task_start' or @type='task_end']" mode="severity">
	danger
</xsl:template>

<xsl:template match="transaction[@type='task_start']" mode="title">
	Task Start
</xsl:template>

<xsl:template match="transaction[@type='task_end']" mode="title">
	Task Finish
</xsl:template>

<xsl:template match="transaction[@type='task_start']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-6">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}">
					<xsl:value-of select="@test_name"/>
				</a>
			</div>
			<xsl:if test="@sched_id">
				<div class="col-lg-6">
					<b class="space-x">Schedule Job:</b>
					<a href="../?schedule=1#{@sched_id}">
						<xsl:value-of select="@sched_name"/>
					</a>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="transaction[@type='task_end']" mode="data">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<b class="space-x">Task:</b>
				<a href="../?task={@task_id}">
					<xsl:value-of select="@test_name"/>
				</a>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="transaction" mode="severity"/>

<xsl:template match="transaction" mode="title">
	<xsl:value-of select="@type"/>
</xsl:template>

<xsl:template match="transaction" mode="data"/>

</xsl:stylesheet>
