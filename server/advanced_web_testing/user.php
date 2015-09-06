<?php

namespace AdvancedWebTesting;

/**
 * Интерфейс <user/>
 * View, Controller (MVC)
 */
class User {
	private $db, $userId;

	public function __construct() {
		$this->db = $db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		echo '<user>';
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		$user = new \WebConstructionSet\Accounting\User($userDb);
		$this->userId = $user->getId();
		if ($this->userId) {
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

	History
	action: ?history=1

	Billing
	action: ?billing=1

	Dashboard
	action: index
-->
<?php
			if (isset($_GET['logout'])) {
				$this->logout($user);
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
			} else if (isset($_GET['history'])) {
				$this->history();
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
				$this->register($user);
			} else {
				$this->login($user);
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

	private function login(\WebConstructionSet\Accounting\User $user) {
?>
<!--
	Login
	method: post
	params: user password
	submit: login
-->
<?php
		if (isset($_POST['login'])) {
			if ($user->login($_POST['user'], $_POST['password'])) {
				$this->userId = $user->getId();
				echo '<message type="notice" value="login_ok"/>';
				$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
				$histMgr->add('login', ['ip' => $_SERVER['REMOTE_ADDR'], 'ua' => $_SERVER['HTTP_USER_AGENT']]);
				$this->redirect('');
			} else {
				echo '<message type="error" value="bad_login"/>';
				$this->redirect('', 3);
			}
		} else {
			echo '<login/>';
		}
	}

	private function register(\WebConstructionSet\Accounting\User $user) {
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
				if ($user->register($_POST['user'], $_POST['password1'])) {
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

	private function logout(\WebConstructionSet\Accounting\User $user) {
?>
<!--
	Logout
-->
<?php
		$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
		$histMgr->add('logout', []);
		$user->logout();
		unset($this->userId);
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
	params: id
	submit: delete

	Restore
	method: post
	params: id
	submit: restore

	Rename
	method: post
	params: id name
	submit: rename

	Copy
	method: post
	params: id name
	submit: copy
-->
<?php
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		if (isset($_POST['add'])) {
			if ($testId = $testMgr->add($_POST['name'])) {
				echo '<message type="notice" value="test_add_ok"/>';
				$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
				$histMgr->add('test_add', ['test_id' => $testId, 'test_name' => $_POST['name']]);
				$this->redirect('?test=' . $testId);
				return;
			} else
				echo '<message type="error" value="test_add_fail"/>';
		} else if (isset($_POST['delete'])) {
			if ($tests = $testMgr->get([$_POST['id']])) {
				$test = $tests[0];
				if ($testMgr->delete($_POST['id'])) {
					echo '<message type="notice" value="test_delete_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('test_delete', ['test_id' => $_POST['id'], 'test_name' => $test['name']]);
				} else
					echo '<message type="error" value="test_delete_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['restore'])) {
			if ($tests = $testMgr->get([$_POST['id']])) {
				$test = $tests[0];
				if ($testMgr->restore($_POST['id'])) {
					echo '<message type="notice" value="test_restore_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('test_restore', ['test_id' => $_POST['id'], 'test_name' => $test['name']]);
				} else
					echo '<message type="error" value="test_restore_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['rename'])) {
			if ($tests = $testMgr->get([$_POST['id']])) {
				$test = $tests[0];
				if ($testMgr->rename($_POST['id'], $_POST['name'])) {
					echo '<message type="notice" value="test_rename_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('test_rename', ['test_id' => $_POST['id'], 'test_name' => $_POST['name'], 'old_test_name' => $test['name']]);
				} else
					echo '<message type="error" value="test_rename_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['copy'])) {
			if ($tests = $testMgr->get([$_POST['id']])) {
				$test = $tests[0];
				if ($testId = $testMgr->add($_POST['name'])) {
					$testActMgr = new \AdvancedWebTesting\Test\Action\Manager($this->db, $_POST['id']);
					$testActMgr->copy($testId);
					echo '<message type="notice" value="test_copy_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('test_copy', ['test_id' => $testId, 'test_name' => $_POST['name'],
						'orig_test_name' => $test['name'], 'orig_test_id' => $_POST['id']]);
				} else
					echo '<message type="error" value="test_copy_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		}
		echo '<tests>';
		foreach ($testMgr->get() as $test) {
			echo '<test name="', htmlspecialchars($test['name']), '" id="', $test['id'], '"',
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
	params: id
	submit: delete

	Modify
	method: post
	params: id [selector] [data]
	submit: modify

	Insert
	method: post
	params: [id] type selector data
	submit: insert
-->
<?php
		$testId = $_GET['test'];
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		if ($tests = $testMgr->get([$testId])) {
			$test = $tests[0];
			$testActMgr = new \AdvancedWebTesting\Test\Action\Manager($this->db, $testId);
			if (isset($_POST['add'])) {
				$actionId = $testActMgr->add($_POST['type'],
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'selector'),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'data'));
				echo '<message type="notice" value="test_action_add_ok"/>';
				$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
				$event = [];
				foreach(['selector', 'data'] as $field)
					if (isset($_POST[$field]))
						$event[$field] = $_POST[$field];
				$histMgr->add('test_action_add', array_merge([
						'test_id' => $testId, 'test_name' => $test['name'],
						'action_id' => $actionId, 'type' => $_POST['type']], $event));
			} else if (isset($_POST['delete'])) {
				$actionId = $_POST['id'];
				if ($actions = $testActMgr->get([$actionId])) {
					$action = $actions[0];
					if ($testActMgr->delete($actionId)) {
						echo '<message type="notice" value="test_action_delete_ok"/>';
						$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
						$event = [];
						foreach (['type', 'selector', 'data'] as $field)
							if (isset($action[$field]))
								$event[$field] = $action[$field];
						$histMgr->add('test_action_delete', array_merge([
							'test_id' => $testId, 'test_name' => $test['name'],
							'action_id' => $actionId], $event));
					} else
						echo '<message type="error" value="test_action_delete_fail"/>';
				} else
					echo '<message type="error" value="bad_action_id"/>';
			} else if (isset($_POST['modify'])) {
				$actionId = $_POST['id'];
				if ($actions = $testActMgr->get([$actionId])) {
					$action = $actions[0];
					if ($testActMgr->modify($actionId,
						\AdvancedWebTesting\Tools::valueOrNull($_POST, 'selector', $action['selector']),
						\AdvancedWebTesting\Tools::valueOrNull($_POST, 'data', $action['data']))
					) {
						echo '<message type="notice" value="test_action_modify_ok"/>';
						$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
						$event = ['type' => $action['type']];
						foreach (['selector', 'data'] as $field)
							if (\AdvancedWebTesting\Tools::valueOrNull($_POST, $field, $action[$field]) !== null) {
								$event[$field] = $_POST[$field];
								$event['old_' . $field] = $action[$field];
							} else
								if ($action[$field] !== null)
									$event[$field] = $action[$field];
						$histMgr->add('test_action_modify', array_merge([
							'test_id' => $testId, 'test_name' => $test['name'],
							'action_id' => $actionId], $event));
					} else
						echo '<message type="error" value="test_action_modify_fail"/>';
				} else
					echo '<message type="error" value="bad_action_id"/>';
			} else if (isset($_POST['insert'])) {
				$actionId = $_POST['id'];
				if ($testActMgr->insert($actionId, $_POST['type'],
						\AdvancedWebTesting\Tools::valueOrNull($_POST, 'selector'),
						\AdvancedWebTesting\Tools::valueOrNull($_POST, 'data'))
				) {
					echo '<message type="notice" value="test_action_insert_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$event = ['type' => $_POST['type']];
					foreach (['selector', 'data'] as $field)
						if (isset($_POST[$field]))
							$event[$field] = $_POST[$field];
					$histMgr->add('test_action_insert', array_merge([
						'test_id' => $testId, 'test_name' => $test['name'],
						'action_id' => $actionId], $event));
				} else
					echo '<message type="error" value="test_action_insert_fail"/>';
			}
			echo '<test id="', $testId, '" name="', htmlspecialchars($test['name']), '"',
				' time="', $test['time'], '"';
			if ($test['deleted'])
				echo ' deleted="1"';
			echo '>';
			foreach ($testActMgr->get() as $action) {
				echo '<action id="', $action['id'], '" type="', htmlspecialchars($action['type']), '"';
				foreach (['selector', 'data'] as $param)
					if ($action[$param] !== null)
						echo ' ', $param, '="', htmlspecialchars($action[$param]), '"';
				echo '/>';
			}
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
	params: test_id type [debug]
	submit: add

	Cancel
	method: post
	params: task_id
	submit: cancel
-->
<?php
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $this->userId);
		if (isset($_POST['add'])) {
			$testId = $_POST['test_id'];
			$type = $_POST['type'];
			$debug = false;
			if (isset($_POST['debug']) && $_POST['debug'])
				$debug = true;
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
			if ($tests = $testMgr->get([$testId])) {
				$test = $tests[0];
				if ($taskId = $taskMgr->add($testId, $test['name'], $type, $debug)) {
					echo '<message type="notice" value="task_add_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('task_add', ['task_id' => $taskId,
						'test_id' => $testId, 'test_name' => $test['name'],
						'type' => $type]);
				} else
					echo '<message type="error" value="task_add_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['cancel'])) {
			$taskId = $_POST['task_id'];
			if ($tasks = $taskMgr->get([$taskId])) {
				$task = $tasks[0];
				if ($taskMgr->cancel($taskId)) {
					echo '<message type="notice" value="task_cancel_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('task_cancel', ['task_id' => $taskId,
						'test_id' => $task['test_id'], 'test_name' => $task['test_name']]);
				} else
					echo '<message type="error" value="task_cancel_fail"/>';
			} else
				echo '<message type="error" value="bad_task_id"/>';
		}
		echo '<tasks>';
		foreach ($taskMgr->get() as $task)
			echo '<task id="', $task['id'], '" test_id="', $task['test_id'], '"',
				' test_name="', htmlspecialchars($task['test_name']), '"',
				' type="', htmlspecialchars($task['type']), '"',
				' ', $task['debug'] ? ' debug="1"' : '',
				' status="', \AdvancedWebTesting\Task\Status::toString($task['status']), '"',
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
		$taskId = $_GET['task'];
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $this->userId);
		if ($tasks = $taskMgr->get([$taskId])) {
			$task = $tasks[0];
			$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $taskId);
			echo '<task id="', $taskId, '" test_id="', $task['test_id'], '" test_name="', htmlspecialchars($task['test_name']), '"',
				' ', $task['debug'] ? ' debug="1"' : '', ' type="', $task['type'], '" time="', $task['time'], '"',
				' status="', \AdvancedWebTesting\Task\Status::toString($task['status']), '">';
			foreach ($taskActMgr->get() as $action) {
				echo '<action id="', $action['id'], '" type="', htmlspecialchars($action['type']), '"';
				foreach (['selector', 'data'] as $param)
					if ($action[$param] !== null)
						echo ' ', $param, '="', htmlspecialchars($action[$param]), '"';
				if ($action['scrn'])
					echo ' scrn="', $task['result'] . '/' . $action['scrn'], '"';
				if ($action['failed'])
					echo ' failed="', htmlspecialchars($action['failed']), '"';
				if ($action['succeeded'])
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
		$typeMgr = new \AdvancedWebTesting\Task\Type\Manager($this->db);
		foreach ($typeMgr->get() as $type)
			echo '<type name="', $type['name'], '" id="', $type['id'], '" parent_id="', $type['parent_id'], '"/>';
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
		$schedMgr = new \AdvancedWebTesting\Schedule\Manager($this->db, $this->userId);
		if (isset($_POST['add']) && isset($_POST['test_id'])) {
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
			if ($tests = $testMgr->get([$_POST['test_id']])) {
				$test = $tests[0];
				if ($schedId = $schedMgr->add($_POST['start'], $_POST['period'],
					['test_id' => $_POST['test_id'], 'type' => $_POST['type'], 'name' => $_POST['name']])
				) {
					echo '<message type="notice" value="sched_add_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$histMgr->add('sched_add', ['sched_id' => $schedId, 'sched_name' => $_POST['name'],
						'test_id' => $_POST['test_id'], 'test_name' => $test['name'], 'test_deleted' => $test['deleted'],
						'type' => $_POST['type'], 'start' => $_POST['start'], 'period' => $_POST['period']]);
				} else
					echo '<message type="error" value="sched_add_fail"/>';
			} else
				echo '<message type="error" value="bad_test_id"/>';
		} else if (isset($_POST['delete'])) {
			if ($scheds = $schedMgr->get([$_POST['id']])) {
				$sched = $scheds[0];
				if ($schedMgr->delete($_POST['id'])) {
					echo '<message type="notice" value="sched_delete_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
					if ($tests = $testMgr->get([$sched['data']['test_id']]))
						$test = $tests[0];
					else
						$test = ['name' => '__deleted__', 'deleted' => true];
					$histMgr->add('sched_delete', ['sched_id' => $_POST['id'], 'sched_name' => $sched['data']['name'],
						'test_id' => $sched['data']['test_id'], 'test_name' => $test['name'], 'test_deleted' => $test['deleted'],
						'type' => $sched['data']['type'], 'start' => $sched['start'], 'period' => $sched['period']]);
				} else
					echo '<message type="error" value="sched_delete_fail"/>';
			} else
				echo '<message type="error" value="bad_sched_id"/>';
		} else if (isset($_POST['modify'])) {
			if ($scheds = $schedMgr->get([$_POST['id']])) {
				$sched = $scheds[0];
				$data = null;
				foreach (['name', 'test_id', 'type'] as $param)
					if (\AdvancedWebTesting\Tools::valueOrNull($_POST, $param, $sched['data'][$param]) !== null) {
						if ($data === null)
							$data = $sched['data'];
						$data[$param] = $_POST[$param];
					}
				if ($schedMgr->modify($_POST['id'],
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'start', $sched['start']),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'period', $sched['period']),
					$data)
				) {
					echo '<message type="notice" value="sched_modify_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$event = [];
					foreach (['start', 'period'] as $param)
						if (\AdvancedWebTesting\Tools::valueOrNull($_POST, $param, $sched[$param]) !== null) {
							$event[$param] = $_POST[$param];
							$event['old_' . $param] = $sched[$param];
						} else
							$event[$param] = $sched[$param];
					foreach (['name' => 'sched_name', 'test_id' => 'test_id', 'type' => 'type'] as $param => $evParam)
						if (\AdvancedWebTesting\Tools::valueOrNull($_POST, $param, $sched['data'][$param]) !== null) {
							$event[$evParam] = $_POST[$param];
							$event['old_' . $evParam] = $sched['data'][$param];
						} else
							$event[$evParam] = $sched['data'][$param];
					$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
					if ($tests = $testMgr->get([$event['test_id']]))
						$event['test_name'] = $tests[0]['name'];
					else
						$event['test_name'] = '__deleted__';
					if (isset($event['old_test_id']))
						if ($tests = $testMgr->get([$event['old_test_id']]))
							$event['old_test_name'] = $tests[0]['name'];
						else
							$event['old_test_name'] = '__deleted__';
					$histMgr->add('sched_modify', array_merge(['sched_id' => $_POST['id']], $event));
				} else
					echo '<message type="error" value="sched_modify_fail"/>';
			} else
				echo '<message type="error" value="bad_sched_id"/>';
		}
		echo '<schedule>';
		foreach ($schedMgr->get() as $sched)
			echo '<task id="', $sched['id'], '" name="', $sched['data']['name'], '"',
				' start="', $sched['start'], '" period="', $sched['period'], '"',
				' type="', htmlspecialchars($sched['data']['type']), '" test_id="', $sched['data']['test_id'], '"/>';
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		foreach ($testMgr->get() as $test)
			if (!$test['deleted'])
				echo '<test name="', htmlspecialchars($test['name']), '" id="', $test['id'], '"/>';
		echo '</schedule>';
		$this->task_types();
	}

	private function history() {
?>
<!--
	History
-->
<?php
		echo '<history>';
		$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
		foreach ($histMgr->get() as $event) {
			echo '<event name="', htmlspecialchars($event['name']), '" time="', $event['time'], '"';
			foreach ($event['data'] as $param => $value)
				echo ' ', $param, '="', htmlspecialchars($value), '"';
			echo '/>';
		}
		echo '</history>';
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