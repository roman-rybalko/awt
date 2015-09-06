<?php

namespace AdvancedWebTesting;

class Sched {
	private $anacron, $taskMgr, $history, $testMgr;

	public function __construct() {
		$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
		$this->anacron = new \WebConstructionSet\Database\Relational\Anacron($db);
		$this->taskMgr = new \AdvancedWebTesting\Task\Manager($db);
		$this->history = new \WebConstructionSet\Database\Relational\History($db);
		$this->testMgr = new \AdvancedWebTesting\Test\Manager($db);
	}

	public function run() {
		$tasks = $this->anacron->ready(null);
		foreach ($tasks as $task) {
			$userId = $task['key'];
			$testId = $task['data']['test_id'];
			$type = $task['data']['type'];
			if ($taskId = $this->taskMgr->add($userId, $testId, $type))
				$this->history->add('task_sched', ['task_id' => $taskId,
					'test_id' => $testId, 'test_name' => $this->testMgr->id2name($testId), 'type' => $type,
					'sched_id' => $task['id'], 'sched_name' => $task['data']['name']], $userId);
		}
	}
}