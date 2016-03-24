<?php

namespace AdvancedWebTesting;

/**
 * Интерфейс selenium-клиента
 * View, Controller (MVC)
 */
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
	 * params: task_id status=started token
	 *
	 * method: post
	 * enctype: multipart/form-data
	 * params: task_id status=succeeded|failed [fail1 .. fail[action id] .. failXX] token
	 * files: [scrn1 .. scrn{action id} .. scrnXX]
	 */

	public function run() {
		header('Content-Type: application/json');
		if (isset($_POST['task_type']))
			$this->lock();
		else if (isset($_POST['task_id']))
			$this->update();
	}

	private function lock() {
		if ($this->checkAuth()) {
			$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, null);
			if ($task = $taskMgr->lock($_POST['task_type'], $_POST['node_id'])) {
				$result = ['task' => ['id' => $task['id']]];
				if ($task['debug'])
					$result['task']['debug'] = true;
				$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $task['id']);
				$data = $taskActMgr->get();
				$actions = [];
				foreach ($data as $data1) {
					$action = [];
					foreach (['id', 'type', 'selector', 'data'] as $param)
						$action[$param] = $data1[$param];
					if ($action['type'] == 'proxy')
						$this->setProxy($action);
					$actions[] = $action;
				}
				$result['task']['actions'] = $actions;
			} else {
				$result = [
					'empty' => true
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
		$nodeId = $_POST['node_id'];
		$status = $_POST['status'];
		$db = $this->db;
		if ($this->checkAuth()) {
			$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, null);
			switch ($status) {
				case 'running':
					if ($taskMgr->run($taskId, $nodeId))
						$result['ok'] = 1;
					else
						$result['fail'] = 'task update failed';
					break;
				case 'succeeded':
				case 'failed':
					$taskDataDir = $taskId . '-' . rand();
					$statusId = $status == 'succeeded' ? \AdvancedWebTesting\Task\Status::SUCCEEDED : \AdvancedWebTesting\Task\Status::FAILED;
					if ($taskMgr->finish($taskId, $nodeId, $statusId, $taskDataDir)) {
						$taskDataPath = \Config::$rootPath . \Config::RESULTS_PATH . $taskDataDir . '/';
						$this->prepareTaskDataPath($taskDataPath);
						$result['ok'] = 1;
						$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $taskId);
						foreach ($taskActMgr->get() as $action) {
							$scrnX = 'scrn' . $action['id'];
							if (isset($_FILES[$scrnX])) {
								$scrnFilename = basename($_FILES[$scrnX]['name']);
								if (move_uploaded_file($_FILES[$scrnX]['tmp_name'], $taskDataPath . $scrnFilename)) {
									$result['ok'] += 1;
								} else {
									error_log('Bad screenshot, task_id: ' . $taskId . ', name: ' . $_FILES[$scrnX]['name'] . ', tmp_name: ' . $_FILES[$scrnX]['tmp_name'] . ', size: ' . $_FILES[$scrnX]['size']);
									unset($_FILES[$scrnX]);
								}
							}
							$failX = 'fail' . $action['id'];
							$result['ok'] += $taskActMgr->update($action['id'],
								isset($_FILES[$scrnX]) ? $scrnFilename : null,
								isset($_POST[$failX]) ? $_POST[$failX] : null);
						}
						$userId = $taskMgr->getUserId($taskId);
						$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $userId);
						$settings = $settMgr->get();
						if ($settings['email'] && ($settings['task_fail_email_report'] || $settings['task_success_email_report'])) {
							$mailMgr = new \AdvancedWebTesting\Mail\Manager($this->db, $userId);
							if ($status == 'failed' && $settings['task_fail_email_report'])
								$mailMgr->taskReport($settings['email'], $taskId);
							if ($status == 'succeeded' && $settings['task_success_email_report'])
								$mailMgr->taskReport($settings['email'], $taskId);
							if ($status == 'failed' && $settings['task_fail_emails']) {
								foreach (preg_split('/\s+/', $settings['task_fail_emails']) as $email) {
									if ($email) {
										$mailMgr->taskReport($email, $taskId);
									}
								}
							}
							if ($status == 'succeeded' && $settings['task_success_emails']) {
								foreach (preg_split('/\s+/', $settings['task_success_emails']) as $email) {
									if ($email) {
										$mailMgr->taskReport($email, $taskId);
									}
								}
							}
						}
						$actExecCnt = 0;
						foreach ($taskActMgr->get() as $action)
						if ($action['failed'] || $action['succeeded'])
							++$actExecCnt;
						$statsMgr = new \AdvancedWebTesting\Stats\Manager($this->db, $userId);
						$statsMgr->add(0, 1, $statusId == \AdvancedWebTesting\Task\Status::FAILED ? 1 : 0, $actExecCnt);
						$taskMgr1 = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
						if ($tasks = $taskMgr1->get([$taskId]))
							$task = $tasks[0];
						$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $userId);
						$billMgr->finishTask($taskId, $task['test_id'], $task['test_name'], $actExecCnt);
					} else
						$result['fail'] = 'task update failed';
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

	private function setProxy(&$action) {
		if ($action['type'] == 'proxy') {
			if (isset(\Config::$proxy[$action['selector']])) {
				if (\Config::$proxy[$action['selector']])
					$action['data'] = \Config::$proxy[$action['selector']];
			} else
				$action['data'] = \Config::$proxy['default'];
		}
	}
}