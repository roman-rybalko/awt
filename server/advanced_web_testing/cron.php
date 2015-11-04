<?php

namespace AdvancedWebTesting;

class Cron {
	private $db;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		$this->task();
		$this->mail();
		$this->billing();
		$this->purge();
	}

	private function billing() {
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		foreach ($userDb->get() as $user) {
			$userId = $user['id'];
			$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $userId);
			foreach ($billMgr->getPendingTransactions() as $pendingTransaction) {
				if ($pendingTransaction['payment_type'] == \AdvancedWebTesting\Billing\PaymentType::PAYPAL)
					continue;  // PayPal hack: транзакции PayPal обрабатываются на странице ?billing=1
				if (!$billMgr->processPendingTransaction($pendingTransaction['payment_type'], $pendingTransaction['id']))
					if (isset($pendingTransaction['subscription_id']))
						$billMgr->cancelSubscription($pendingTransaction['payment_type'], $pendingTransaction['subscription_id']);
			}
			/**
			 * Пользователь может за период тратить больше, чем пополняет подписка.
			 * Можно пополнять на сумму подписки плюс долг (отрицательный баланс),
			 * но пополнение из подписки каждый раз на разную сумму может вызвать вопросы у пользователя
			 * и реализация подписки может не поддерживать изменение суммы.
			 * По этому будем пополнять из подписки несколько раз подряд.
			 *
			 * processSubscription может генерировать транзакцию.
			 * В этом случае пополнение не зачислится сразу после вызова processSubscription.
			 * Вызывать processPendingTransaction нет смысла,
			 * т.к. транзакция может обрабатываться через callback, который моментально не приходит.
			 * Определяем количество вызовов processSubscription заранее.
			 *
			 * Выбираем подписку с максимальной суммой для уменьшения количества запросов.
			 */
			$actionsCnt = $billMgr->getAvailableActionsCnt();
			while ($actionsCnt <= 0 && $subscriptions = $billMgr->getSubscriptions()) {
				usort($subscriptions, function ($a, $b) {return $b['actions_cnt']-$a['actions_cnt'];});
				foreach ($subscriptions as $subscription)
					if ($billMgr->processSubscription($subscription['payment_type'], $subscription['id'])) {
						$actionsCnt += $subscription['actions_cnt'];
						break;
					} else
						$billMgr->cancelSubscription($subscription['payment_type'], $subscription['id']);
			}
		}
	}

	private function task() {
		$taskSched = new \AdvancedWebTesting\Task\Schedule($this->db, null);
		try {
			$taskSched->start();
		} catch (\Exception $e) {
			error_log($e);
		}
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, null);
		$taskMgr->restart(time() - \Config::TASK_TIMEOUT);
	}

	private function mail() {
		$mailMgr = new \AdvancedWebTesting\Mail\Manager($this->db, null);
		try {
			$mailMgr->send();
		} catch (\Exception $e) {
			error_log($e);
		}
	}

	private function purge() {

	}
}