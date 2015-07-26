<?php

namespace AdvancedWebTesting;

class User {
	private $db, $user;

	public function __construct() {
		$db = $this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
		$userDb = new \WebConstructionSet\Database\Relational\User($db);
		$this->user = new \WebConstructionSet\Accounting\User($userDb);
	}

	public function run() {
		echo '<user>';
		$user = $this->user;
		if ($user->getId()) {
?>
<!--
	Logout
	action: ?logout=1

	Tests
	action: ?tests=1

	Test
	action: ?test=xxx

	Tasks
	action: ?tasks=1

	Task
	action: ?task=xxx

	Scheduler
	action: ?scheduler=1

	Billing
	action: ?billing=1

	Dashboard
	action: index
-->
<?php
			if (isset($_GET['logout'])) {
				$this->logout();
			} else if (isset($_GET['tests'])) {
				$this->tests();
			} else if (isset($_GET['test'])) {
				$this->test();
			} else if (isset($_GET['tasks'])) {
				$this->tasks();
			} else if (isset($_GET['task'])) {
				$this->task();
			} else if (isset($_GET['scheduler'])) {
				$this->scheduler();
			} else if (isset($_GET['billing'])) {
				$this->billing();
			} else {
				$this->dashboard();
			}
		} else {
?>
<!--
	Login
	action: index

	Register
	action: ?register=1
-->
<?php
			if (isset($_GET['register'])) {
				$this->register();
			} else {
				$this->login();
			}
		}
		echo '</user>';
	}

	private function redirect($url, $timeout = null) {
		echo '<redirect url="', htmlspecialchars($url), '"';
		if ($timeout)
			echo ' timeout="', $timeout, '"';
		echo '/>';
	}

	private function login() {
?>
<!--
	Login
	method: post
	params: user password
	submit: login
-->
<?php
		if (isset($_POST['login'])) {
			if ($this->user->login($_POST['user'], $_POST['password'])) {
				echo '<message type="notice" value="login_ok"/>';
				$this->redirect('');
			} else {
				echo '<message type="error" value="bad_login"/>';
				$this->redirect('', 3);
			}
		} else {
			echo '<login/>';
		}
	}

	private function register() {
?>
<!--
	Register/Signup
	method: post
	params: user password1 password2
	subit: register
-->
<?php
		if (isset($_POST['register'])) {
			if ($_POST['password1'] != $_POST['password2']) {
				echo '<message type="error" value="passwords_dont_match"/>';
				$this->redirect('?' . $_SERVER['QUERY_STRING'], 3);
			} else {
				if ($this->user->register($_POST['user'], $_POST['password1'])) {
					echo '<message type="notice" value="register_ok"/>';
					$this->redirect('');
				} else {
					echo '<message type="error" value="register_fail"/>';
					$this->redirect('?' . $_SERVER['QUERY_STRING'], 3);
				}
			}
		} else {
			echo '<register/>';
		}
	}

	private function logout() {
?>
<!--
	Logout
-->
<?php
		$this->user->logout();
		echo '<message type="notice" value="logout_ok"/>';
		$this->redirect('', 0);
	}

	private function tests() {
?>
<!--
	Tests

	Add
	method: post
	params: name
	submit: add

	Delete
	method: post
	params: test_id
	submit: delete

	Modify
	method: post
	params: test_id name
	submit: modify
-->
<?php
		$db = $this->db;
		$userId = $this->user->getId();
		if (isset($_POST['add'])) {
			if ($db->insert('tests', ['user_id' => $userId, 'name' => $_POST['name']]))
				echo '<message type="notice" value="test_add_ok"/>';
			else
				echo '<message type="error" value="test_add_fail"/>';
		} else if (isset($_POST['delete'])) {
			if ($db->delete('tests', ['user_id' => $userId, 'test_id' => $_POST['test_id']])) {
				$db->delete('test_actions', ['test_id' => $_POST['test_id']]);
				echo '<message type="notice" value="test_delete_ok"/>';
			} else
				echo '<message type="error" value="test_delete_fail"/>';
		} else if (isset($_POST['modify'])) {
			if ($db->update('tests', ['name' => $_POST['name']], ['user_id' => $userId, 'test_id' => $_POST['test_id']]))
				echo '<message type="notice" value="test_modify_ok"/>';
			else
				echo '<message type="error" value="test_modify_fail"/>';
		}
		echo '<tests>';
		foreach ($db->select('tests', ['test_id', 'name'], ['user_id' => $userId]) as $test)
			echo '<test name="', htmlspecialchars($test['name']), '" id="', $test['test_id'], '"/>';
		echo '</tests>';
	}

