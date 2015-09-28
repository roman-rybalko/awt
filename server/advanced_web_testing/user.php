<?php

namespace AdvancedWebTesting;

/**
 * Интерфейс <user/>
 * View, Controller (MVC)
 */
class User {
	private $db, $userId;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		$user = new \WebConstructionSet\Accounting\User($userDb);
		$this->userId = $user->getId();
		if ($this->userId) {
			echo '<user login="', htmlspecialchars($user->getLogin()), '">';
?>
<!--
	Logout
	action: ?logout=1

	Settings
	action: ?settings=1

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

	Stats
	action: index
-->
<?php
			if (isset($_GET['logout'])) {
				$this->logout($user);
			} else if (isset($_GET['stats'])) {
				$this->stats();
			} else if (isset($_GET['settings'])) {
				$this->settings($userDb);
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
				$this->stats();
			}
		} else {
			echo '<user>';
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
			if ($_POST['password1'] !== $_POST['password2']) {
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

	private function settings($userDb) {
?>
<!--
	Settings

	Change password
	method: post
	params: password password2

	Change e-mail
	method: post
	params: email

	Change e-mail (commit)
	method: get
	params: email_code

	On/Off e-mail reports on task failure
	method: post
	params: task_fail_email_report (0/1)

	On/Off e-mail reports on task success
	method: post
	params: task_success_email_report (0/1)
-->
<?php
		$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $this->userId);
		if (isset($_POST['password'])) {
			if ($_POST['password'] === $_POST['password2']) {
				if ($userDb->password($this->userId, $_POST['password']))
					echo '<message type="notice" value="password_modify_ok"/>';
				else
					echo '<message type="error" value="password_modify_fail"/>';
			} else
				echo '<message type="error" value="passwords_dont_match"/>';
		}
		if (isset($_POST['task_fail_email_report']) || isset($_POST['task_success_email_report'])) {
			if ($settMgr->set(
				null,
				isset($_POST['task_fail_email_report']) ? $_POST['task_fail_email_report'] : null,
				isset($_POST['task_success_email_report']) ? $_POST['task_success_email_report'] : null
			))
				echo '<message type="notice" value="settings_modify_ok"/>';
			else
				echo '<message type="error" value="settings_modify_fail"/>';
		}
		if (isset($_POST['email'])) {
			$_SESSION['settings_email'] = $_POST['email'];
			$_SESSION['settings_email_code'] = rand();
			$mailMgr = new \AdvancedWebTesting\Mail\Manager($this->db, $this->userId);
			if ($mailMgr->scheduleEmailVerification($_POST['email'],
				\WebConstructionSet\Url\Tools::addParams(
					\WebConstructionSet\Url\Tools::getMyUrl(), ['email_code' => $_SESSION['settings_email_code']])))
				echo '<message type="notice" value="email_verification_pending"/>';
			else
				echo '<message type="error" value="email_modify_fail"/>';
		}
		if (isset($_GET['email_code'])) {
			if (isset($_SESSION['settings_email_code']) && $_SESSION['settings_email_code'] == $_GET['email_code']) {
				if ($settMgr->set($_SESSION['settings_email']))
					echo '<message type="notice" value="email_modify_ok"/>';
				else
					echo '<message type="error" value="email_modify_fail"/>';
				unset($_SESSION['settings_email_code']);
				unset($_SESSION['settings_email']);
			} else
				echo '<message type="error" value="bad_email_code"/>';
			$this->redirect('?settings=1');
			return;
		}
		echo '<settings';
		foreach ($settMgr->get() as $name => $value)
			echo ' ', $name, '="', htmlspecialchars($value), '"';
		echo '/>';
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
					$testActMgrSrc = new \AdvancedWebTesting\Test\Action\Manager($this->db, $_POST['id']);
					$testActMgrDst = new \AdvancedWebTesting\Test\Action\Manager($this->db, $testId);
					$testActMgrDst->import($testActMgrSrc->get());
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
			echo '<message type="error" value="bad_test_id"/><test/>';
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
					echo '<message type="error" value="no_funds"/>';
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
		$task = new \AdvancedWebTesting\User\Task($this->db, $this->userId);
		echo $task->get($_GET['task']);
		$this->task_types();
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
		$taskSched = new \AdvancedWebTesting\Task\Schedule($this->db, $this->userId);
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		if (isset($_POST['add'])) {
			if ($tests = $testMgr->get([$_POST['test_id']])) {
				$test = $tests[0];
				if ($schedId = $taskSched->add($_POST['start'], $_POST['period'], $_POST['test_id'], $_POST['type'], $_POST['name'])) {
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
			if ($scheds = $taskSched->get([$_POST['id']])) {
				$sched = $scheds[0];
				if ($taskSched->delete($_POST['id'])) {
					echo '<message type="notice" value="sched_delete_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					if ($tests = $testMgr->get([$sched['test_id']]))
						$test = $tests[0];
					else
						$test = ['name' => '__deleted__', 'deleted' => true];
					$histMgr->add('sched_delete', ['sched_id' => $_POST['id'], 'sched_name' => $sched['name'],
						'test_id' => $sched['test_id'], 'test_name' => $test['name'], 'test_deleted' => $test['deleted'],
						'type' => $sched['type'], 'start' => $sched['start'], 'period' => $sched['period']]);
				} else
					echo '<message type="error" value="sched_delete_fail"/>';
			} else
				echo '<message type="error" value="bad_sched_id"/>';
		} else if (isset($_POST['modify'])) {
			if ($scheds = $taskSched->get([$_POST['id']])) {
				$sched = $scheds[0];
				if ($taskSched->modify($_POST['id'],
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'start', $sched['start']),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'period', $sched['period']),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'test_id', $sched['test_id']),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'type', $sched['type']),
					\AdvancedWebTesting\Tools::valueOrNull($_POST, 'name', $sched['name']))
				) {
					echo '<message type="notice" value="sched_modify_ok"/>';
					$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $this->userId);
					$event = [];
					foreach (['start' => 'start', 'period' => 'period', 'name' => 'sched_name', 'test_id' => 'test_id', 'type' => 'type'] as $param => $evParam)
						if (\AdvancedWebTesting\Tools::valueOrNull($_POST, $param, $sched[$param]) !== null) {
							$event[$evParam] = $_POST[$param];
							$event['old_' . $evParam] = $sched[$param];
						} else
							$event[$evParam] = $sched[$param];
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
		foreach ($taskSched->get() as $sched)
			echo '<task id="', $sched['id'], '" name="', $sched['name'], '"',
				' start="', $sched['start'], '" period="', $sched['period'], '"',
				' type="', htmlspecialchars($sched['type']), '" test_id="', $sched['test_id'], '"/>';
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

	Top Up (Test)
	method: post
	params: actions amount
	submit: top_up

	Service Charge
	method: post
	params actions data
	submit: service
-->
<?php
		$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $this->userId);
		if (isset($_POST['top_up'])) {
			if ($billMgr->topUp($_POST['actions'], \AdvancedWebTesting\Billing\PaymentType::MANUAL, $_POST['amount'], 'test'))
				echo '<message type="notice" value="top_up_ok"/>';
			else
				echo '<message type="error" value="top_up_fail"/>';
		} else if (isset($_POST['service'])) {
			if ($billMgr->service($_POST['actions'], $_POST['data']))
				echo '<message type="notice" value="service_ok"/>';
			else
				echo '<message type="error" value="service_fail"/>';
		}
		echo '<billing actions_available="', $billMgr->getActionsCount(), '">';
		foreach ($billMgr->getTransactions() as $transaction) {
			echo '<transaction id="', $transaction['id'], '" type="', \AdvancedWebTesting\Billing\TransactionType::toString($transaction['type']), '"',
				' time="', $transaction['time'], '"',
				' actions_before="', $transaction['actions_before'], '"',
				' actions_after="', $transaction['actions_after'], '"',
				' actions="', $transaction['actions'], '"';
			switch ($transaction['type']) {
				case \AdvancedWebTesting\Billing\TransactionType::SERVICE:
					echo ' data="', htmlspecialchars($transaction['data']), '"';
					break;
				case \AdvancedWebTesting\Billing\TransactionType::TOP_UP:
					echo ' payment_type="', \AdvancedWebTesting\Billing\PaymentType::toString($transaction['payment_type']), '"',
						' payment_amount="', $transaction['payment_amount'], '"',
						' payment_data="', htmlspecialchars($transaction['payment_data']), '"';
					break;
				case \AdvancedWebTesting\Billing\TransactionType::TASK_START:
				case \AdvancedWebTesting\Billing\TransactionType::TASK_END:
					echo ' task_id="', $transaction['task_id'], '"',
						' test_name="', htmlspecialchars($transaction['test_name']), '"';
					break;
			}
			echo '/>';
		}
		echo '</billing>';
	}

