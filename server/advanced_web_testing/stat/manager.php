<?php

namespace AdvancedWebTesting\Stat;

/**
 * Статистика
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->table = new \WebConstructionSet\Database\TableWrapper($db, 'stats', ['user_id' => $userId]);
	}

	public function add($tasks_finished = 0,  $tasks_failed = 0, $task_actions_executed = 0, $time = null) {
		if ($time === null)
			$time = time();
		$time -= $time % 3600;
		foreach (['tasks_finished' => $tasks_finished, 'tasks_failed' => $tasks_failed, 'task_actions_executed' => $task_actions_executed] as $field => $count)
			while ($count)
				if ($data = $this->table->select([$field], ['time' => $time])) {
					if ($this->table->update([$field => $data[0][$field] + $count], ['time' => $time, $field => $data[0][$field]]))
						break;
				} else {
					if ($this->table->insert([$field => $count, 'time' => $time]))
						break;
				}
	}

	/**
	 * @return [][time => integer, tasks => integer, tasks_failed => integer, task_actions_executed => integer]
	 */
	public function get() {
		$data = $this->table->select();
		if (!$data)
			$data = [];
		return $data;
	}

	public function clear($time = 0) {
		return $this->table->delete(['time' => $this->table->predicate('less', $time)]);
	}
}
