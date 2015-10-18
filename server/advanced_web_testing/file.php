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
			} else {
				header('Content-Type: text/plain');
?>
Test
method: get
params: test
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
}