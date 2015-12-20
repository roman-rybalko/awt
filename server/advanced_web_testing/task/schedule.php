<?php

namespace AdvancedWebTesting\Task;

/**
 * Запуск тестов-задач по расписанию
 * Model (MVC)
 */
class Schedule {
	private $anacron, $db;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->anacron = new \WebConstructionSet\Database\Relational\Anacron($db, $userId, 'task_schedule');
		$this->db = $db;
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
		return $this->anacron->create($start, $period, [
			'test_id' => $testId, 'type' => $type, 'name' => $name
		]);
	}

	/**
	 * @param integer $schedId
	 * @param integer|null $start
	 * @param integer|null $period
	 * @param mixed|null $data
	 * @return boolean
	 */
	public function modify($schedId, $start = null, $period = null, $testId = null, $type = null, $name = null) {
		$data = null;
		if ($testId !== null || $type !== null || $name !== null)
			if ($data = $this->anacron->get([$schedId])) {
				$data = $data[0]['data'];
				if ($testId !== null)
					$data['test_id'] = $testId;
				if ($type !== null)
					$data['type'] = $type;
				if ($name !== null)
					$data['name'] = $name;
			}
		return $this->anacron->update($schedId, $start, $period, $data);
	}

	/**
	 * @param integer $schedId
	 * @return boolean
	 */
	public function delete($schedId) {
		return $this->anacron->delete($schedId);
	}

	/**
	 * @param [integer]|null $schedIds
	 * @return [][id => integer, start => integer, period => integer, test_id => string, type => string, name => string]
	 */
	public function get($schedIds = null) {
		$scheds = [];
		if ($data = $this->anacron->get($schedIds))
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
		$jobs = $this->anacron->ready();
		$jobs = $this->anacron->get($jobs);
		foreach ($jobs as $job) {
			$userId = $job['key'];
			$testId = $job['data']['test_id'];
			$type = $job['data']['type'];
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $userId);
			$tests = $testMgr->get([$testId]);
			if (!$tests) {
				$this->startFailReport($userId, 'bad_test_id', $testId, '_unknown_', $type, $job['id'], $job['data']['name']);
				continue;
			}
			$test = $tests[0];
			if ($test['deleted']) {
				$this->startFailReport($userId, 'test_is_deleted', $testId, $test['name'], $type, $job['id'], $job['data']['name']);
				continue;
			}
			$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $userId);
			if ($billMgr->getAvailableActionsCnt() < \AdvancedWebTesting\Billing\Price::TASK_START && !$billMgr->getSubscriptions()) {
				$this->startFailReport($userId, 'no_funds', $testId, $test['name'], $type, $job['id'], $job['data']['name']);
				continue;
			}
			$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
			$taskId = $taskMgr->add($testId, $test['name'], $type);
			if (!$taskId) {
				$this->startFailReport($userId, 'task_add_fail', $testId, $test['name'], $type, $job['id'], $job['data']['name']);
				continue;
			}
			$billMgr->startTask($taskId, $test['id'], $test['name'], $job['id'], $job['data']['name']);
			$statMgr = new \AdvancedWebTesting\Stats\Manager($this->db, $userId);
			$statMgr->add(1);
			$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
			$histMgr->add('task_sched', ['task_id' => $taskId,
				'test_id' => $testId, 'test_name' => $test['name'], 'type' => $type,
				'sched_id' => $job['id'], 'sched_name' => $job['data']['name']]);
		}
	}

	private function startFailReport($userId, $message, $testId, $testName, $type, $schedId, $schedName) {
		$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
		$histMgr->add('sched_fail', ['message' => $message,
			'test_id' => $testId, 'test_name' => $testName, 'type' => $type,
			'sched_id' => $schedId, 'sched_name' => $schedName]);
		$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $userId);
		$settings = $settMgr->get();
		if ($settings['email'] && $settings['task_fail_email_report']) {
			$mailMgr = new \AdvancedWebTesting\Mail\Manager($this->db, $userId);
			$mailMgr->schedFailReport($settings['email'], $testId, $testName, $schedId, $schedName, $message);
		}
	}
}
