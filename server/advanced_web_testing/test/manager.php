<?php

namespace AdvancedWebTesting\Test;

/**
 * Управление тестами
 * Model (MVC)
 */
class Manager {
	private $table, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->table = new \WebConstructionSet\Database\TableWrapper($db, 'tests');
		$this->userId = $userId;
	}

	/**
	 * Создать
	 * @param string $name
	 * @return integer testId
	 */
	public function add($name) {
		return $this->table->insert(['user_id' => $this->userId, 'name' => $name, 'time' => time()]);
	}

	/**
	 * Удалить
	 * @param integer $testId
	 * @return boolean
	 */
	public function delete($testId) {
		return $this->table->update(['deleted' => 1, 'time' => time()], ['user_id' => $this->userId, 'test_id' => $testId]);
	}

	/**
	 * Восстановить
	 * @param integer $testId
	 * @return boolean
	 */
	public function restore($testId) {
		return $this->table->update(['deleted' => null, 'time' => time()], ['user_id' => $this->userId, 'test_id' => $testId]);
	}

	/**
	 * Переименовать
	 * @param integer $testId
	 * @param string $name
	 */
	public function rename($testId, $name) {
		return $this->table->update(['name' => $name, 'time' => time()], ['user_id' => $this->userId, 'test_id' => $testId]);
	}

	/**
	 * Получить
	 * @param [integer]|null $testIds null - все
	 * @return []['id' => integer, 'name' => string, 'time' => integer, 'deleted' => boolean]
	 */
	public function get($testIds = null) {
		$data = [];
		if ($testIds === null)
			$data = $this->table->select(['test_id', 'name', 'time', 'deleted'], ['user_id' => $this->userId]);
		else
			foreach ($testIds as $testId)
				if ($data1 = $this->table->select(['test_id', 'name', 'time', 'deleted'], ['user_id' => $this->userId, 'test_id' => $testId]))
					$data = array_merge($data, $data1);
		$tests = [];
		foreach ($data as $data1) {
			$test = [];
			foreach (['test_id' => 'id', 'name' => 'name', 'time' => 'time', 'deleted' => 'deleted'] as $src => $dst)
				$test[$dst] = $data1[$src];
			$tests[] = $test;
		}
		return $tests;
	}
}