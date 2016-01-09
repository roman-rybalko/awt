<?php
header('Content-Type: text/javascript');
?>
(function() {
<?php
readfile('../js/jquery.min.js');
echo "\n";
readfile('../js/messaging.js');
?>
var messaging = new Messaging("server");
messaging.ping();
<?php
readfile('../js/error-server.js');
echo "\n";
readfile('../js/xpath-browser-server.js');
echo "\n";
readfile('../js/xpath-composer-server.js');
?>
$.noConflict(true);
})();
