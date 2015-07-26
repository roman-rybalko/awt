<?php

namespace AdvancedWebTesting;

class Task {
	private $db;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	/*
	 * Get & lock a task
	 * method: post
	 * params: task_type node_id token
	 *
	 * Update the task
	 * method: post
	 * params: task_id status=started vnc token
	 * params: task_id status=succeeded|failed descr scrn1 .. scrn{test_action_id} .. scrnXX token (enctype="multipart/form-data")
	 * descr = {
	 *   "task_id" : "xxx",
	 *   "test_id" : "xx",
	 *   "test_actions" : [
	 *     {
	 *       "type" : "xxxxx",
	 *       "selector" : "xxxxxx",
	 *       "data" : "xxx",
	 *       "test_action_id" : "xxxx",
	 *       "scrn_filename" : "xxxxxxxx",  // optional
	 *       "failed" : "fail descr"  // optional
	 *     },
	 *     ...
	 *   ]
	 * }
	 */

	public function run() {
		if (isset($_POST['task_type']))
			$this->lock();
		else if (isset($_POST['task_id']))
			$this->update();
	}

	private function lock() {
		$type = $_POST['task_type'];
		$db = $this->db;
		if ($this->checkAuth()) {
			while(true) {
				$tasks = $db->select('tasks', ['task_id', 'test_id'], ['status' => \AdvancedWebTesting\Task\Status::INITIAL, 'type' => $type]);
				if (!$tasks)
					break;
				foreach ($tasks as $task)
					if ($db->update('tasks', ['status' => \AdvancedWebTesting\Task\Status::STARTING], ['task_id' => $task['task_id'], 'status' => \AdvancedWebTesting\Task\Status::INITIAL])) {
						$taskId = $task['task_id'];
						$testId = $task['test_id'];
						break 2;
					}
			}
			if (isset($taskId)) {
				$db->update('tasks', ['data' => $_POST['node_id'], 'time' => time()], ['task_id' => $taskId]);
				$testActions = $db->select('test_actions', ['type', 'selector', 'data', 'test_action_id'], ['test_id' => $testId], 'order by test_action_id asc');
				$result = [
					'task_id' => $taskId,
					'test_id' => $testId,
					'test_actions' => $testActions
				];
			} else {
				$result = [
					'empty' => 1
				];
			}
		} else {
			$result = [
				'fail' => 'auth check failed'
			];
		}
		echo json_encode($result);
	}

	private function update() {
		$taskId = $_POST['task_id'];
		$status = $_POST['status'];
		$db = $this->db;
		if ($this->checkAuth()) {
			switch ($status) {
				case 'started':
					$vnc = $_POST['vnc'];
					if ($db->update('tasks', ['data' => $vnc, 'status' => \AdvancedWebTesting\Task\Status::RUNNING, 'time' => time()], ['task_id' => $taskId, 'status' => \AdvancedWebTesting\Task\Status::STARTING]))
						$result['ok'] = 1;
					else
						$result['fail'] = 'task update failed';
					break;
				case 'succeeded':
				case 'failed':
					if (is_uploaded_file($_FILES['descr']['tmp_name']))
						$descr = json_decode(file_get_contents($_FILES['descr']['tmp_name']), true /* assoc */);
					if (isset($descr) && $descr) {
						foreach ($descr['test_actions'] as $testAction)
							if (isset($testAction['scrn_filename']))
								if (!is_uploaded_file($_FILES['scrn' . $testAction['test_action_id']]['tmp_name'])) {
									$result['fail'] = 'scrn' . $testAction['test_action_id'] . ' upload failed';
									break;
								}
					} else
						$result['fail'] = 'descr parse failed';
					if (empty($result['fail'])) {
						$taskDataDir = $taskId . '-' . rand();
						if ($db->update('tasks', ['data' => $taskDataDir, 'status' => $status == 'succeeded' ? \AdvancedWebTesting\Task\Status::SUCCEEDED : \AdvancedWebTesting\Task\Status::FAILED, 'time' => time()], ['task_id' => $taskId, 'status' => \AdvancedWebTesting\Task\Status::RUNNING])) {
							$taskDataPath = \Config::$rootPath . \Config::RESULT_DATA_PATH . $taskDataDir . '/';
							$this->prepareTaskDataPath($taskDataPath);
							$result['ok'] = 0;
							$result['ok'] += move_uploaded_file($_FILES['descr']['tmp_name'], $taskDataPath . 'descr.json');
							foreach ($descr['test_actions'] as $testAction)
								if (isset($testAction['scrn_filename']))
									$result['ok'] += move_uploaded_file($_FILES['scrn' . $testAction['test_action_id']]['tmp_name'], $taskDataPath . $testAction['scrn_filename']);
						} else
							$result['fail'] = 'task update failed';
					}
					break;
				default:
					$result['fail'] = 'bad status';
					break;
			}
		} else {
			$result = [
				'fail' => 'auth check failed'
			];
		}
		echo json_encode($result);
	}

	private function checkAuth() {
		return $_POST['token'] == \Config::TESTNODE_TOKEN;
	}

	private function prepareTaskDataPath($path) {
		exec('rm -Rf ' . $path);
		mkdir($path);
	}
}