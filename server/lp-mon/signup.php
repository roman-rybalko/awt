<?php
$data = ['site: ' . $_POST['site'], 'email: ' . $_POST['email'], 'phone: ' . $_POST['phone'], 'name: ' . $_POST['name']];
if (!mail('customer@webmonit.ru', 'New customer: ' . $_POST['site'], implode("\r\n", $data)))
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