<?php

namespace AdvancedWebTesting\User;

class Account {
	private $db, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->db = $db;
		$this->userId = $userId;
	}

	/**
	 * @return string XML
	 */
	public function delete() {
		$errors = '';

		// изменить логин на случайный
		// изенить пароль на случайный
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		if ($data = $userDb->get([$this->userId])) {
			$login = $data[0]['login'];
			if (!$userDb->rename($this->userId, '# ' . $login . ' ' . time() . ' ' . rand()))
				error_log(new \ErrorException('Mangle login failed, login: ' . $login . ', user_id:' . $this->userId, null, null, __FILE__, __LINE__));
			if (!$userDb->password($this->userId, rand() . rand() . rand()))
				error_log(new \ErrorException('Mangle password failed, user_id:' . $this->userId, null, null, __FILE__, __LINE__));
		}

		// удалить E-Mail (если есть)
		$settMgr = new \AdvancedWebTesting\Settings\Manager($this->db, $this->userId);
		$settMgr->set('', false, false);  // не проверяем - может вызваться повторно

		// удалить все задачи расписания
		$taskSched = new \AdvancedWebTesting\Task\Schedule($this->db, $this->userId);
		foreach ($taskSched->get() as $sched)
			$taskSched->delete($sched['id']);  // не проверяем - кто-то уже удалил

		// отменить все подписки и транзакции в биллинге
		$billMgr = new \AdvancedWebTesting\Billing\Manager($this->db, $this->userId);
		foreach ($billMgr->getSubscriptions() as $subscription)
			$billMgr->cancelSubscription($subscription['payment_type'], $subscription['id']);  // не проверяем - кто-то уже отменил
		foreach ($billMgr->getPendingTransactions() as $pendingTransaction)
			$billMgr->cancelPendingTransaction($pendingTransaction['payment_type'], $pendingTransaction['id']);  // не проверяем - кто-то уже удалил

		// сделать refund по размеру баланса
		if ($billMgr->getAvailableActionsCnt() > 0) {
			$transactions = $billMgr->getTransactions();
			usort($transactions, function ($a, $b) {return $b['time']-$a['time'];});
			foreach ($transactions as $transaction)
				if (isset($transaction['refundable']) && $transaction['refundable'])
					if (!$billMgr->refund($transaction['id']))
						break;  // баланс нулевой
		}

		// отменить все задачи в очереди на выполнение
		$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $this->userId);
		foreach ($taskMgr->get() as $task)
			if ($task['status'] == \AdvancedWebTesting\Task\Status::INITIAL)
				$taskMgr->cancel($task['id']);  // не проверяем - может начать выполняться

		return $errors;
	}
}
