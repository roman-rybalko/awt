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
							<button type="submit" name="type" value="{@name}" class="btn btn-success btn-outline space-x space-y">
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

</xsl:stylesheet>
