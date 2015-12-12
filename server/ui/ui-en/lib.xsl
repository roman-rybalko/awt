<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="modal_new_task">
	<xsl:param name="modal_id"/>
	<xsl:param name="test_name"/>
	<xsl:param name="test_id"/>
	<div class="modal" id="{$modal_id}" role="dialog">
		<div class="modal-dialog">
			<div class="panel panel-success">
				<div class="panel-heading">
					<button type="button" class="close" data-dismiss="modal">&#215;</button>
					Run:
					<xsl:value-of select="$test_name"/>
				</div>
				<div class="panel-body">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="modal-new-task-legend">&#215;</button>
						<b>Legend:</b><br/>
						gc_xxx - Google Chrome / Chromium<br/>
						ff_xxx - Firefox<br/>
						o_xxx - Opera<br/>
						ie_xxx - Internet Explorer<br/>
						test - new functionality testing
					</div>
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="modal-new-task-debug">&#215;</button>
						<b>Tip:</b>
						When Debug is ON all actions will be executed regardless of error.
					</div>
					<form role="form" method="post" action="../?tasks=1" class="apply-data-display-period">
						<input type="hidden" name="test_id" value="{$test_id}"/>
						<input type="hidden" name="add" value="1"/>
						<div class="checkbox">
							<label>
								<input type="checkbox" name="debug"/>
								<i class="fa fa-wrench"></i>
								Debug
							</label>
						</div>
						<xsl:for-each select="//task_types//type[not(@name = preceding::type/@name)]">
							<button type="submit" name="type" value="{@name}" class="btn btn-success btn-outline space-x space-y task-type">
								<xsl:value-of select="@name"/>
							</button>
						</xsl:for-each>
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

<xsl:template name="js_task_types">
	<script type="text/javascript">
		task_types = [  // global
			<xsl:for-each select="//task_types//type">
				{name: "<xsl:value-of select="@name"/>", id: "<xsl:value-of select="@id"/>", parent_id: "<xsl:value-of select="@parent_id"/>"},
			</xsl:for-each>
		];
	</script>
</xsl:template>

<xsl:template name="billing_payment_type">
	<xsl:choose>
		<xsl:when test="@payment_type = 1">
			Demo
		</xsl:when>
		<xsl:when test="@payment_type = 2">
			PayPal
		</xsl:when>
		<xsl:when test="@payment_type = 3">
			WebMoney
		</xsl:when>
		<xsl:otherwise>
			<b class="space-x">Payment Type:</b>
			<xsl:value-of select="@payment_type"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
