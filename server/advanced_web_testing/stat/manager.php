<?php

namespace AdvancedWebTesting\Stat;

/**
 * Статистика
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$fields = [];
		if ($userId !== null)
			$fields['user_id'] = $userId;
		$this->table = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'stats', $fields);
	}

	public function add($tasks_added = 0, $tasks_finished = 0,  $tasks_failed = 0, $actions_executed = 0, $time = null) {
		if ($time === null)
			$time = time();
		$time -= $time % 3600;
		foreach (['tasks_added' => $tasks_added, 'tasks_finished' => $tasks_finished, 'tasks_failed' => $tasks_failed,
			'actions_executed' => $actions_executed] as $field => $count)
		{
			while ($count)
				if ($data = $this->table->select([$field], ['time' => $time])) {
					if ($this->table->update([$field => $data[0][$field] + $count], ['time' => $time, $field => $data[0][$field]]))
						break;
				} else {
					if ($this->table->insert([$field => $count, 'time' => $time]))
						break;
				}
		}
	}

	/**
	 * @return [][time => integer, tasks => integer, tasks_failed => integer, actions_executed => integer]
	 */
	public function get() {
		$data = $this->table->select();
		return $data;
	}

	/**
	 * Удаляет старые записи из БД
	 * @param integer $time UnixTime старше которого удалить
	 */
	public function clear($time = 0) {
		return $this->table->delete(['time' => $this->table->predicate('less', $time)]);
	}
}
