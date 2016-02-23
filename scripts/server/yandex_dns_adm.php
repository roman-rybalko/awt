<html>
<head>
<title>Yandex DNS Admin</title>
</head>
<body>
<?php
$domains = [
	['token' => 'JI7B3O737CYEXWRKTZX2MF5S4TNFSP6QFPLEFOWMCAI43HXQ4O4A', 'domain' => 'advancedwebtesting.com'],
	['token' => 'H2N23Q6M5L4LOR4XZQGPKNMIXD4JIG4SIQ5AXP2PTJMJ467POACA', 'domain' => 'advancedwebtesting.net'],
	['token' => 'OREAPN7WVS23GMH4HW3SOWZ7P6O4TWGJGTFSMJBT4L5HIRHAJZCQ', 'domain' => 'advancedwebtesting.org'],
	['token' => '2YP6IXLCVX2FU6BXWV4TNWL3W3RDJCP3OVGJ6E6FQ3OJAAFLMBXQ', 'domain' => 'advancedwebtesting.biz'],
	['token' => 'WPC623ER7AY7SNB6JT26BBQ6KC5VIPIUKJXSJEBOKQHBUCW24TZA', 'domain' => 'webautomation.biz'],
	['token' => 'D2TAKYJB4OKXREBDJGTUCXEMMTKYFFKHVP73U2P7KP7DHBL34K3Q', 'domain' => 'webautomation.ru'],
	['token' => 'H2NBHEINPDUKLAVAQ34EGP7GQY75B57TLGAK4RHPD3TVPHQWVJQQ', 'domain' => 'advancedwebtesting.ru'],
	['token' => 'C7ASDUGL6GNFTYP4C2HSMWRUT4776ASTFWGFT3WGEKUPCMS64POA', 'domain' => 'webmonit.ru'],
	['token' => 'PSSLQQY2PSIYFOFGRIQCH7BMSFLXJ4PJAIHGPW2C352ACMZWTG7A', 'domain' => 'webmonit.biz'],
	['token' => 'I2CWLIPKQCBMXWFW5OXLPUSA2BB3A6DPYPNBW3AOG2FZ7AICNIQQ', 'domain' => 'продвебтест.рф'],
	['token' => 'D6H5OA77SHAOD3G54NGHKQJJ7SH5JFPAOERF4FQGVMYWJOKDU55A', 'domain' => 'профвебтест.рф'],
	// ['token' => 'XXX', 'domain' => 'XXX', 'subdomain' => '@'],
];
foreach ($domains as $domain) {
?>
<form action="yandex_dns.php" method="post">
<input type="hidden" name="token" value="<?php echo $domain['token']; ?>">
<input type="submit" name="domain" value="<?php echo $domain['domain']; ?>">
</form>
<?php
}
?>
</body>
</html>