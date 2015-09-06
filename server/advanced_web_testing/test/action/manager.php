<?php

namespace AdvancedWebTesting\Test\Action;

/**
 * Управление операциями теста
 * Model (MVC)
 */
class Manager {
	private $db, $testId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $testId) {
		$this->db = $db;
		$this->testId = $testId;
	}

	/**
	 * Добавить
	 * @param string $type
	 * @param string|null $selector
	 * @param string|null $data
	 * @return integer actionId
	 */
	public function add($type, $selector, $data) {
		$lastActionId = 0;
		foreach ($this->db->select('test_actions', ['action_id'], ['test_id' => $this->testId]) as $action)
			if ($action['action_id'] > $lastActionId)
				$lastActionId = $action['action_id'];
		$actionId = $lastActionId + 1;
		$fields = ['type' => $type];
		if ($selector !== null)
			$fields['selector'] = $selector;
		if ($data !== null)
			$fields['data'] = $data;
		if (!$this->db->insert('test_actions', array_merge(['test_id' => $this->testId, 'action_id' => $actionId], $fields)))
			throw new \ErrorException('Test action insert failed', null, null, __FILE__, __LINE__);
		if (!$this->db->update('tests', ['time' => time()], ['test_id' => $this->testId]))
			throw new \ErrorException('Test update failed', null, null, __FILE__, __LINE__);
		return $actionId;
	}

	/**
	 * Вставить
	 * @param integer $actionId
	 * @param string $type
	 * @param string|null $selector
	 * @param string|null $data
	 * @return integer actionId
	 */
	public function insert($actionId, $type, $selector, $data) {
		// получаем список идентификаторов, которые надо изменить
		$ids = [];
		foreach ($this->db->select('test_actions', ['action_id'], ['test_id' => $this->testId]) as $action)
			if ($action['action_id'] >= $actionId)
				$ids[] = $action['action_id'];
		// находим промежуток в порядковых номерах, образовавшийся при удалении, и отбрасываем оставшуюся часть, т.к. её изменять нет смысла
		sort($ids);
		if ($ids && $ids[0] > $actionId)
			$i = 0;
		else
			for ($i = 1; $i < count($ids); ++$i)
				if ($ids[$i] > $ids[$i - 1] + 1)
					break;
		// $i указывает на элемент, с которого удалить хвост
			if ($i < count($ids))
				array_splice($ids, $i);
		// делаем изменения
		$ids = array_reverse($ids);
		foreach ($ids as $id)
			if (!$this->db->update('test_actions', ['action_id' => $id + 1], ['test_id' => $this->testId, 'action_id' => $id]))
				throw new \ErrorException('Something wrong in test_actions indexes: test_id=' . $this->testId . ', action_id=' . $id . ' move ids=[' . implode(', ', $ids) . ']', null, null, __FILE__, __LINE__);
		// вставляем
		$fields = ['type' => $type];
		if ($selector !== null)
			$fields['selector'] = $selector;
		if ($data !== null)
			$fields['data'] = $data;
		if (!$this->db->insert('test_actions', array_merge(['test_id' => $this->testId, 'action_id' => $actionId], $fields)))
			throw new \ErrorException('Test action insert failed', null, null, __FILE__, __LINE__);
		if (!$this->db->update('tests', ['time' => time()], ['test_id' => $this->testId]))
			throw new \ErrorException('Test update failed', null, null, __FILE__, __LINE__);
		return $actionId;
	}

	/**
	 * Удалить
	 * @param integer $actionId
	 * @return boolean
	 */
	public function delete($actionId) {
		if ($result = $this->db->delete('test_actions', ['test_id' => $this->testId, 'action_id' => $actionId]))
			$this->db->update('tests', ['time' => time()], ['test_id' => $this->testId]);
		return $result;
	}

	/**
	 * Скопировать
	 * @param integer $testId Получатель
	 * @throws \ErrorException
	 * @return integer Последний actionId
	 */
	public function copy($testId) {
		$actions = $this->db->select('test_actions', ['type', 'selector', 'data', 'action_id'], ['test_id' => $this->testId]);
		usort($actions, function($a, $b){return $a['action_id']-$b['action_id'];});
		$actionId = 0;
		foreach ($actions as $action) {
			$action['action_id'] = ++$actionId;
			$action['test_id'] = $testId;
			if (!$this->db->insert('test_actions', $action))
				throw new \ErrorException('Insert test action failed', null, null, __FILE__, __LINE__);
		}
		return $actionId;
	}

	/**
	 * Изменить
	 * @param integer $actionId
	 * @param string|null $selector
	 * @param string|null $data
	 * @return boolean
	 */
	public function modify($actionId, $selector, $data) {
		$fields = [];
		if ($selector !== null)
			$fields['selector'] = $selector;
		if ($data !== null)
			$fields['data'] = $data;
		if ($result = $this->db->update('test_actions', $fields, ['test_id' => $this->testId, 'action_id' => $actionId]))
			$this->db->update('tests', ['time' => time()], ['test_id' => $this->testId]);
		return $result;
	}

	/**
	 * Получить
	 * @param [integer]|null $actionIds null - все
	 * @return [][id => integer, type => string, selector => string|null, data => string|null]
	 */
	public function get($actionIds = null) {
		$data = [];
		if ($actionIds === null)
			$data = $this->db->select('test_actions', ['action_id', 'type', 'selector', 'data'], ['test_id' => $this->testId]);
		else
			foreach ($actionIds as $actionId)
				if ($data1 = $this->db->select('test_actions', ['action_id', 'type', 'selector', 'data'], ['action_id' => $actionId, 'test_id' => $this->testId]))
					$data = array_merge($data, $data1);
		$actions = [];
		usort($data, function($a,$b){return $a['action_id']-$b['action_id'];});
		foreach ($data as $data1) {
			$action = [];
			foreach (['action_id' => 'id', 'type' => 'type', 'selector' => 'selector', 'data' => 'data'] as $src => $dst)
				$action[$dst] = $data1[$src];
			$actions[] = $action;
		}
		return $actions;
	}
}