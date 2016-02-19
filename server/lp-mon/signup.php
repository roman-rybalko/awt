<?php
$data = [
	'site: ' . $_POST['site'],
	'email: ' . $_POST['email'],
	'phone: ' . $_POST['phone'],
	'name: ' . $_POST['name'],
	'ip: ' . $_SERVER['REMOTE_ADDR'] . ':' . $_SERVER['REMOTE_PORT'],
	'ua: ' . $_SERVER['HTTP_USER_AGENT']
];
$headers = [
	'Content-Type: text/plain; charset=utf8',
	'MIME-Version: 1.0'
];
if (!mail('customer@webmonit.ru', 'New customer: ' . $_POST['site'], implode("\r\n", $data), implode("\r\n", $headers)))
	throw new ErrorException(implode(', ', $data));
?>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf8">
	<meta charset="utf8">
</head>
<body>
	<h1>
		Заявка принята. Ожидайте.
	</h1>
</body>
</html>