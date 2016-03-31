<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="task">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Уведомление о выполнении теста</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-info">
				<div class="panel-body">
					<div class="row">
						<div class="col-lg-2">
							<b>Тест</b>:
							<xsl:value-of select="@test_name"/>
						</div>
						<div class="col-lg-2">
							<b>Результат</b>:
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
								<xsl:choose>
									<xsl:when test="@status = 'succeeded'">успешно</xsl:when>
									<xsl:when test="@status = 'failed'">ОШИБКА</xsl:when>
									<xsl:otherwise><xsl:value-of select="@status"/></xsl:otherwise>
								</xsl:choose>
							</span>
						</div>
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
								<b class="text-failure">Ошибка</b>:
								<span class="text-failure">
									<xsl:value-of select="@failed"/>
								</span>
							</xsl:if>
						</div>
						<div class="col-lg-2">
							<xsl:if test="@scrn">
								<a href="cid:{@scrn}">
									<img src="cid:{@scrn}" class="img-thumbnail img-responsive">
										<xsl:attribute name="alt">
											<xsl:if test="@succeeded">
												успешно:
											</xsl:if>
											<xsl:if test="@failed">
												ошибка:
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
</xsl:template>

</xsl:stylesheet>