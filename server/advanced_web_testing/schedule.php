<?php

namespace AdvancedWebTesting;

/**
 * Интерфейс планировщика
 * (View,) Controller (MVC)
 */
class Schedule {
	private $db;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		$schedMgr = new \AdvancedWebTesting\Schedule\Manager($this->db, null);
		$scheds = $schedMgr->ready();
		foreach ($scheds as $sched) {
			$userId = $sched['user_id'];
			$testId = $sched['data']['test_id'];
			$type = $sched['data']['type'];
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $userId);
			if ($tests = $testMgr->get([$testId]))
				$test = $tests[0];
			$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
			if ($taskId = $taskMgr->add($testId, $test['name'], $type)) {
				$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
				$histMgr->add('task_sched', ['task_id' => $taskId,
					'test_id' => $testId, 'test_name' => $test['name'], 'type' => $type,
					'sched_id' => $sched['id'], 'sched_name' => $sched['data']['name']]);
			}
		}
	}
}