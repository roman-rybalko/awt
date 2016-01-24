<?php

namespace AdvancedWebTesting\User;

class Task {
	private $db, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->db = $db;
		$this->userId = $userId;
	}

	/**
	 * @param integer $taskId
	 * @return string XML
	 */
	public function get($taskId) {
		$xml = '';
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $this->userId);
		if ($tasks = $taskMgr->get([$taskId])) {
			$task = $tasks[0];
			$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $taskId);
			$xml .= '<task id="' . $taskId . '" test_id="' . $task['test_id'] . '" test_name="' . htmlspecialchars($task['test_name']) . '"'
				. ' ' . ($task['debug'] ? ' debug="1"' : '') . ' type="' . $task['type'] . '" time="' . $task['time'] . '"'
				. ' status="' . \AdvancedWebTesting\Task\Status::toString($task['status']) . '">';
			foreach ($taskActMgr->get() as $action) {
				$xml .= '<action id="' . $action['id'] . '" type="' . htmlspecialchars($action['type']) . '"';
				foreach (['selector', 'data'] as $param)
					if ($action[$param] !== null)
						$xml .= ' ' . $param . '="' . htmlspecialchars($action[$param]) . '"';
					if ($action['scrn'])
						$xml .= ' scrn="' . $task['result'] . '/' . $action['scrn'] . '"';
					if ($action['failed'])
						$xml .= ' failed="' . htmlspecialchars($action['failed']) . '"';
					if ($action['succeeded'])
						$xml .= ' succeeded="1"';
					$xml .= '/>';
			}
			$xml .= '</task>';
		} else {
			$xml .= '<message type="error" value="bad_task_id" code="72"/>';
			$xml .= '<task/>';
		}
		return $xml;
	}
}