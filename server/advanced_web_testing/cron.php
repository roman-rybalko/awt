<?php

namespace AdvancedWebTesting;

class Cron {
	private $db;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		$this->stats();
		$this->tests();
		$this->tasks();
		$this->history();
		$this->mail();
		$this->billing();
		$this->accounts();
		$this->testGroups();
	}

	private function stats() {
		// Purge
		$statMgr = new \AdvancedWebTesting\Stats\Manager($this->db, null);
		$statMgr->clear(time() - \Config::PURGE_PERIOD * 86400);
	}

	private function tests() {
		// Purge
		$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, null);
		$tests = $testMgr->clear1(time() - \Config::PURGE_PERIOD * 86400);
		foreach ($tests as $test) {
			$testActMgr = new \AdvancedWebTesting\Test\Action\Manager($this->db, $test['id']);
			$testActMgr->clear();
		}
		$testMgr->clear2($tests);
	}

	private function tasks() {
		// Schedule
		$taskSched = new \AdvancedWebTesting\Task\Schedule($this->db, null);
		try {
			$taskSched->start();
		} catch (\Exception $e) {
			error_log($e);
		}
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, null);
		$taskMgr->restart(time() - \Config::TASK_TIMEOUT);

		// Purge
		$tasks = $taskMgr->clear1(time() - \Config::PURGE_PERIOD * 86400);
		foreach ($tasks as $task) {
			$taskActMgr = new \AdvancedWebTesting\Task\Action\Manager($this->db, $task['id']);
			if ($task['result']) {
				$actions = $taskActMgr->get();
				foreach ($actions as $action)
					if ($action['scrn'])
						unlink(\Config::$rootPath . \Config::RESULTS_PATH . $task['result'] . '/' . $action['scrn']);  // E_WARNING
				rmdir(\Config::$rootPath . \Config::RESULTS_PATH . $task['result']);  // E_WARNING
			}
			$taskActMgr->clear();
		}
		$taskMgr->clear2($tasks);
	}

	private function history() {
		// Purge
		$histMgr = new \AdvancedWebTesting\History\Manager($this->db, null);
		$histMgr->clear(time() - \Config::PURGE_PERIOD * 86400);
	}

	private function mail() {
		$mailMgr = new \AdvancedWebTesting\Mail\Manager($this->db, null);
		try {
			$mailMgr->send();
		} catch (\Exception $e) {
			error_log($e);
		}
	}

	private function billing() {
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		foreach ($userDb->get() as $user) {
			$userId = $user['id'];
			$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $userId);
			foreach ($billMgr->getPendingTransactions() as $pendingTransaction) {
				if ($pendingTransaction['time'] + \Config::BILLING_PENDING_PURGE_PERIOD * 86400 < time()) {
					$billMgr->cancelPendingTransaction($pendingTransaction['payment_type'], $pendingTransaction['id']);
					continue;
				}
				if (isset($pendingTransaction['code']))
					continue;  // authorization code is required - interactive only
				if ($pendingTransaction['payment_type'] == \AdvancedWebTesting\Billing\PaymentType::PAYPAL)
					continue;  // PayPal hack: транзакции PayPal обрабатываются на странице ?billing=1
				$billMgr->processPendingTransaction($pendingTransaction['payment_type'], $pendingTransaction['id']);
			}
			/**
			 * Пользователь может за период тратить больше, чем пополняет подписка.
			 * Можно пополнять на сумму подписки плюс долг (отрицательный баланс),
			 * но пополнение из подписки каждый раз на разную сумму может вызвать вопросы у пользователя
			 * и реализация подписки может не поддерживать изменение суммы.
			 * По этому будем пополнять из подписки несколько раз подряд.
			 *
			 * Выбираем подписку с максимальной суммой для уменьшения количества запросов.
			 */
			while ($billMgr->getAvailableActionsCnt() <= 0 && $subscriptions = $billMgr->getSubscriptions()) {
				usort($subscriptions, function ($a, $b) {return $b['actions_cnt']-$a['actions_cnt'];});
				foreach ($subscriptions as $subscription)
					if ($billMgr->processSubscription($subscription['payment_type'], $subscription['id']))
						break;
			}
		}

		// Purge
		$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, null);
		$billMgr->clear(time() - \Config::BILLING_PURGE_PERIOD * 86400);
	}

	private function accounts() {
		// Purge
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		foreach ($userDb->get() as $user) {
			$userId = $user['id'];
			// not: users.time старше purge period
			if ($user['time'] >= time() - \Config::PURGE_PERIOD * 86400)
				continue;
			$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $userId);
			$settings = $settMgr->get();
			// not: аккант возможно удалить (undeletable != 1)
			if ($settings['undeletable'])
				continue;
			// not: нет E-mail
			if (!empty($settings['email']))
				continue;
			$testMgr = new \AdvancedWebTesting\Test\Manager($this->db, $userId);
			// not: нет тестов
			if ($testMgr->get())
				continue;
			$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $userId);
			// not: баланс <= 0
			if ($billMgr->getAvailableActionsCnt() > 0)
				continue;
			// not: отсутствуют pending transactions
			if ($billMgr->getPendingTransactions())
				continue;
			// not: отсутствуют subscriptions
			if ($billMgr->getSubscriptions())
				continue;
			if ($userDb->delete($userId))
				error_log('Stale user deleted: ' . json_encode($user));

			// Purge Settings
			$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $userId);
			$settMgr->clear();
		}
	}

	private function testGroups() {
		// Purge
		$testGrpMgr = new \AdvancedWebTesting\TestGroup\Manager($this->db, null);
		$testGrps = $testGrpMgr->clear1(time() - \Config::PURGE_PERIOD * 86400);
		foreach ($testGrps as $testGrp) {
			$tgTestMgr = new \AdvancedWebTesting\TestGroup\Test\Manager($this->db, $testGrp['id']);
			$tgTestMgr->clear();
		}
		$testGrpMgr->clear2($testGrps);
	}
}