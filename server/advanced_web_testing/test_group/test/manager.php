<?php

namespace AdvancedWebTesting\TestGroup\Test;

/**
 * Управление тестами в группе
 * Model (MVC)
 */
class Manager {
	private $tgTests, $testGroups;

	public function __construct(\WebConstructionSet\Database\Relational $db, $testGrpId) {
		$this->tgTests = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'tg_tests', ['test_group_id' => $testGrpId]);
		$this->testGroups = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'test_groups', ['test_group_id' => $testGrpId]);
	}

	/**
	 * Добавить
	 * @param integer $testId
	 * @param string $testName
	 * @param string $taskType
	 * @return integer tgTestId
	 */
	public function add($testId, $testName, $taskType) {
		$tgTestId = $this->tgTests->insert(['test_id' => $testId, 'test_name' => $testName, 'task_type' => $taskType]);
		if ($tgTestId <= 0)
			return 0;
		$this->testGroups->update(['time' => time()], []);
		return $tgTestId;
	}

	/**
	 * Удалить
	 * @param integer $tgTestId
	 * @return boolean
	 */
	public function delete($tgTestId) {
		if ($result = $this->tgTests->delete(['tg_test_id' => $tgTestId]))
			$this->testGroups->update(['time' => time()], []);
		return $result;
	}

	/**
	 * @param [][test_id => integer, test_name => string, task_type => string]
	 * @return integer count
	 */
	public function import($tgTests) {
		if (!is_array($tgTests))
			return -11;
		foreach ($tgTests as $tgTest) {
			if (!isset($tgTest['test_id']))
				return -2;
			if (!isset($tgTest['test_name']))
				return -3;
			if (!isset($tgTest['task_type']))
				return -4;
		}
		$cnt = 0;
		foreach ($tgTests as $tgTest) {
			if ($this->tgTests->insert(['test_id' => $tgTest['test_id'], 'test_name' => $tgTest['test_name'], 'task_type' => $tgTest['task_type']]) > 0)
				++$cnt;
		}
		return $cnt;
	}

	/**
	 * Получить
	 * @param [integer]|null $tgTestIds null - все
	 * @return [][id => integer, test_id => integer, test_name => string, task_type => string]
	 */
	public function get($tgTestIds = null) {
		$fields = ['tg_test_id', 'test_id', 'test_name', 'task_type'];
		$data = [];
		if ($tgTestIds === null)
			$data = $this->tgTests->select($fields);
		else
			foreach ($tgTestIds as $tgTestId)
				if ($data1 = $this->tgTests->select($fields, ['tg_test_id' => $tgTestId]))
					$data = array_merge($data, $data1);
		$tgTests = [];
		foreach ($data as $data1) {
			$tgTest = [];
			foreach (['tg_test_id' => 'id', 'test_id' => 'test_id', 'test_name' => 'test_name', 'task_type' => 'task_type'] as $src => $dst)
				$tgTest[$dst] = $data1[$src];
			$tgTests[] = $tgTest;
		}
		return $tgTests;
	}

	/**
	 * Удалить все
	 */
	public function clear() {
		$cnt = $this->tgTests->delete([]);
		if ($cnt)
			$this->testGroups->update(['time' => time()], []);
		return $cnt;
	}
}