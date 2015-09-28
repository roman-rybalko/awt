<?php

namespace AdvancedWebTesting\Test\Action;

/**
 * Управление операциями теста
 * Model (MVC)
 */
class Manager {
	private $actions, $tests;

	public function __construct(\WebConstructionSet\Database\Relational $db, $testId) {
		$this->actions = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'test_actions', ['test_id' => $testId]);
		$this->tests = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'tests', ['test_id' => $testId]);
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
		foreach ($this->actions->select(['action_id']) as $action)
			if ($action['action_id'] > $lastActionId)
				$lastActionId = $action['action_id'];
		$actionId = $lastActionId + 1;
		$fields = ['type' => $type, 'action_id' => $actionId];
		if ($selector !== null)
			$fields['selector'] = $selector;
		if ($data !== null)
			$fields['data'] = $data;
		if (!$this->actions->insert($fields))
			throw new \ErrorException('Test action insert failed', null, null, __FILE__, __LINE__);
		if (!$this->tests->update(['time' => time()], []))
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
		foreach ($this->actions->select(['action_id']) as $action)
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
			if (!$this->actions->update(['action_id' => $id + 1], ['action_id' => $id]))
				throw new \ErrorException('Something wrong in test_actions indexes: test_id=' . $this->testId . ', action_id=' . $id . ' move ids=[' . implode(', ', $ids) . ']', null, null, __FILE__, __LINE__);
		// вставляем
		$fields = ['type' => $type, 'action_id' => $actionId];
		if ($selector !== null)
			$fields['selector'] = $selector;
		if ($data !== null)
			$fields['data'] = $data;
		if (!$this->actions->insert($fields))
			throw new \ErrorException('Test action insert failed', null, null, __FILE__, __LINE__);
		if (!$this->tests->update(['time' => time()], []))
			throw new \ErrorException('Test update failed', null, null, __FILE__, __LINE__);
		return $actionId;
	}

	/**
	 * Удалить
	 * @param integer $actionId
	 * @return boolean
	 */
	public function delete($actionId) {
		if ($result = $this->actions->delete(['action_id' => $actionId]))
			$this->tests->update(['time' => time()], []);
		return $result;
	}

	/**
	 * @param [][id => integer, type => string, selector => string|null, data => string|null] $actions
	 * @throws \ErrorException
	 * @return integer Последний actionId
	 */
	public function import($actions) {
		$actionId = 0;
		usort($actions, function($a,$b){return $a['id']-$b['id'];});
		foreach ($actions as $action) {
			$fields = ['action_id' => ++$actionId];
			foreach (['type', 'selector', 'data'] as $param)
				$fields[$param] = $action[$param];
			if (!$this->actions->insert($fields))
				throw new \ErrorException('Test action insert failed', null, null, __FILE__, __LINE__);
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
		if ($result = $this->actions->update($fields, ['action_id' => $actionId]))
			$this->tests->update(['time' => time()], []);
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
			$data = $this->actions->select(['action_id', 'type', 'selector', 'data']);
		else
			foreach ($actionIds as $actionId)
				if ($data1 = $this->actions->select(['action_id', 'type', 'selector', 'data'], ['action_id' => $actionId]))
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