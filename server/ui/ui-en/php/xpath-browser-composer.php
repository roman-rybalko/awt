<?php
header('Content-Type: text/javascript');
?>
(function() {
<?php
readfile('../js/jquery.min.js');
readfile('../js/messaging.js');
?>
var messaging = new Messaging("server");
messaging.ping();
<?php
readfile('../js/error-server.js');
readfile('../js/xpath-browser-server.js');
readfile('../js/xpath-composer-server.js');
?>
$.noConflict(true);
})();
