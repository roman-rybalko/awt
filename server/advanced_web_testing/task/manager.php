<?php

namespace AdvancedWebTesting\Task;

class Manager {
	private $db;

	public function __construct(\WebConstructionSet\Database\Relational $db) {
		$this->db = $db;
	}

	/**
	 * Создать новую задачу
	 * @param integer $userId
	 * @param integer $testId
	 * @param string $type
	 * @param boolean $debug
	 * @throws \ErrorException
	 * @return NULL|$taskId
	 */
	public function add($userId, $testId, $type = null, $debug = false) {
		$db = $this->db;
		if ($type === null) {
			$types = $db->select('task_types', ['name'], ['parent_type_id' => null]);
			$type = $types[0]['name'];
		}
		$taskId = null;
		if ($tests = $db->select('tests', ['name'], ['user_id' => $userId, 'test_id' => $testId, 'deleted' => null])) {
			$test = $tests[0];
			if ($taskId = $db->insert('tasks', ['user_id' => $userId, 'test_id' => $testId, 'test_name' => $test['name'], 'type' => $type, 'debug' => $debug, 'status' => -1, 'time' => time()])) {
				foreach ($db->select('test_actions', ['type', 'selector', 'data', 'action_id'], ['test_id' => $testId]) as $action) {
					$action['task_id'] = $taskId;
					if (!$db->insert('task_actions', $action))
						throw new \ErrorException('Action ' . $action['action_id'] . ' insert into task ' . $taskId . ' failed', null, null, __FILE__, __LINE__);
				}
				if (!$db->update('tasks', ['status' => \AdvancedWebTesting\Task\Status::INITIAL], ['task_id' => $taskId]))
					throw new \ErrorException('Task ' . $taskId . ' final update failed', null, null, __FILE__, __LINE__);
			} else
				throw new \ErrorException('Task insert failed', null, null, __FILE__, __LINE__);
		}
		return $taskId;
	}
}