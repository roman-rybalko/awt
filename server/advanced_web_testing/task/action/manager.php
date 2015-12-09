<?php

namespace AdvancedWebTesting\Task\Action;

/**
 * Управление операциями задачи
 * Model (MVC)
 */
class Manager {
	private $actions, $tasks;

	public function __construct(\WebConstructionSet\Database\Relational $db, $taskId) {
		$this->actions = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'task_actions', ['task_id' => $taskId]);
		$this->tasks = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'tasks', ['task_id' => $taskId]);
	}

	/**
	 * @param [][id => integer, type => string, selector => string|null, data => string|null] $actions
	 * @throws \ErrorException
	 * @return Последний actionId
	 */
	public function import($actions) {
		$actionId = 0;
		usort($actions, function($a,$b){return $a['id']-$b['id'];});
		foreach ($actions as $action) {
			$fields = ['action_id' => ++$actionId];
			foreach (['type', 'selector', 'data'] as $param)
				$fields[$param] = $action[$param];
			if (!$this->actions->insert($fields))
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
		if (!$fields)
			return false;
		return $this->actions->update($fields, ['action_id' => $actionId]);
	}

	/**
	 * @param [integer]|null $actionIds
	 * @return [][id => integer, type => string, selector => string|null, data => string|null, scrn => string|null, failed => boolean, succeeded => boolean]
	 */
	public function get($actionIds = null) {
		if ($tasks = $this->tasks->select(['debug', 'status']))
			$task = $tasks[0];
		$data = [];
		if ($actionIds === null)
			$data = $this->actions->select(['type', 'selector', 'data', 'action_id', 'scrn', 'failed']);
		else
			foreach ($actionIds as $actionId)
				if ($data1 = $this->actions->select(['type', 'selector', 'data', 'action_id', 'scrn', 'failed'], ['action_id' => $actionId]))
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


	/**
	 * Получить данные для удаления но не удаляет их
	 * @return [scrn => string]
	 */
	public function clear1() {
		return $this->actions->select(['scrn'], []);
	}

	/**
	 * Очищает БД
	 */
	public function clear2() {
		return $this->actions->delete([]);
	}
}
