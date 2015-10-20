<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
function dump($descr, $table) {
	echo '<h3>', $descr, '</h3>';
	if (is_array($table)) {
		$keys = [];
		$keysCnt = 0;
		foreach ($table as $row)
			foreach (array_keys($row) as $key)
				if (!isset($keys[$key]))
					$keys[$key] = $keysCnt++;
		echo '<table>';
		echo '<tr>';
		$data = [];
		foreach ($keys as $value => $pos)
			$data[$pos] = $value;
		for ($i = 0; $i < $keysCnt; ++$i)
			if (isset($data[$i]))
				echo '<th>', $data[$i], '</th>';
			else
				echo '<th></th>';
		echo '</tr>';
		foreach ($table as $row) {
			echo '<tr>';
			$data = [];
			foreach ($row as $key => $value)
				$data[$keys[$key]] = $value;
			for ($i = 0; $i < $keysCnt; ++$i)
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
if (isset($_GET['user'])) {
	$billing = new \AdvancedWebTesting\Billing\Manager($db, $_GET['user']);
?>
<html><body>
<?php
	if (isset($_POST['service']))
		dump('Service Credit/Charge', $billing->service($_POST['actions_cnt'], $_POST['descr']));
?>
<form method="post">
<input type="text" name="actions_cnt" placeholder="Actions Cnt"><br>
<input type="text" name="descr" placeholder="Description"><br>
<input type="submit" name="service" value="Service Credit/Charge"><br>
</form>
<?php
	dump('Available Actions', $billing->getAvailableActionsCnt());
	$transactions = $billing->getTransactions();
	usort($transactions, function ($a, $b) {return $b['time']-$a['time'];});
	dump('Pending Transactions', $billing->getPendingTransactions());
	dump('Subscriptions', $billing->getSubscriptions());
	dump('Transactions', $transactions);
?>
</body></html>
<?php
} else {
?>
<html><body>
<pre>
USAGE:
	user=xxx - user Id
</pre>
<?php
	$userDb = new \WebConstructionSet\Database\Relational\User($db);
	dump('Users', $userDb->get());
}
?>
</body></html>