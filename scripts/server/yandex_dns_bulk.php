<html>
<head>
<title>Yandex DNS Bulk Update</title>
</head>
<body>
<?php

$url = 'https://pddimp.yandex.ru/api2/admin/dns/';
$domains = [
	['token' => 'JI7B3O737CYEXWRKTZX2MF5S4TNFSP6QFPLEFOWMCAI43HXQ4O4A', 'domain' => 'advancedwebtesting.com', 'subdomain' => '@'],
	['token' => 'H2N23Q6M5L4LOR4XZQGPKNMIXD4JIG4SIQ5AXP2PTJMJ467POACA', 'domain' => 'advancedwebtesting.net', 'subdomain' => '@'],
	['token' => 'OREAPN7WVS23GMH4HW3SOWZ7P6O4TWGJGTFSMJBT4L5HIRHAJZCQ', 'domain' => 'advancedwebtesting.org', 'subdomain' => '@'],
	['token' => '2YP6IXLCVX2FU6BXWV4TNWL3W3RDJCP3OVGJ6E6FQ3OJAAFLMBXQ', 'domain' => 'advancedwebtesting.biz', 'subdomain' => '@'],
	['token' => 'WPC623ER7AY7SNB6JT26BBQ6KC5VIPIUKJXSJEBOKQHBUCW24TZA', 'domain' => 'webautomation.biz', 'subdomain' => '@'],
	['token' => 'D2TAKYJB4OKXREBDJGTUCXEMMTKYFFKHVP73U2P7KP7DHBL34K3Q', 'domain' => 'webautomation.ru', 'subdomain' => '@'],
	['token' => 'H2NBHEINPDUKLAVAQ34EGP7GQY75B57TLGAK4RHPD3TVPHQWVJQQ', 'domain' => 'advancedwebtesting.ru', 'subdomain' => '@'],
	['token' => 'C7ASDUGL6GNFTYP4C2HSMWRUT4776ASTFWGFT3WGEKUPCMS64POA', 'domain' => 'webmonit.ru'],
	['token' => 'PSSLQQY2PSIYFOFGRIQCH7BMSFLXJ4PJAIHGPW2C352ACMZWTG7A', 'domain' => 'webmonit.biz'],
	['token' => 'I2CWLIPKQCBMXWFW5OXLPUSA2BB3A6DPYPNBW3AOG2FZ7AICNIQQ', 'domain' => 'продвебтест.рф'],
	['token' => 'D6H5OA77SHAOD3G54NGHKQJJ7SH5JFPAOERF4FQGVMYWJOKDU55A', 'domain' => 'профвебтест.рф'],
	// ['token' => 'XXX', 'domain' => 'XXX', 'subdomain' => '@'],
];
$types = ['A', 'AAAA'];

function call($token, $name, $params = [], $method = 'GET') {
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

$info = [];

if (isset($_POST['update'])) {
	$fail = false;
	foreach ($types as $type)
		if (empty($_POST[$type])) {
			echo '<h1>Param ', $type, ' is empty</h1>';
			$fail = true;
		}
	foreach ($domains as &$domain) {
		$result = call($domain['token'], 'list', ['domain' => $domain['domain']]);
		if (isset($result['error'])) {
			$info[] = $result;
			echo '<h1>', $result['error'], '</h1>';
			$fail = true;
		}
		$domain['records'] = $result['records'];
	}
	if (!$fail)
		foreach ($domains as $domain)
			foreach ($types as $type) {
				$record_id = 0;
				foreach ($domain['records'] as $record)
					if ($record['subdomain'] == $domain['subdomain'] && $record['type'] == $type) {
						$record_id = $record['record_id'];
						break;
					}
				if ($record_id)
					$result = call($domain['token'], 'edit', ['domain' => $domain['domain'], 'record_id' => $record_id, 'content' => $_POST[$type]], 'POST');
				else
					$result = call($domain['token'], 'add', ['domain' => $domain['domain'], 'type' => $type, 'content' => $_POST[$type]], 'POST');
				$info[] = $result;
				if (isset($result['error'])) {
					echo '<h1>', $result['error'], '</h1>';
				}
			}
}

?>
<form method="post">
<?php
foreach ($types as $type)
	echo '<b>', $type, '</b>: <input name="', $type, '"><br/>';
?>
<input type="submit" name="update" value="Update">
</form>
<pre>
<?php if ($info) print_r($info); ?>
</pre>
</body>
</html>