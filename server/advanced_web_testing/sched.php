<?php

namespace AdvancedWebTesting;

class Sched {
	private $db, $anacronDb, $taskMgr;

	public function __construct() {
		$db = $this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
		$this->anacronDb = new \WebConstructionSet\Database\Relational\Anacron($db);
		$this->taskMgr = new \AdvancedWebTesting\Task\Manager($db);
	}

	public function run() {
		$db = $this->db;
		$anacron = $this->anacronDb;
		$mgr = $this->taskMgr;
		$tasks = $anacron->ready(null);
		foreach ($tasks as $task) {
			$userId = $task['key'];
			$testId = $task['data']['test_id'];
			$type = $task['data']['type'];
			if ($taskId = $mgr->add($userId, $testId, $type))
				error_log('task ' . $taskId . ' for test ' . $testId . ' user ' . $userId . ' created');
			else
				error_log('task for test ' . $testId . ' user ' . $userId . ' create failed');
		}
	}
}