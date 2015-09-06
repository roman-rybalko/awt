<?php

namespace AdvancedWebTesting\Test;

/**
 * Управление тестами
 */
class Manager {
	private $db;

	public function __construct(\WebConstructionSet\Database\Relational $db) {
		$this->db = $db;
	}

	/**
	 * Получить имя теста по его идентификатору
	 * @param integer $testId
	 * @return string
	 */
	public function id2name($testId) {
		$tests = $this->db->select('tests', ['name'], ['test_id' => $testId]);
		$name = null;
		if ($tests) {
			$test = $tests[0];
			$name = $test['name'];
		}
		return $name;
	}
}