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
					<xsl:call-template name="helper_tip">
						<xsl:with-param name="state">modal-new-task-debug</xsl:with-param>
						<xsl:with-param name="text">
							When Debug is ON all actions will be executed regardless of error.
						</xsl:with-param>
					</xsl:call-template>
					<form role="form" method="post" action="../?tasks=1">
						<input type="hidden" name="test_id" value="{$test_id}"/>
						<input type="hidden" name="add" value="1"/>
						<div class="checkbox">
							<label>
								<input type="checkbox" name="debug"/>
								<i class="fa fa-wrench"></i>
								Debug
							</label>
						</div>
						<xsl:for-each select="//task_types//type">
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

<xsl:template name="js_task_tests">
	<script type="text/javascript">
		task_tests = [  // global
			<xsl:for-each select="//task_tests//test">
				{name: "<xsl:value-of select="@name"/>", id: "<xsl:value-of select="@id"/>"},
			</xsl:for-each>
		];
	</script>
</xsl:template>

<xsl:template name="helper_tip">
	<xsl:param name="text"/>
	<xsl:param name="state"/>
	<div class="alert alert-info alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="{$state}">&#215;</button>
		<b>Tip:</b>
		<xsl:value-of select="$text"/>
	</div>
</xsl:template>

</xsl:stylesheet>
