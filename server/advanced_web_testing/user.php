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

	Schedule
	action: ?schedule=1

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
			} else if (isset($_GET['schedule'])) {
				$this->schedule();
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

	Undelete
	method: post
	params: test_id
	submit: undelete

	Modify
	method: post
	params: test_id name
	submit: modify

	Copy
	method: post
	params: test_id name
	submit: copy
-->
<?php
		$db = $this->db;
		$userId = $this->user->getId();
		if (isset($_POST['add'])) {
			if ($test_id = $db->insert('tests', ['user_id' => $userId, 'name' => $_POST['name'], 'time' => time()])) {
				echo '<message type="notice" value="test_add_ok"/>';
				$this->redirect('?test=' . $test_id);
				return;
			} else
				echo '<message type="error" value="test_add_fail"/>';
		} else if (isset($_POST['delete'])) {
			if ($db->update('tests', ['deleted' => 1, 'time' => time()], ['user_id' => $userId, 'test_id' => $_POST['test_id']]))
				echo '<message type="notice" value="test_delete_ok"/>';
			else
				echo '<message type="error" value="test_delete_fail"/>';
		} else if (isset($_POST['undelete'])) {
			if ($db->update('tests', ['deleted' => null, 'time' => time()], ['user_id' => $userId, 'test_id' => $_POST['test_id']]))
				echo '<message type="notice" value="test_undelete_ok"/>';
			else
				echo '<message type="error" value="test_undelete_fail"/>';
		} else if (isset($_POST['modify'])) {
			if ($db->update('tests', ['name' => $_POST['name'], 'time' => time()], ['user_id' => $userId, 'test_id' => $_POST['test_id']]))
				echo '<message type="notice" value="test_modify_ok"/>';
			else
				echo '<message type="error" value="test_modify_fail"/>';
		} else if (isset($_POST['copy'])) {
			if ($testId = $db->insert('tests', ['user_id' => $userId, 'name' => $_POST['name'], 'time' => time()])) {
				foreach ($db->select('test_actions', ['type', 'selector', 'data', 'action_id'], ['test_id' => $_POST['test_id']]) as $action) {
					$action['test_id'] = $testId;
					$db->insert('test_actions', $action);
				}
				echo '<message type="notice" value="test_copy_ok"/>';
			} else
				echo '<message type="error" value="test_copy_fail"/>';
		}
		echo '<tests>';
		foreach ($db->select('tests', ['test_id', 'name', 'time', 'deleted'], ['user_id' => $userId]) as $test) {
			echo '<test name="', htmlspecialchars($test['name']), '" id="', $test['test_id'], '"',
				' time="', $test['time'], '"';
			if ($test['deleted'])
				echo ' deleted="1"';
			echo '/>';
		}
		echo '</tests>';
		$this->task_types();
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
	params: action_id
	submit: delete

	Modify
	method: post
	params: action_id [type] [selector] [data]
	submit: modify

	Insert
	method: post
	params: [action_id] type selector data
	submit: insert
-->
<?php
		$db = $this->db;
		$testId = $_GET['test'];
		$userId = $this->user->getId();
		if ($tests = $db->select('tests', ['name', 'time', 'deleted'], ['user_id' => $userId, 'test_id' => $testId])) {
			$test = $tests[0];
			if (isset($_POST['add'])) {
				$lastTestActionId = 0;
				foreach ($db->select('test_actions', ['action_id'], ['test_id' => $testId]) as $testAction)
					if ($testAction['action_id'] > $lastTestActionId)
						$lastTestActionId = $testAction['action_id'];
				if ($db->insert('test_actions', ['test_id' => $testId, 'action_id' => $lastTestActionId + 1,
					'type' => $_POST['type'],
					'selector' => \AdvancedWebTesting\User\Tools::valueOrNull($_POST, 'selector'),
					'data' => \AdvancedWebTesting\User\Tools::valueOrNull($_POST, 'data')
				])) {
					$db->update('tests', ['time' => time()], ['test_id' => $testId]);
					echo '<message type="notice" value="test_action_add_ok"/>';
				} else
					echo '<message type="error" value="test_action_add_fail"/>';
			} else if (isset($_POST['delete'])) {
				if ($db->delete('test_actions', ['test_id' => $testId, 'action_id' => $_POST['action_id']])) {
					$db->update('tests', ['time' => time()], ['test_id' => $testId]);
					echo '<message type="notice" value="test_action_delete_ok"/>';
				} else
					echo '<message type="error" value="test_action_delete_fail"/>';
			} else if (isset($_POST['modify'])) {
				$fields = [];
				foreach(['type', 'selector', 'data'] as $field)
					if (isset($_POST[$field]))
						$fields[$field] = \AdvancedWebTesting\User\Tools::valueOrNull($_POST, $field);
				if ($db->update('test_actions', $fields, ['test_id' => $testId, 'action_id' => $_POST['action_id']])) {
					$db->update('tests', ['time' => time()], ['test_id' => $testId]);
					echo '<message type="notice" value="test_action_modify_ok"/>';
				} else
					echo '<message type="error" value="test_action_modify_fail"/>';
			} else if (isset($_POST['insert'])) {
				$testActionId = 0;
				if (isset($_POST['action_id']) && is_numeric($_POST['action_id']) && $_POST['action_id'] > 0)
					$testActionId = $_POST['action_id'];
				// получаем список идентификаторов, которые надо изменить
				$ids = [];
				foreach ($db->select('test_actions', ['action_id'], ['test_id' => $testId]) as $testAction)
					if ($testAction['action_id'] >= $testActionId)
						$ids[] = $testAction['action_id'];
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
					if (!$db->update('test_actions', ['action_id' => $id + 1], ['test_id' => $testId, 'action_id' => $id]))
						throw new \ErrorException('Something wrong in test_actions indexes: test_id=' . $testId . ', action_id=' . $id . ' move ids=[' . implode(', ', $ids) . ']', null, null, __FILE__, __LINE__);
				if ($db->insert('test_actions', ['test_id' => $testId, 'action_id' => $testActionId,
						'type' => $_POST['type'],
						'selector' => \AdvancedWebTesting\User\Tools::valueOrNull($_POST, 'selector'),
						'data' => \AdvancedWebTesting\User\Tools::valueOrNull($_POST, 'data')
				])) {
					$db->update('tests', ['time' => time()], ['test_id' => $testId]);
					echo '<message type="notice" value="test_action_insert_ok"/>';
				} else
					echo '<message type="error" value="test_action_insert_fail"/>';
			}
			echo '<test id="', $testId, '" name="', htmlspecialchars($test['name']), '"',
				' time="', $test['time'], '"';
			if ($test['deleted'])
				echo ' deleted="1"';
			echo '>';
			foreach ($db->select('test_actions', ['action_id', 'type', 'selector', 'data'], ['test_id' => $testId]) as $action)
				echo '<action type="', htmlspecialchars($action['type']), '" selector="', htmlspecialchars($action['selector']), '" data="', htmlspecialchars($action['data']), '" id="', $action['action_id'], '"/>';
			echo '</test>';
			$this->task_types();
		} else
			echo '<test><message type="error" value="bad_test_id"/></test>';
	}

	private function tasks() {
?>
<!--
	Tasks

	Add
	method: post
	params: test_id [type] [debug]
	submit: add

	Cancel
	method: post
	params: task_id
	submit: cancel
-->
<?php
		$db = $this->db;
		$userId = $this->user->getId();
		if (isset($_POST['add'])) {
			$testId = $_POST['test_id'];
			$type = null;
			if (isset($_POST['type']) && $_POST['type'])
				$type = $_POST['type'];
			$debug = false;
			if (isset($_POST['debug']) && $_POST['debug'])
				$debug = true;
			$taskMgr = new \AdvancedWebTesting\Task\Manager($db);
			if ($taskMgr->add($userId, $testId, $type, $debug))
				echo '<message type="notice" value="task_add_ok"/>';
			else
				echo '<message type="error" value="task_add_fail"/>';
		} else if (isset($_POST['cancel'])) {
			$taskId = $_POST['task_id'];
			if ($db->update('tasks', ['status' => \AdvancedWebTesting\Task\Status::CANCELED, 'time' => time()], ['user_id' => $userId, 'task_id' => $taskId, 'status' => \AdvancedWebTesting\Task\Status::INITIAL]))
				echo '<message type="notice" value="task_cancel_ok"/>';
			else
				echo '<message type="error" value="task_cancel_fail"/>';
		}
		echo '<tasks>';
		foreach ($db->select('tasks', ['task_id', 'test_id', 'test_name', 'type', 'debug', 'status', 'data', 'time'], ['user_id' => $userId]) as $task)
			echo '<task id="', $task['task_id'], '" test_id="', $task['test_id'], '"',
				' test_name="', htmlspecialchars($task['test_name']), '" type="', htmlspecialchars($task['type']), '"',
				' ', $task['debug'] ? ' debug="1"' : '', ' status="', \AdvancedWebTesting\Task\Status::toString($task['status']), '"',
				' time="', $task['time'], '"/>';
		echo '</tasks>';
		$this->task_types();
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
		if ($tasks = $db->select('tasks', ['status', 'data', 'test_id', 'test_name', 'type', 'debug', 'time'], ['user_id' => $userId, 'task_id' => $taskId])) {
			$task = $tasks[0];
			$status = $task['status'];
			echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" test_name="', htmlspecialchars($task['test_name']), '"',
				' ', $task['debug'] ? ' debug="1"' : '', ' type="', $task['type'], '" time="', $task['time'], '"',
				' status="', \AdvancedWebTesting\Task\Status::toString($status), '">';
			$failed = false;
			foreach ($db->select('task_actions', ['type', 'selector', 'data', 'action_id', 'scrn_filename', 'failed'], ['task_id' => $taskId]) as $action) {
				echo '<action type="', htmlspecialchars($action['type']), '" selector="', htmlspecialchars($action['selector']), '"',
					' data="', htmlspecialchars($action['data']), '" id="', $action['action_id'], '"';
				if ($action['scrn_filename'])
					echo ' scrn="', $task['data'] . '/' . $action['scrn_filename'], '"';
				if ($action['failed']) {
					echo ' failed="', htmlspecialchars($action['failed']), '"';
					$failed = true;
				} else if (($status == \AdvancedWebTesting\Task\Status::SUCCEEDED || $status == \AdvancedWebTesting\Task\Status::FAILED) && ($task['debug'] || !$failed))
					echo ' succeeded="1"';
				echo '/>';
			}
			echo '</task>';
			$this->task_types();
		} else
			echo '<task><message type="error" value="bad_task_id"/></task>';
	}

	private function task_types() {
		echo '<task_types>';
		foreach ($this->db->select('task_types', ['name', 'type_id', 'parent_type_id']) as $type)
			echo '<type name="', $type['name'], '" id="', $type['type_id'], '" parent_id="', $type['parent_type_id'], '"/>';
		echo '</task_types>';
	}

	private function schedule() {
?>
<!--
	Schedule

	Add
	method: post
	params: name test_id type start period
	submit: add

	Delete
	method: post
	params: id
	submit: delete

	Modify
	method: post
	params: id [name] [test_id] [type] [start] [period]
	submit: modify
-->
<?php
		$db = $this->db;
		$anacron = new \WebConstructionSet\Database\Relational\Anacron($db);
		$userId = $this->user->getId();
		if (isset($_POST['add']) && isset($_POST['test_id'])) {
			if ($db->select('tests', ['test_id'], ['test_id' => $_POST['test_id'], 'user_id' => $userId, 'deleted' => null]))
				if ($anacron->create(['start' => $_POST['start'], 'period' => $_POST['period'],
						'data' => ['test_id' => $_POST['test_id'], 'type' => $_POST['type'], 'name' => $_POST['name']]], $userId))
					echo '<message type="notice" value="sched_add_ok"/>';
				else
					echo '<message type="error" value="sched_add_fail"/>';
			else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['delete'])) {
			if ($anacron->delete($_POST['id'], $userId))
				echo '<message type="notice" value="sched_delete_ok"/>';
			else
				echo '<message type="error" value="sched_delete_fail"/>';
		} else if (isset($_POST['modify'])) {
			$task = [];
			foreach (['name', 'test_id', 'type'] as $param)
				if (isset($_POST[$param])) {
					$tasks = $anacron->get([$_POST['id']], $userId);
					if ($tasks)
						$task['data'] = $tasks[0]['data'];
					break;
				}
			foreach (['name', 'test_id', 'type'] as $param)
				if (isset($_POST[$param]))
					$task['data'][$param] = $_POST[$param];
			foreach (['start', 'period'] as $param)
				if (isset($_POST[$param]))
					$task[$param] = $_POST[$param];
			if ($anacron->update($_POST['id'], $task, $userId))
				echo '<message type="notice" value="sched_modify_ok"/>';
			else
				echo '<message type="error" value="sched_modify_fail"/>';
		}
		echo '<schedule>';
		foreach ($anacron->get(null, $userId) as $task)
			echo '<task id="', $task['id'], '" name="', $task['data']['name'], '"',
				' start="', $task['start'], '" period="', $task['period'], '"',
				' type="', htmlspecialchars($task['data']['type']), '" test_id="', $task['data']['test_id'], '"/>';
		echo '</schedule>';
		echo '<task_tests>';
		foreach ($db->select('tests', ['test_id', 'name'], ['user_id' => $userId, 'deleted' => null]) as $test)
			echo '<test name="', htmlspecialchars($test['name']), '" id="', $test['test_id'], '"/>';
		echo '</task_tests>';
		$this->task_types();
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