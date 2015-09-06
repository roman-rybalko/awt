<?php

namespace AdvancedWebTesting\Task\Action;

/**
 * Управление операциями задачи
 * Model (MVC)
 */
class Manager {
	private $db, $taskId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $taskId) {
		$this->db = $db;
		$this->taskId = $taskId;
	}

	/**
	 * Скопировать из теста
	 * @param integer $testId
	 * @return последний actionId
	 */
	public function import($testId) {
		$actionId = 0;
		$testActMgr = new \AdvancedWebTesting\Test\Action\Manager($this->db, $testId);
		$data = $testActMgr->get();
		usort($data, function($a,$b){return $a['id']-$b['id'];});
		foreach ($data as $data1) {
			$fields = ['task_id' => $this->taskId, 'action_id' => ++$actionId];
			foreach (['type', 'selector', 'data'] as $param)
				$fields[$param] = $data1[$param];
			if (!$this->db->insert('task_actions', $fields))
				throw new \ErrorException('Task action insert failed', null, null, __FILE__, __LINE__);
		}
		return $actionId;
	}

	/**
	 * Обновить
	 * @param integer $actionId
	 * @param string|null $scrn
	 * @param string|null $failed
	 * @return boolean
	 */
	public function update($actionId, $scrn, $failed) {
		$fields = [];
		if ($scrn !== null)
			$fields['scrn'] = $scrn;
		if ($failed !== null)
			$fields['failed'] = $failed;
		return $this->db->update('task_actions', $fields, ['task_id' => $this->taskId, 'action_id' => $actionId]);
	}

	/**
	 * @param [integer]|null $actionIds
	 * @return [][id => integer, type => string, selector => string|null, data => string|null, scrn => string|null, failed => boolean, succeeded => boolean]
	 */
	public function get($actionIds = null) {
		if ($tasks = $this->db->select('tasks', ['debug', 'status'], ['task_id' => $this->taskId]))
			$task = $tasks[0];
		$data = [];
		if ($actionIds === null)
			$data = $this->db->select('task_actions', ['type', 'selector', 'data', 'action_id', 'scrn', 'failed'], ['task_id' => $this->taskId]);
		else
			foreach ($actionIds as $actionId)
				if ($data1 = $this->db->select('task_actions', ['type', 'selector', 'data', 'action_id', 'scrn', 'failed'], ['task_id' => $this->taskId, 'action_id' => $actionId]))
					$data = array_merge($data, $data1);
		$actions = [];
		$failed = false;
		usort($data, function($a,$b){return $a['action_id']-$b['action_id'];});
		foreach ($data as $data1) {
			$action = [];
			foreach (['action_id' => 'id', 'type' => 'type', 'selector' => 'selector', 'data' => 'data', 'scrn' => 'scrn'] as $src => $dst)
				$action[$dst] = $data1[$src];
			if ($data1['failed']) {
				$action['failed'] = $data1['failed'];
				$failed = true;
				$action['succeeded'] = false;
			} else if (
				($task['status'] == \AdvancedWebTesting\Task\Status::SUCCEEDED
					|| $task['status'] == \AdvancedWebTesting\Task\Status::FAILED)
				&& ($task['debug'] || !$failed)
			) {
				$action['succeeded'] = true;
				$action['failed'] = false;
			} else {
				$action['succeeded'] = false;
				$action['failed'] = false;
			}
			$actions[] = $action;
		}
		return $actions;
	}
}
