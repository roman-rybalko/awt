<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
$pp = new \WebConstructionSet\Billing\Paypal($db, \Config::PAYPAL_USER, \Config::PAYPAL_PASSWORD, \Config::PAYPAL_SIGNATURE, \Config::PAYPAL_SANDBOX);
function dump($table) {
	if (is_array($table)) {
		$keys = [ ];
		$keysCnt = 0;
		foreach ($table as $row)
			foreach (array_keys($row) as $key)
				if (! isset($keys[$key]))
					$keys[$key] = $keysCnt ++;
		echo '<table>';
		echo '<tr>';
		$data = [ ];
		foreach ($keys as $value => $pos)
			$data[$pos] = $value;
		for($i = 0; $i < $keysCnt; ++ $i)
			if (isset($data[$i]))
				echo '<th>', $data[$i], '</th>';
			else
				echo '<th></th>';
		echo '</tr>';
		foreach ($table as $row) {
			echo '<tr>';
			$data = [ ];
			foreach ($row as $key => $value)
				$data[$keys[$key]] = $value;
			for($i = 0; $i < $keysCnt; ++ $i)
				if (isset($data[$i]))
					echo '<td>', is_scalar($data[$i]) ? $data[$i] : var_dump($data[$i]), '</td>';
				else
					echo '<td></td>';
			echo '</tr>';
		}
		echo '</table>';
	} else {
		var_dump($table);
	}
}
?>
<html>
<head>
<meta charset="utf8">
</head>
<body>
<h3>Transactions:</h3>
<?php dump($pp->getTransactions()); ?>
<h3>Subscriptions:</h3>
<?php dump($pp->getSubscriptions()); ?>
<h3>Log:</h3>
<?php
$log = $pp->getLog();
usort($log, function($a,$b){return $b['time']-$a['time'];});
dump($log);
?>
</body>
</html>