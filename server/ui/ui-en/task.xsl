<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="task">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="task" mode="menu">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Task</h1>
				<xsl:apply-templates select="//message"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-info">
					<div class="panel-body">
						<div class="row">
							<div class="col-lg-2">
								<b>Test</b>:
								<a href="./?test={@test_id}">
									<xsl:value-of select="@test_name"/>
								</a>
							</div>
							<div class="col-lg-2">
								<b>Type</b>:
								<span class="task-type">
									<xsl:value-of select="@type"/>
								</span>
							</div>
							<div class="col-lg-2">
								<b>Status</b>:
								<span>
									<xsl:if test="@status = 'succeeded'">
										<xsl:attribute name="class">
											text-success
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="@status = 'failed'">
										<xsl:attribute name="class">
											text-failure
										</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="@status"/>
								</span>
							</div>
							<div class="col-lg-2">
								<b>Debug</b>:
								<span>
									<xsl:choose>
										<xsl:when test="@debug">
											<xsl:attribute name="class">
												text-success
											</xsl:attribute>
											on
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="class">
												text-failure
											</xsl:attribute>
											off
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</div>
							<div class="col-lg-3">
								<b>Time</b>:
								<span class="time-unix2human">
									<xsl:value-of select="@time"/>
								</span>
							</div>
							<div class="col-lg-1">
								<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-test-restart">
									<i class="fa fa-play"></i>
									Restart
								</button>
							</div>
							<xsl:call-template name="modal_new_task">
								<xsl:with-param name="modal_id">modal-test-restart</xsl:with-param>
								<xsl:with-param name="test_name"><xsl:value-of select="@test_name"/></xsl:with-param>
								<xsl:with-param name="test_id"><xsl:value-of select="@test_id"/></xsl:with-param>
							</xsl:call-template>
						</div>
					</div>
				</div>
			</div>
		</div>
		<xsl:for-each select="action">
			<xsl:sort select="@id" data-type="number" order="ascending"/>
			<div class="row">
				<div class="col-lg-12">
					<div>
						<xsl:choose>
							<xsl:when test="@succeeded">
								<xsl:attribute name="class">
									alert alert-success
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="@failed">
								<xsl:attribute name="class">
									alert alert-danger
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">
									alert alert-warning
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<div class="row">
							<div class="col-lg-8">
								<div class="row">
									<xsl:apply-templates select="." mode="html"/>
								</div>
							</div>
							<div class="col-lg-2">
								<xsl:if test="@failed">
									<b class="text-failure">Failure</b>:
									<span class="text-failure" title="{@failed}">
										<xsl:value-of select="@failed"/>
									</span>
								</xsl:if>
							</div>
							<div class="col-lg-2">
								<xsl:if test="@scrn">
									<a href="results/{@scrn}" target="_blank">
										<img src="results/{@scrn}" class="img-thumbnail img-responsive">
											<xsl:attribute name="alt">
												<xsl:if test="@succeeded">
													succeeded:
												</xsl:if>
												<xsl:if test="@failed">
													failed:
												</xsl:if>
												<xsl:apply-templates select="." mode="text"/>
												<xsl:if test="@failed">
													, <xsl:value-of select="@failed"/>
												</xsl:if>
											</xsl:attribute>
										</img>
									</a>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:for-each>
	</div>
</xsl:template>

</xsl:stylesheet>
