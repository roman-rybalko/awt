<?php

namespace AdvancedWebTesting\Task;

/**
 * Управление задачами
 * Model (MVC)
 */
class Manager {
	private $db, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->db = $db;
		$this->userId = $userId;
	}

	/**
	 * Создать новую задачу
	 * @param integer $testId
	 * @param string $testName
	 * @param string $type
	 * @param boolean $debug
	 * @throws \ErrorException
	 * @return NULL|$taskId
	 */
	public function add($testId, $testName, $type, $debug = false) {
		if ($type === null) {
			$typeMgr = new Type\Manager($this->db);
			$types = $typeMgr->get($typeMgr->getTop());
			$type = $types[0]['name'];
		}
		if ($taskId = $this->db->insert('tasks', ['user_id' => $this->userId, 'test_id' => $testId, 'test_name' => $testName, 'type' => $type, 'debug' => $debug, 'status' => -1, 'time' => time()])) {
			$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $taskId);
			$taskActMgr->import($testId);
			if (!$this->db->update('tasks', ['status' => Status::INITIAL], ['task_id' => $taskId]))
				throw new \ErrorException('Task ' . $taskId . ' final update failed', null, null, __FILE__, __LINE__);
		}
		return $taskId;
	}

	/**
	 * Отменить задачу
	 * @param integer $taskId
	 * @return boolean
	 */
	public function cancel($taskId) {
		return $this->db->update('tasks', ['status' => Status::CANCELED, 'time' => time()], ['user_id' => $this->userId, 'task_id' => $taskId, 'status' => Status::INITIAL]);
	}

	/**
	 * Получить
	 * @param [integer]|null $taskIds null - все
	 * @return [][id => integer, test_id => integer, test_name => string, type => string, debug => boolean, status => integer, result => string|null, node_id => string|null, time => integer]
	 */
	public function get($taskIds = null) {
		$data = [];
		if ($taskIds === null)
			$data = $this->db->select('tasks', ['task_id', 'test_id', 'test_name', 'type', 'debug', 'status', 'result', 'node_id', 'time'], ['user_id' => $this->userId]);
		else
			foreach ($taskIds as $taskId)
				if ($data1 = $this->db->select('tasks', ['task_id', 'test_id', 'test_name', 'type', 'debug', 'status', 'result', 'node_id', 'time'], ['user_id' => $this->userId, 'task_id' => $taskId]))
					$data = array_merge($data, $data1);
		$tasks = [];
		foreach ($data as $data1) {
			$task = [];
			foreach (['task_id' => 'id', 'test_id' => 'test_id', 'test_name' => 'test_name', 'type' => 'type',
					'debug' => 'debug', 'status' => 'status', 'result' => 'result', 'node_id' => 'node_id',
					'time' => 'time'] as $src => $dst)
				$task[$dst] = $data1[$src];
			$tasks[] = $task;
		}
		return $tasks;
	}

	/**
	 * Выбрать задачу и перевести её в status = STARTING
	 * @param string $type
	 * @param string $nodeId
	 * @return [id => integer, debug => boolean, type => string]|null
	 */
	public function lock($type, $nodeId) {
		$typeMgr = new Type\Manager($this->db);
		foreach ($typeMgr->get($typeMgr->getCompatible($type)) as $typeData) {
			$type1 = $typeData['name'];
			if ($data = $this->db->select('tasks', ['task_id', 'debug'], ['status' => Status::INITIAL, 'type' => $type1]))
				foreach ($data as $data1) {
					$task = ['type' => $type];
					foreach (['task_id' => 'id', 'debug' => 'debug'] as $src => $dst)
						$task[$dst] = $data1[$src];
					if ($this->db->update('tasks', ['status' => Status::STARTING, 'type' => $type, 'node_id' => $nodeId, 'time' => time()], ['task_id' => $data1['task_id'], 'status' => Status::INITIAL]))
						return $task;
				}
		}
		return null;
	}

	/**
	 * Перевести задачу из status = STARTING в status = RUNNING
	 * @param integer $taskId
	 * @return boolean
	 */
	public function start($taskId) {
		return $this->db->update('tasks', ['status' => Status::RUNNING, 'time' => time()], ['task_id' => $taskId, 'status' => Status::STARTING]);
	}

	/**
	 * Перевести задачу из status = RUNNING в $status
	 * @param integer $taskId
	 * @param integer $status
	 * @param string $result
	 * @return boolean
	 */
	public function finish($taskId, $status, $result) {
		return $this->db->update('tasks', ['status' => $status, 'result' => $result, 'time' => time()], ['task_id' => $taskId, 'status' => Status::RUNNING]);
	}

	/**
	 * @param integer $taskId
	 * @return integer
	 */
	public function getUserId($taskId) {
		if ($this->userId !== null && $this->get([$taskId]))
			return $this->userId;
		$data = $this->db->select('tasks', ['user_id'], ['task_id' => $taskId]);
		if ($data)
			return $data[0]['user_id'];
		return null;
	}
}