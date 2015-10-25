<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="billing_archive">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="billing_archive" mode="menu">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Billing Archive</h1>
				<xsl:if test="//message">
					<div class="row">
						<div class="col-lg-12">
							<xsl:apply-templates select="//message"/>
						</div>
					</div>
				</xsl:if>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="billing-clear">&#215;</button>
					<b>Tip:</b>
					Transaction data is purged after 2 years.
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="fa fa-credit-card"></i>
						Transactions
					</div>
					<div class="panel-body">
						<table class="table table-striped table-hover">
							<thead>
								<tr>
									<th>#</th>
									<th>Time</th>
									<th>Transaction</th>
									<th>Before</th>
									<th>Credit/Charge</th>
									<th>After</th>
									<th>Data</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="transaction">
									<tr>
										<xsl:attribute name="class">
											<xsl:apply-templates select="." mode="severity"/>
										</xsl:attribute>
										<td>
											<span id="{@id}">
												#<xsl:value-of select="@id"/>
											</span>
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
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
