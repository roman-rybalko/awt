document.body.innerHTML += '
<script src="en-us/js/jquery.min.js" type="text/javascript">
<script src="en-us/js/messaging.js" type="text/javascript">
<script type="text/javascript">
	messaging.init('server');
	messaging.ping();
</script>
<script src="en-us/js/error-server.js" type="text/javascript">	
<script type="text/javascript">
	messaging = undefined;
	error_handler = undefined;
	$.noConflict(true);
</script>
';

