<?php
header('Content-Type: text/javascript');
echo "\n";
readfile('../js/jquery.min.js');
echo "\n";
readfile('../js/messaging.js');
?>
var _awt_messaging = new Messaging("server");
_awt_messaging.ping();
<?php
readfile('../js/error-server.js');
echo "\n";
readfile('../js/xpath-browser-server.js');
echo "\n";
readfile('../js/xpath-composer-server.js');
echo "\n";
?>
$.noConflict(true);
