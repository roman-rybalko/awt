<?php

namespace AdvancedWebTesting\History;

/**
 * Лог
 * Model (MVC)
 */
class Manager {
	private $history;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->history = new \WebConstructionSet\Database\Relational\History($db, $userId);
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * @return boolean
	 */
	public function add($name, $data) {
		return $this->history->add($name, $data);
	}

	/**
	 * @param integer $time Unix Time, с какого времени вернуть данные, по-умолчанию 0 т.е. все данные
	 * @return [][time => integer, name => string, data => mixed, user_id => integer]
	 */
	public function get($time = 0) {
		$events = [];
		$data = $this->history->get($time);
		foreach ($data as $data1) {
			$event = [];
			foreach (['key' => 'user_id', 'time' => 'time', 'name' => 'name', 'data' => 'data'] as $src => $dst)
				$event[$dst] = $data1[$src];
			$events[] = $event;
		}
		return $events;
	}
}