	private function stats() {
?>
<!--
	Stats
-->
<?php
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $this->userId);
		$testsCnt = 0;
		$testIds = [];
		foreach ($testMgr->get() as $test)
			if (!$test['deleted']) {
				++$testsCnt;
				$testIds[$test['id']] = true;
			}
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $this->userId);
		$tasksCnt = 0;
		foreach ($taskMgr->get() as $task)
			if ($task['status'] == \AdvancedWebTesting\Task\Status::FAILED || $task['status'] == \AdvancedWebTesting\Task\Status::SUCCEEDED)
				++$tasksCnt;
		$schedMgr = new \AdvancedWebTesting\Task\Schedule($this->db, $this->userId);
		$schedsCnt = 0;
		foreach ($schedMgr->get() as $sched)
			if (isset($testIds[$sched['test_id']]))
				++$schedsCnt;
		$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $this->userId);
		echo '<stats tests="', $testsCnt, '" tasks_finished="', $tasksCnt, '" scheds="', $schedsCnt, '"',
			' actions_available="', $billMgr->getActionsCount(), '">';
		$statMgr = new \AdvancedWebTesting\Stat\Manager($this->db, $this->userId);
		$stats = $statMgr->get();
		foreach ($stats as $stat)
			echo '<stat time="', $stat['time'], '" tasks_finished="', $stat['tasks_finished'], '"',
				' tasks_failed="', $stat['tasks_failed'], '" task_actions_executed="', $stat['task_actions_executed'], '"/>';
		echo '</stats>';
	}
}
