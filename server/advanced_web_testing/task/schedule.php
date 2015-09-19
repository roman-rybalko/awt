<?php

namespace AdvancedWebTesting\Task;

/**
 * Запуск тестов-задач по расписанию
 * Model (MVC)
 */
class Schedule {
	private $anacron, $db, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->anacron = new \WebConstructionSet\Database\Relational\Anacron($db, 'task_schedule');
		$this->db = $db;
		$this->userId = $userId;
	}

	/**
	 * @param integer $start
	 * @param integer $period
	 * @param unknown $testId
	 * @param unknown $type
	 * @param unknown $name
	 * @return integer schedId
	 */
	public function add($start, $period, $testId, $type, $name) {
		return $this->anacron->create(['start' => $start, 'period' => $period, 'data' => [
			'test_id' => $testId, 'type' => $type, 'name' => $name
		]], $this->userId);
	}

	/**
	 * @param integer $schedId
	 * @param integer|null $start
	 * @param integer|null $period
	 * @param mixed|null $data
	 * @return boolean
	 */
	public function modify($schedId, $start = null, $period = null, $testId = null, $type = null, $name = null) {
		$fields = [];
		if ($start !== null)
			$fields['start'] = $start;
		if ($period !== null)
			$fields['period'] = $period;
		if ($testId !== null || $type !== null || $name !== null)
			if ($data = $this->anacron->get([$schedId], $this->userId)) {
				$data = $data[0]['data'];
				if ($testId !== null)
					$data['test_id'] = $testId;
				if ($type !== null)
					$data['type'] = $type;
				if ($name !== null)
					$data['name'] = $name;
				$fields['data'] = $data;
			}
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
	 * @return [][id => integer, start => integer, period => integer, test_id => string, type => string, name => string]
	 */
	public function get($schedIds = null) {
		$scheds = [];
		if ($data = $this->anacron->get($schedIds, $this->userId))
			foreach ($data as $data1) {
				$sched = ['id' => $data1['id'], 'start' => $data1['start'], 'period' => $data1['period']];
				foreach ($data1['data'] as $name => $value)
					$sched[$name] = $value;
				$scheds[] = $sched;
			}
		return $scheds;
	}

	/**
	 * Проверить расписание и запустить задачи
	 */
	public function start() {
		$jobs = $this->anacron->ready($this->userId);
		foreach ($jobs as $job) {
			$userId = $job['key'];
			$testId = $job['data']['test_id'];
			$type = $job['data']['type'];
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $userId);
			if ($tests = $testMgr->get([$testId]))
				$test = $tests[0];
			else
				continue;
			if ($test['deleted'])
				continue;
			$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
			if ($taskId = $taskMgr->add($testId, $test['name'], $type)) {
				$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
				$histMgr->add('task_sched', ['task_id' => $taskId,
					'test_id' => $testId, 'test_name' => $test['name'], 'type' => $type,
					'sched_id' => $job['id'], 'sched_name' => $job['data']['name']]);
			}
		}
	}
}