	private function test() {
?>
<!--
	Test
	method: get
	params: test

	Add
	method: post
	params: type selector data
	submit: add

	Delete
	method: post
	params: test_action_id
	submit: delete

	Modify
	method: post
	params: test_action_id [type] [selector] [data]
	submit: modify

	Insert
	method: post
	params: [test_action_id] type selector data
	submit: insert
-->
<?php
		$db = $this->db;
		$testId = $_GET['test'];
		$userId = $this->user->getId();
		if ($db->select('tests', ['test_id'], ['user_id' => $userId, 'test_id' => $testId])) {
			if (isset($_POST['add'])) {
				$lastTestActionId = 0;
				foreach ($db->select('test_actions', ['test_action_id'], ['test_id' => $testId]) as $testAction)
					if ($testAction['test_action_id'] > $lastTestActionId)
						$lastTestActionId = $testAction['test_action_id'];
				if ($db->insert('test_actions', ['test_id' => $testId, 'test_action_id' => $lastTestActionId + 1, 'type' => $_POST['type'], 'selector' => $_POST['selector'], 'data' => $_POST['data']]))
					echo '<message type="notice" value="test_action_add_ok"/>';
				else
					echo '<message type="error" value="test_action_add_fail"/>';
			} else if (isset($_POST['delete'])) {
				if ($db->delete('test_actions', ['test_id' => $testId, 'test_action_id' => $_POST['test_action_id']]))
					echo '<message type="notice" value="test_action_delete_ok"/>';
				else
					echo '<message type="error" value="test_action_delete_fail"/>';
			} else if (isset($_POST['modify'])) {
				$fields = [];
				foreach(['type', 'selector', 'data'] as $field)
					if (isset($_POST[$field]))
						$fields[$field] = $_POST[$field];
				if ($db->update('test_actions', $fields, ['test_id' => $testId, 'test_action_id' => $_POST['test_action_id']]))
					echo '<message type="notice" value="test_action_modify_ok"/>';
				else
					echo '<message type="error" value="test_action_modify_fail"/>';
			} else if (isset($_POST['insert'])) {
				$testActionId = 0;
				if (isset($_POST['test_action_id']) && is_numeric($_POST['test_action_id']) && $_POST['test_action_id'] > 0)
					$testActionId = $_POST['test_action_id'];
				// получаем список идентификаторов, которые надо изменить
				$ids = [];
				foreach ($db->select('test_actions', ['test_action_id'], ['test_id' => $testId]) as $testAction)
					if ($testAction['test_action_id'] >= $testActionId)
						$ids[] = $testAction['test_action_id'];
				// находим промежуток в порядковых номерах, образовавшийся при удалении, и отбрасываем оставшуюся часть, т.к. её изменять нет смысла
				sort($ids);
				if ($ids && $ids[0] > $testActionId)
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
					if (!$db->update('test_actions', ['test_action_id' => $id + 1], ['test_id' => $testId, 'test_action_id' => $id]))
						throw new \ErrorException('Something wrong in test_actions indexes: test_id=' . $testId . ', test_action_id=' . $id . ' move ids=[' . implode(', ', $ids) . ']', null, null, __FILE__, __LINE__);
				if ($db->insert('test_actions', ['test_id' => $testId, 'test_action_id' => $testActionId, 'type' => $_POST['type'], 'selector' => $_POST['selector'], 'data' => $_POST['data']]))
					echo '<message type="notice" value="test_action_insert_ok"/>';
				else
					echo '<message type="error" value="test_action_insert_fail"/>';
			}
			echo '<test id="', $testId, '">';
			foreach ($db->select('test_actions', ['test_action_id', 'type', 'selector', 'data'], ['test_id' => $testId], 'order by test_action_id asc') as $action)
				echo '<action type="', htmlspecialchars($action['type']), '" selector="', htmlspecialchars($action['selector']), '" data="', htmlspecialchars($action['data']), '" id="', $action['test_action_id'], '"/>';
			echo '</test>';
		} else {
			echo '<message type="error" value="bad_test_id"/>';
		}
	}

