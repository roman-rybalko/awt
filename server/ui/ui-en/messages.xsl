<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="message[@type='info']">
	<div class="alert alert-info alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:apply-templates select="." mode="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='notice']">
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:apply-templates select="." mode="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@type='error']">
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&#215;</button>
		<xsl:apply-templates select="." mode="message"/>
	</div>
</xsl:template>

<xsl:template match="message[@value='login_ok']" mode="message">
	Welcome
</xsl:template>

<xsl:template match="message[@value='set_up_email']" mode="message">
	Please, set up your E-Mail (you will get a Signup bonus).
</xsl:template>

<xsl:template match="message[@value='bad_login']" mode="message">
	Invalid credentials
</xsl:template>

<xsl:template match="message[@value='register_ok']" mode="message">
	Registration is successful. Welcome!
</xsl:template>

<xsl:template match="message[@value='login_busy']" mode="message">
	The Login is already registered
</xsl:template>

<xsl:template match="message[@value='passwords_dont_match']" mode="message">
	Password do not match Confirm Password
</xsl:template>

<xsl:template match="message[@value='bad_captcha']" mode="message">
	CAPTCHA mismatch
</xsl:template>

<xsl:template match="message[@value='email_confirmation_pending']" mode="message">
	E-Mail confirmation message has been sent, please check your mailbox and proceed according to the instructions.
</xsl:template>

<xsl:template match="message[@value='password_reset_fail']" mode="message">
	Reset Password failed (try <a href="mailto:support@advancedwebtesting.com">support request</a>)
</xsl:template>

<xsl:template match="message[@value='password_change_ok']" mode="message">
	Password has been changed
</xsl:template>

<xsl:template match="message[@value='bad_code']" mode="message">
	Invalid code (the session may expired)
</xsl:template>

<xsl:template match="message[@value='logout_ok']" mode="message">
	Goodbye
</xsl:template>

<xsl:template match="message[@value='password_change_fail']" mode="message">
	Change Password failed (please, try again later).
</xsl:template>

<xsl:template match="message[@value='bad_current_password']" mode="message">
	Invalid current password
</xsl:template>

<xsl:template match="message[@value='settings_change_ok']" mode="message">
	Settings has been changed
</xsl:template>

<xsl:template match="message[@value='settings_change_fail']" mode="message">
	Change settings failed
</xsl:template>

<xsl:template match="message[@value='email_change_fail']" mode="message">
	Change E-Mail failed
</xsl:template>

<xsl:template match="message[@value='email_change_ok']" mode="message">
	E-Mail has been changed
</xsl:template>

<xsl:template match="message[@value='delete_account_fail']" mode="message">
	Delete Account failed (please, try again later).
</xsl:template>

<xsl:template match="message[@value='delete_account_ok']" mode="message">
	Account has been deleted
</xsl:template>

<xsl:template match="message[@value='test_add_ok']" mode="message">
	Test has been added
</xsl:template>

<xsl:template match="message[@value='test_add_fail']" mode="message">
	Add Test failed
</xsl:template>

<xsl:template match="message[@value='test_delete_ok']" mode="message">
	Test has been deleted
</xsl:template>

<xsl:template match="message[@value='test_delete_fail']" mode="message">
	Delete Test failed
</xsl:template>

<xsl:template match="message[@value='bad_test_id']" mode="message">
	Invalid Test Id
</xsl:template>

<xsl:template match="message[@value='test_restore_ok']" mode="message">
	Test has been restored
</xsl:template>

<xsl:template match="message[@value='test_restore_fail']" mode="message">
	Restore Test failed
</xsl:template>

<xsl:template match="message[@value='test_rename_ok']" mode="message">
	Test has been renamed
</xsl:template>

<xsl:template match="message[@value='test_rename_fail']" mode="message">
	Rename Test failed
</xsl:template>

<xsl:template match="message[@value='test_copy_ok']" mode="message">
	Test has been copied
</xsl:template>

<xsl:template match="message[@value='test_copy_fail']" mode="message">
	Copy Test failed
</xsl:template>

<xsl:template match="message[@value='test_action_add_ok']" mode="message">
	Action has been added
</xsl:template>

<xsl:template match="message[@value='test_action_delete_ok']" mode="message">
	Action deleted
</xsl:template>

<xsl:template match="message[@value='test_action_delete_fail']" mode="message">
	Delete Action failed
</xsl:template>

<xsl:template match="message[@value='bad_action_id']" mode="message">
	Invalid Action Id
</xsl:template>

<xsl:template match="message[@value='test_action_modify_ok']" mode="message">
	Action has been modified
</xsl:template>

