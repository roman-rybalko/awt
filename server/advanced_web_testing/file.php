<?php

namespace AdvancedWebTesting;

/**
 * Генерация файлов (attachments)
 * View, Controller (MVC)
 */
class File {
	private $db, $userId;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		$user = new \WebConstructionSet\Accounting\User($userDb);
		$this->userId = $user->getId();
	}

	public function run() {
		if ($this->userId) {
			if (isset($_GET['test'])) {
				$this->test();
			} else if (isset($_GET['billing'])) {
				$this->billing();
			} else {
				header('Content-Type: text/plain');
?>
Test
method: get
params: test

Billing
method: get
params: billing [time]
<?php
			}
		}
	}

	private function test() {
		$testId = $_GET['test'];
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		if ($tests = $testMgr->get([$testId])) {
			$test = $tests[0];
			$testActMgr = new \AdvancedWebTesting\Test\Action\Manager($this->db, $testId);
			header('Content-Type: application/json');
			header('Content-Disposition: attachment; filename="' . $test['name'] . '.json"');
			echo json_encode($testActMgr->get(), JSON_PRETTY_PRINT);
		} else {
			http_response_code(404);
			header('Content-Type: text/plain');
			echo 'bad_test_id';
		}
	}

	private function billing() {
		if (isset($_GET['time']))
			$time = $_GET['time'];
		else
			$time = 0;
		$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $this->userId);
		header('Content-Type: text/csv');
		header('Content-Disposition: attachment; filename="billing.csv"');
		echo 'ID;Time;Unix Timestamp;Balance Before;Balance After;Charge/Credit;Transaction Type;Transaction Data;Task URL;Task ID;Test Name;',
			'Schedule Job URL;Schedule Job ID;Schedule Job Name;Payment Type;Payment Amount;Payment Data;Refundable;',
			"\n";
		$billMgr->getTransactions(null, $time, function($transaction) {
			foreach (['id', 'time', 'actions_before', 'actions_after', 'actions_cnt', 'type', 'data', 'task_id', 'test_name',
				'sched_id', 'sched_name', 'payment_type', 'payment_amount', 'payment_data', 'refundable'] as $name)
			{
				if (isset($transaction[$name]))
					$value = $transaction[$name];
				else
					$value = null;
				if ($name == 'time') {
					if ($value !== null) {
						echo date(DATE_W3C, $value), ';';
						echo $value, ';';
					} else
						echo ';;';
				} else if ($name == 'type') {
					if ($value !== null)
						echo \AdvancedWebTesting\Billing\TransactionType::toString($value), ';';
					else
						echo ';';
				} else if ($name == 'task_id') {
					if ($value !== null) {
						echo '=HYPERLINK("' . \WebConstructionSet\Url\Tools::getMyUrlPath() . '?task=' . $value . '")', ';';
						echo $value, ';';
					} else
						echo ';;';
				} else if ($name == 'sched_id') {
					if ($value !== null) {
						echo '=HYPERLINK("' . \WebConstructionSet\Url\Tools::getMyUrlPath() . '?schedule=1#' . $value . '")', ';';
						echo $value, ';';
					} else
						echo ';;';
				} else if ($name == 'payment_type') {
					if ($value !== null)
						echo \AdvancedWebTesting\Billing\PaymentType::toString($value), ';';
					else
						echo ';';
				} else if ($name == 'refundable') {
					if ($value)
						echo 'yes;';
					else
						echo 'no;';
				} else {
					if ($value !== null)
						echo str_replace(';', '\;', $value), ';';
					else
						echo ';';
				}
			}
			echo "\n";
		});
	}
}