<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="transaction[@type='top_up']" mode="title">
	Top Up
</xsl:template>

<xsl:template match="transaction[@type='service']" mode="title">
	Service Credit/Charge
</xsl:template>

<xsl:template match="transaction[@type='service']" mode="data">
	<xsl:value-of select="@data"/>
</xsl:template>

<xsl:template match="transaction[@type='task_start']" mode="title">
	Task Start
</xsl:template>

<xsl:template match="transaction[@type='task_finish']" mode="title">
	Task Finish
</xsl:template>

<xsl:template match="transaction[@type='refund']" mode="title">
	Refund
</xsl:template>

<xsl:template match="transaction" mode="severity">
	<xsl:choose>
		<xsl:when test="@ref_id">
			info
		</xsl:when>
		<xsl:when test="@actions_after &gt; @actions_before">
			success
		</xsl:when>
		<xsl:when test="@actions_before &gt; @actions_after">
			danger
		</xsl:when>
		<xsl:otherwise>
			warning
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="transaction" mode="title">
	<xsl:value-of select="@type"/>
</xsl:template>

<xsl:template match="transaction" mode="data">
	<xsl:if test="@payment_type">
		<b class="space-x">Payment Type:</b>
		<span class="space-x">
			<xsl:call-template name="billing_payment_type"/>
		</span>
	</xsl:if>
	<xsl:if test="@payment_amount">
		<b class="space-x">Payment Amount:</b>
		<span class="space-x">
			<xsl:value-of select="@payment_amount"/>
		</span>
	</xsl:if>
	<xsl:if test="@payment_data">
		<b class="space-x">Payment Data:</b>
		<span class="space-x">
			<xsl:value-of select="@payment_data"/>
		</span>
	</xsl:if>
	<xsl:if test="@subscription_data">
		<b class="space-x">Subscription Data:</b>
		<span class="space-x">
			<xsl:value-of select="@subscription_data"/>
		</span>
	</xsl:if>
	<xsl:if test="@task_id and @test_name">
		<b class="space-x">Task:</b>
		<a href="../?task={@task_id}" class="space-x">
			<xsl:value-of select="@test_name"/>
		</a>
	</xsl:if>
	<xsl:if test="@sched_id and @sched_name">
		<b class="space-x">Schedule Job:</b>
		<a href="../?schedule=1#{@sched_id}" class="space-x">
			<xsl:value-of select="@sched_name"/>
		</a>
	</xsl:if>
	<xsl:if test="@ref_id">
		<xsl:choose>
			<xsl:when test="@type = 'refund'">
				<b class="space-x">Transaction:</b>
			</xsl:when>
			<xsl:otherwise>
				<b class="space-x">Refund:</b>
			</xsl:otherwise>
		</xsl:choose>
		<a href="../?billing_archive=1#{@ref_id}" class="space-x">
			#<xsl:value-of select="@ref_id"/>
		</a>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