<xsl:template match="message[@value='test_action_modify_fail']" mode="message">
	Modify Action failed (perhaps invalid parameter)
</xsl:template>

<xsl:template match="message[@value='test_action_insert_ok']" mode="message">
	Action has been inserted
</xsl:template>

<xsl:template match="message[@value='test_action_insert_fail']" mode="message">
	Insert Action failed
</xsl:template>

<xsl:template match="message[@value='test_import_fail']" mode="message">
	Import Test failed (please, check the syntax).
</xsl:template>

<xsl:template match="message[@value='task_add_ok']" mode="message">
	Task has been added
</xsl:template>

<xsl:template match="message[@value='no_funds']" mode="message">
	Available Actions (Balance) are exhausted, please <a href="../?billing=1">Top Up</a>.
</xsl:template>

<xsl:template match="message[@value='test_is_deleted']" mode="message">
	Test has been deleted
</xsl:template>

<xsl:template match="message[@value='task_cancel_ok']" mode="message">
	Task has been canceled
</xsl:template>

<xsl:template match="message[@value='task_cancel_fail']" mode="message">
	Cancel Task failed
</xsl:template>

<xsl:template match="message[@value='bad_task_id']" mode="message">
	Invalid Task Id
</xsl:template>

<xsl:template match="message[@value='sched_add_ok']" mode="message">
	Schedule Job has been created
</xsl:template>

<xsl:template match="message[@value='sched_add_fail']" mode="message">
	Add Schedule Job failed (perhaps there is an empty string or null somewhere)
</xsl:template>

<xsl:template match="message[@value='sched_delete_ok']" mode="message">
	Schedule Job has been deleted
</xsl:template>

<xsl:template match="message[@value='sched_delete_fail']" mode="message">
	Delete Schedule Job failed
</xsl:template>

<xsl:template match="message[@value='bad_sched_id']" mode="message">
	Invalid Schedule Job Id
</xsl:template>

<xsl:template match="message[@value='sched_modify_ok']" mode="message">
	Schedule Job has been modified
</xsl:template>

<xsl:template match="message[@value='sched_modify_fail']" mode="message">
	Modify Schedule Job failed
</xsl:template>

<xsl:template match="message[@value='payment_pending']" mode="message">
	The payment has been staged, please proceed to payment system.
</xsl:template>

<xsl:template match="message[@value='top_up_fail']" mode="message">
	Top Up failed (please, try again later or try another payment system).
</xsl:template>

<xsl:template match="message[@value='bad_params']" mode="message">
	Invalid parameters (perhaps there is a null or empty string which is forbidden)
</xsl:template>

<xsl:template match="message[@value='refund_ok']" mode="message">
	Refunded.
	Come again!
</xsl:template>

<xsl:template match="message[@value='refund_fail']" mode="message">
	Refund failed (please, try again later or ask <a href="mailto:billing@advancedwebtesting.com">support</a>).
</xsl:template>

<xsl:template match="message[@value='cancel_pending_transaction_ok']" mode="message">
	Pending Transaction has been canceled
</xsl:template>

<xsl:template match="message[@value='cancel_pending_transaction_fail']" mode="message">
	Cancel Pending Transaction failed
</xsl:template>

<xsl:template match="message[@value='cancel_subscription_ok']" mode="message">
	Subscription has been canceled
</xsl:template>

<xsl:template match="message[@value='cancel_subscription_fail']" mode="message">
	Cancel Subscription failed (perhaps it has already been canceled or cancel of this subscription is forbidden)
</xsl:template>

<xsl:template match="message[@value='top_up_subscription_ok']" mode="message">
	Top Up by Subscription complete
</xsl:template>

<xsl:template match="message[@value='top_up_subscription_fail']" mode="message">
	Top Up by Subscription failed (please, check the <a href="../?billing=1">Transaction log</a>).
</xsl:template>

<xsl:template match="message[@value='modify_subscription_ok']" mode="message">
	Subscription has been modified
</xsl:template>

<xsl:template match="message[@value='modify_subscription_fail']" mode="message">
	Modification of Subscription failed (perhaps it is canceled by the payment system, invalid or modification is forbidden).
</xsl:template>

<xsl:template match="message[@value='paypal_ok']" mode="message">
	PayPal has been processed successfully (the transaction may be declined though, see the <a href="../?billing=1">Transactions log</a>).
</xsl:template>

<xsl:template match="message[@value='paypal_fail']" mode="message">
	PayPal processing failed
</xsl:template>

<xsl:template match="message[@value='bad_paypal_token']" mode="message">
	Invalid PayPal Token
</xsl:template>

<xsl:template match="message" mode="message">
	<xsl:value-of select="@value"/>
</xsl:template>

</xsl:stylesheet>
