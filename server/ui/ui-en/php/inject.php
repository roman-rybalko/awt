<?php
require_once '../../../web_construction_set/autoload.php';
function mkurl($script) {
	echo \WebConstructionSet\Url\Tools::normalize(\WebConstructionSet\Url\Tools::getMyUrlPath() . '/../js/' . $script);
}
header('Content-Type: text/javascript');
?>
document.body.innerHTML += '
<script src="<?php mkurl("jquery.min.js"); ?>" type="text/javascript">
<script src="<?php mkurl("messaging.js"); ?>" type="text/javascript">
<script type="text/javascript">
	messaging.init('server');
	messaging.ping();
</script>
<script src="<?php mkurl("error-server.js"); ?>" type="text/javascript">	
<script src="<?php mkurl("xpath-browser-server.js"); ?>" type="text/javascript">	
<script type="text/javascript">
	messaging = undefined;
	error_handler = undefined;
	$.noConflict(true);
</script>
';
