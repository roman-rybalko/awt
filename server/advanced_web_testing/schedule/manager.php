<?php

namespace AdvancedWebTesting\Schedule;

/**
 * Планировщик
 * Model (MVC)
 */
class Manager {
	private $anacron, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->anacron = new \WebConstructionSet\Database\Relational\Anacron($db);
		$this->userId = $userId;
	}

	/**
	 * @param integer $start
	 * @param integer $period
	 * @param mixed $data
	 * @return integer taskId
	 */
	public function add($start, $period, $data) {
		return $this->anacron->create(['start' => $start, 'period' => $period, 'data' => $data], $this->userId);
	}

	/**
	 * @param integer $schedId
	 * @param integer|null $start
	 * @param integer|null $period
	 * @param mixed|null $data
	 * @return boolean
	 */
	public function modify($schedId, $start, $period, $data) {
		$fields = [];
		if ($start !== null)
			$fields['start'] = $start;
		if ($period !== null)
			$fields['period'] = $period;
		if ($data !== null)
			$fields['data'] = $data;
		return $this->anacron->update($schedId, $fields, $this->userId);
	}

	/**
	 * @param integer $schedId
	 * @return boolean
	 */
	public function delete($schedId) {
		return $this->anacron->delete($schedId, $this->userId);
	}

	/**
	 * @param [integer]|null $schedIds
	 * @return [][id => integer, start => integer, period => integer, data => mixed]
	 */
	public function get($schedIds = null) {
		return $this->anacron->get($schedIds, $this->userId);
	}

	/**
	 * @return [][id => integer, data => mixed, user_id => integer]
	 */
	public function ready() {
		$scheds = [];
		$data = $this->anacron->ready($this->userId);
		foreach ($data as $data1) {
			$sched = [];
			foreach (['key' => 'user_id', 'id' => 'id', 'data' => 'data'] as $src => $dst)
				$sched[$dst] = $data1[$src];
			$scheds[] = $sched;
		}
		return $scheds;
	}
}