	private function tasks() {
?>
<!--
	Tasks

	Add
	method: post
	params: test_id [type]
	submit: add

	Delete
	method: post
	params: task_id
	submit: delete
-->
<?php
		$db = $this->db;
		$userId = $this->user->getId();
		if (isset($_POST['add'])) {
			$testId = $_POST['test_id'];
			$type = '';
			if (isset($_POST['type']) && $_POST['type'])
				$type = $_POST['type'];
			if ($db->select('tests', ['test_id'], ['user_id' => $userId, 'test_id' => $testId]))
				if ($db->insert('tasks', ['user_id' => $userId, 'test_id' => $testId, 'type' => $type, 'status' => \AdvancedWebTesting\Task\Status::INITIAL, 'time' => time()]))
					echo '<message type="notice" value="task_add_ok"/>';
				else
					echo '<message type="error" value="task_add_fail"/>';
			else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['delete'])) {
			$taskId = $_POST['task_id'];
			if ($db->delete('tasks', ['user_id' => $userId, 'task_id' => $taskId, 'status' => \AdvancedWebTesting\Task\Status::INITIAL]))
				echo '<message type="notice" value="task_delete_ok"/>';
			else
				echo '<message type="error" value="bad_task_id"/>';
		}
		echo '<tasks>';
		foreach ($db->select('tasks', ['task_id', 'test_id', 'type', 'status', 'data'], ['user_id' => $userId]) as $task) {
			echo '<task id="', $task['task_id'], '" test_id="', $task['test_id'], '" type="', htmlspecialchars($task['type']), '" status="', \AdvancedWebTesting\Task\Status::toString($task['status']), '"';
			if ($task['status'] == \AdvancedWebTesting\Task\Status::RUNNING)
				echo ' vnc="', $task['data'], '"';
			echo '/>';
		}
		echo '</tasks>';
	}

	private function task() {
?>
<!--
	Task
	method: get
	params: task
-->
<?php
		$db = $this->db;
		$taskId = $_GET['task'];
		$userId = $this->user->getId();
		if ($tasks = $db->select('tasks', ['status', 'data', 'test_id'], ['user_id' => $userId, 'task_id' => $taskId])) {
			$task = $tasks[0];
			$status = $task['status'];
			if ($status == \AdvancedWebTesting\Task\Status::INITIAL) {
				echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" status="', \AdvancedWebTesting\Task\Status::toString($status), '"/>';
			}
			if ($status == \AdvancedWebTesting\Task\Status::STARTING) {
				echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" status="', \AdvancedWebTesting\Task\Status::toString($status), '" node_id="', $task['data'], '"/>';
			}
			if ($status == \AdvancedWebTesting\Task\Status::RUNNING) {
				echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" status="', \AdvancedWebTesting\Task\Status::toString($status), '" vnc="', $task['data'], '"/>';
			}
			if ($status == \AdvancedWebTesting\Task\Status::SUCCEEDED || $status == \AdvancedWebTesting\Task\Status::FAILED) {
				echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" status="', \AdvancedWebTesting\Task\Status::toString($status), '">';
				$data = json_decode(file_get_contents(\Config::$rootPath . \Config::RESULT_DATA_PATH . $task['data'] . '/descr.json'), true /* assoc */);
				if ($data) {
					foreach ($data['test_actions'] as $action) {
						echo '<action type="', htmlspecialchars($action['type']), '" selector="', htmlspecialchars($action['selector']), '" data="', htmlspecialchars($action['data']), '" id="', $action['test_action_id'], '"';
						if (isset($action['scrn_filename']))
							echo ' scrn="', $task['data'] . '/' . $action['scrn_filename'], '"';
						if (isset($action['failed']))
							echo ' failed="', $action['failed'], '"';
						echo '/>';
					}
				} else
					echo '<message type="error" value="task_data_not_found"/>';
				echo '</task>';
			}
		} else
			echo '<message type="error" value="bad_task_id"/>';
	}

	private function scheduler() {
?>
<!--
	Scheduler
-->
<?php
		echo '<scheduler/>';
	}

	private function billing() {
?>
<!--
	Billing
-->
<?php
		echo '<billing/>';
	}

	private function dashboard() {
?>
<!--
	Dashboard
-->
<?php
		echo '<dashboard/>';
	}
}