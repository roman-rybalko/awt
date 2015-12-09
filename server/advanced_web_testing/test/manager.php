<?php

namespace AdvancedWebTesting\Test;

/**
 * Управление тестами
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$fields = [];
		if ($userId !== null)
			$fields['user_id'] = $userId;
		$this->table = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'tests', $fields);
	}

	/**
	 * Создать
	 * @param string $name
	 * @return integer testId
	 */
	public function add($name) {
		return $this->table->insert(['name' => $name, 'time' => time()]);
	}

	/**
	 * Удалить
	 * @param integer $testId
	 * @return boolean
	 */
	public function delete($testId) {
		return $this->table->update(['deleted' => 1, 'time' => time()], ['test_id' => $testId]);
	}

	/**
	 * Восстановить
	 * @param integer $testId
	 * @return boolean
	 */
	public function restore($testId) {
		return $this->table->update(['deleted' => null, 'time' => time()], ['test_id' => $testId]);
	}

	/**
	 * Переименовать
	 * @param integer $testId
	 * @param string $name
	 */
	public function rename($testId, $name) {
		return $this->table->update(['name' => $name, 'time' => time()], ['test_id' => $testId]);
	}

	/**
	 * Получить
	 * @param [integer]|null $testIds null - все
	 * @return []['id' => integer, 'name' => string, 'time' => integer, 'deleted' => boolean]
	 */
	public function get($testIds = null) {
		$data = [];
		if ($testIds === null)
			$data = $this->table->select(['test_id', 'name', 'time', 'deleted']);
		else
			foreach ($testIds as $testId)
				if ($data1 = $this->table->select(['test_id', 'name', 'time', 'deleted'], ['test_id' => $testId]))
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

	/**
	 * Получить идентификаторы для удаления но не удаляет их
	 * @param integer $time UnixTime старше которого очистить
	 * @return [integer] идентификаторы тестов
	 */
	public function clear1($time = 0) {
		$tests = $this->table->select(['test_id'], ['deleted' => 1, 'time' => $this->table->predicate('less', $time)]);
		$testIds = [];
		foreach ($tests as $test)
			$testIds[] = $test['test_id'];
		return $testIds;
	}

	/**
	 * Очищает БД
	 * @param [integer] $testIds идентификаторы тестов
	 */
	public function clear2($testIds) {
		foreach ($testIds as $testId)
			$this->table->delete(['test_id' => $testId]);
	}
}