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
					<div class="well well-sm">
						<b>Usage:</b>
						<br/>
						<code>gc_xxx</code> - Google Chrome / Chromium
						<br/>
						<code>ff_xxx</code> - Firefox
						<br/>
						<code>o_xxx</code> - Opera
						<br/>
						<code>ie_xxx</code> - Internet Explorer
						<br/>
						<code>test</code> - new functionality testing
						<br/>
						<code>all</code>, <code>ff</code>, <code>gc</code>, etc. contain several underlying browsers which are chosen randomly.
						What exactly browsers may be started see in a tooltip (hover on an item for 1-2 sec).
						<p/>
						<i>Debug</i> - Execute the test till the end regardless of error. By default the test is stopped on the first error.
					</div>
					<form role="form" method="post" action="./?tasks=1" class="apply-data-display-period">
						<input type="hidden" name="test_id" value="{$test_id}"/>
						<input type="hidden" name="start" value="1"/>
						<div class="checkbox">
							<label>
								<input type="checkbox" name="debug"/>
								<i class="fa fa-wrench"></i>
								Debug
							</label>
						</div>
						<div class="task-type"/>
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
