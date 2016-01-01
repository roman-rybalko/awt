<?php

$url = 'https://pddimp.yandex.ru/api2/admin/dns/';

if (!isset($_POST['token']) || !isset($_POST['domain'])) {
?>
<html>
<head>
<title>DNS</title>
</head>
<body>
<form method="post">
Domain: <input name="domain" placeholder="domain"><br/>
Token: <input name="token" placeholder="token"><br/>
<input type="submit" value="Enter">
</form>
</body>
</html>
<?php
} else {
	$token = $_POST['token'];
	$domain = $_POST['domain'];
?>
<html>
<head>
<title><?php echo $domain; ?></title>
</head>
<body>
<?php
	function call($name, $params = [], $method = 'GET') {
		global $token;
		global $url;
		$callUrl = $url . $name;
		$options = [
				'http' => [
						'header' => "PddToken: $token\r\n",
						'method' => $method
				]
		];
		if ($method == 'POST') {
			$options['http']['header'] .= "Content-type: application/x-www-form-urlencoded\r\n";
			$options['http']['content'] = http_build_query($params);
		} else {
			$callUrl .= '?' . http_build_query($params);
		}
		$context = stream_context_create($options);
		$result = @file_get_contents($callUrl, false /* use include path */, $context);
		if ($result)
			$result = json_decode($result, true /* assoc */);
		return $result;
	}

	if (isset($_POST['add'])) {
		$result = call('add', $_POST, 'POST');
		echo '<pre>';
		print_r($result);
		echo '</pre>';
	}

	if (isset($_POST['edit'])) {
		$result = call('edit', $_POST, 'POST');
		echo '<pre>';
		print_r($result);
		echo '</pre>';
	}

	if (isset($_POST['delete'])) {
		$result = call('del', $_POST, 'POST');
		echo '<pre>';
		print_r($result);
		echo '</pre>';
	}

	$list = call('list', ['domain' => $domain]);
	$fieldNames = [];
	foreach ($list['records'] as $record)
		foreach (array_keys($record) as $name)
			$fieldNames[$name] = 1;
?>
<style>
tr:hover {
	background-color: #f5f5f5;
}
tr:hover td {
	border-top: 1px solid black;
	border-bottom: 1px solid black;
}
</style>
<table>
<tr>
<?php
	foreach ($fieldNames as $name => $value)
		echo '<th>', $name, '</th>';
?>
</tr>
<?php
	foreach ($list['records'] as $record) {
		echo '<tr><form method="post"><input type="hidden" name="token" value="', $token, '">';
		foreach (array_keys($fieldNames) as $name) {
			echo '<td>';
			if (isset($record[$name]))
				echo '<input type="text" name="', $name, '" value="', $record[$name], '">';
			echo '</td>';
		}
		echo '<td><input type="submit" name="edit" value="Edit"></td>';
		echo '<td><input type="submit" name="delete" value="Delete"></td>';
		echo '</form></tr>';
	}
	echo '<tr><form method="post"><input type="hidden" name="token" value="', $token, '">';
	foreach (array_keys($fieldNames) as $name)
		echo '<td><input type="text" name="', $name, '"', $name == 'domain' ? ' value="' . $domain . '"' : '', '></td>';
	echo '<td><input type="submit" name="add" value="Add"></td>';
	echo '</form></tr>';
?>
</table>
<pre>
<?php print_r($list); ?>
</pre>
</body>
</html>
<?php
}
