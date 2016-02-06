<?php

namespace AdvancedWebTesting\Test\Action;

/**
 * Управление операциями теста
 * Model (MVC)
 */
class Manager {
	const SELECTOR_MAX_SIZE = 4096;
	const DATA_MAX_SIZE = 4096;
	const USERDATA_MAX_SIZE = 32768;

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
	 * @param string|null $userData
	 * @return integer actionId
	 */
	public function add($type, $selector, $data, $userData) {
		$lastActionId = 0;
		foreach ($this->actions->select(['action_id']) as $action)
			if ($action['action_id'] > $lastActionId)
				$lastActionId = $action['action_id'];
		$actionId = $lastActionId + 1;
		$fields = ['type' => $type, 'action_id' => $actionId];
		if ($selector !== null) {
			if (strlen($selector) > self::SELECTOR_MAX_SIZE)
				return -2;
			$fields['selector'] = $selector;
		}
		if ($data !== null) {
			if (strlen($data) > self::DATA_MAX_SIZE)
				return -3;
			$fields['data'] = $data;
		}
		if ($userData !== null) {
			if (strlen($userData) > self::USERDATA_MAX_SIZE)
				return -4;
			$fields['user_data'] = $userData;
		}
		if (!$this->actions->insert($fields))
			return -1;
		$this->tests->update(['time' => time()], []);  // no check - may be the same time
		return $actionId;
	}

	/**
	 * Вставить
	 * @param integer $actionId
	 * @param string $type
	 * @param string|null $selector
	 * @param string|null $data
	 * @param string|null $userData
	 * @return integer actionId
	 */
	public function insert($actionId, $type, $selector, $data, $userData) {
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
		if ($selector !== null) {
			if (strlen($selector) > self::SELECTOR_MAX_SIZE)
				return -2;
			$fields['selector'] = $selector;
		}
		if ($data !== null) {
			if (strlen($data) > self::DATA_MAX_SIZE)
				return -3;
			$fields['data'] = $data;
		}
		if ($userData !== null) {
			if (strlen($userData) > self::USERDATA_MAX_SIZE)
				return -4;
			$fields['user_data'] = $userData;
		}
		if (!$this->actions->insert($fields))
			return -1;
		$this->tests->update(['time' => time()], []);  // no check - may be the same time
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
	 * @return integer Последний actionId
	 */
	public function import($actions) {
		if (!is_array($actions))
			return -11;
		foreach ($actions as $action) {
			if (!isset($action['id']))
				return -12;
			if (!isset($action['type']))
				return -13;
			if (isset($action['selector']) && strlen($action['selector']) > self::SELECTOR_MAX_SIZE)
				return -2;
			if (isset($action['data']) && strlen($action['data']) > self::DATA_MAX_SIZE)
				return -3;
			if (isset($action['user_data']) && strlen($action['user_data']) > self::USERDATA_MAX_SIZE)
				return -4;
		}
		$lastActionId = 0;
		foreach ($this->actions->select(['action_id']) as $action)
			if ($action['action_id'] > $lastActionId)
				$lastActionId = $action['action_id'];
		$actionId = $lastActionId;  // will be incremented before use
		usort($actions, function($a,$b){return $a['id']-$b['id'];});
		foreach ($actions as $action) {
			$fields = ['action_id' => ++$actionId];
			foreach (['type', 'selector', 'data', 'user_data'] as $param) {
				if (isset($action[$param])) {
					$fields[$param] = $action[$param];
				}
			}
			if (!$this->actions->insert($fields))
				return -1;
		}
		return $actionId;
	}

	/**
	 * Изменить
	 * @param integer $actionId
	 * @param string|null $selector
	 * @param string|null $data
	 * @param string|null $userData
	 * @return integer
	 */
	public function modify($actionId, $selector, $data, $userData) {
		$fields = [];
		if ($selector !== null) {
			if (strlen($selector) > self::SELECTOR_MAX_SIZE)
				return -2;
			$fields['selector'] = $selector;
		}
		if ($data !== null) {
			if (strlen($data) > self::DATA_MAX_SIZE)
				return -3;
			$fields['data'] = $data;
		}
		if ($userData !== null) {
			if (strlen($userData) > self::USERDATA_MAX_SIZE)
				return -4;
			$fields['user_data'] = $userData;
		}
		if (!$fields)
			return -1;
		if ($result = $this->actions->update($fields, ['action_id' => $actionId]))
			$this->tests->update(['time' => time()], []);  // no check - the time may be the same
		return $result;
	}

	/**
	 * Получить
	 * @param [integer]|null $actionIds null - все
	 * @return [][id => integer, type => string, selector => string|null, data => string|null, user_data => string|null]
	 */
	public function get($actionIds = null) {
		$fields = ['action_id', 'type', 'selector', 'data', 'user_data'];
		$data = [];
		if ($actionIds === null)
			$data = $this->actions->select($fields);
		else
			foreach ($actionIds as $actionId)
				if ($data1 = $this->actions->select($fields, ['action_id' => $actionId]))
					$data = array_merge($data, $data1);
		$actions = [];
		usort($data, function($a,$b){return $a['action_id']-$b['action_id'];});
		foreach ($data as $data1) {
			$action = [];
			foreach (['action_id' => 'id', 'type' => 'type', 'selector' => 'selector', 'data' => 'data', 'user_data' => 'user_data'] as $src => $dst)
				$action[$dst] = $data1[$src];
			$actions[] = $action;
		}
		return $actions;
	}

	/**
	 * Удалить все Action
	 */
	public function clear() {
		$cnt = $this->actions->delete([]);
		if ($cnt)
			$this->tests->update(['time' => time()], []);
		return $cnt;
	}
}