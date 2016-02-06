<?php

namespace AdvancedWebTesting\TestGroup;

/**
 * Управление группами тестов
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$fields = [];
		if ($userId !== null)
			$fields['user_id'] = $userId;
		$this->table = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'test_groups', $fields);
	}

	/**
	 * Создать
	 * @param string $name
	 * @return integer testGrpId
	 */
	public function add($name) {
		return $this->table->insert(['name' => $name, 'time' => time()]);
	}

	/**
	 * Удалить
	 * @param integer $testGrpId
	 * @return boolean
	 */
	public function delete($testGrpId) {
		return $this->table->update(['deleted' => 1, 'time' => time()], ['test_group_id' => $testGrpId]);
	}

	/**
	 * Восстановить
	 * @param integer $testGrpId
	 * @return boolean
	 */
	public function restore($testGrpId) {
		return $this->table->update(['deleted' => null, 'time' => time()], ['test_group_id' => $testGrpId]);
	}

	/**
	 * Переименовать
	 * @param integer $testGrpId
	 * @param string $name
	 */
	public function rename($testGrpId, $name) {
		return $this->table->update(['name' => $name, 'time' => time()], ['test_group_id' => $testGrpId]);
	}

	/**
	 * Получить
	 * @param [integer]|null $testGrpIds null - все
	 * @return []['id' => integer, 'name' => string, 'time' => integer, 'deleted' => boolean]
	 */
	public function get($testGrpIds = null) {
		$fields = ['test_group_id', 'name', 'time', 'deleted'];
		$data = [];
		if ($testGrpIds === null)
			$data = $this->table->select($fields);
		else
			foreach ($testGrpIds as $testGrpId)
				if ($data1 = $this->table->select($fields, ['test_group_id' => $testGrpId]))
					$data = array_merge($data, $data1);
		$tests = [];
		foreach ($data as $data1) {
			$test = [];
			foreach (['test_group_id' => 'id', 'name' => 'name', 'time' => 'time', 'deleted' => 'deleted'] as $src => $dst)
				$test[$dst] = $data1[$src];
			$tests[] = $test;
		}
		return $tests;
	}

	/**
	 * Получить идентификаторы для удаления но не удаляет их
	 * @param integer $time UnixTime старше которого очистить
	 * @return [id => integer]
	 */
	public function clear1($time = 0) {
		$testGrps = $this->table->select(['test_group_id'], ['deleted' => 1, 'time' => $this->table->predicate('less', $time)]);
		foreach ($testGrps as &$testGrp) {
			$testGrp['id'] = $testGrp['test_group_id'];
			unset($testGrp['test_id']);
		}
		return $testGrps;
	}

	/**
	 * Очищает БД
	 * @param [id => integer] $tests
	 */
	public function clear2($testGrps) {
		foreach ($testGrps as $testGrp)
			$this->table->delete(['test_group_id' => $testGrp['id']]);
	}
}