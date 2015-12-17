<?php

namespace AdvancedWebTesting\Billing;

/**
 * Финансы
 * Model (MVC)
 */
class Manager {
	private $billing, $paymentBackends;

	/**
	 * @param \WebConstructionSet\Database\Relational $db
	 * @param integer $userId not null (processSubscription() требует userId для привязки транзакции к пользователю)
	 */
	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->billing = new \WebConstructionSet\Database\Relational\Billing($db, 0, $userId);
		$this->paymentBackends[PaymentType::DEMO] = new PaymentBackend\Demo($db, $userId);
		$this->paymentBackends[PaymentType::PAYPAL] = new PaymentBackend\Paypal($db, $userId);
		$this->paymentBackends[PaymentType::WEBMONEY] = new PaymentBackend\Webmoney($db, $userId);
	}

	/**
	 * Списывает средства за запуск
	 * @param integer $taskId
	 * @param string $testName
	 * @param $schedId
	 * @param $schedName
	 * @return integer|null transactionId
	 */
	public function startTask($taskId, $testName, $schedId = null, $schedName = null) {
		$fields = ['type' => TransactionType::TASK_START, 'task_id' => $taskId, 'test_name' => $testName];
		if ($schedId !== null) {
			$fields['sched_id'] = $schedId;
			$fields['sched_name'] = $schedName;
		}
		$transactionId = $this->billing->transaction(- Price::TASK_START, $fields);
		if ($transactionId && $this->billing->commit($transactionId))
			return $transactionId;
		return null;
	}

	/**
	 * Списывает средства за Actions
	 * @param integer $taskId
	 * @param string $taskName
	 * @param integer $actionsCnt
	 * @return integer|null transactionId
	 */
	public function finishTask($taskId, $testName, $actionsCnt) {
		$transactionId = $this->billing->transaction(- Price::TASK_ACTION * $actionsCnt,
			['type' => TransactionType::TASK_FINISH, 'task_id' => $taskId, 'test_name' => $testName]);
		if ($transactionId && $this->billing->commit($transactionId))
			return $transactionId;
		return null;
	}

	/**
	 * Изменение баланса вручную
	 * @param integer $actionsCnt
	 * @param string $data
	 * @return integer|null transactionId
	 */
	public function service($actionsCnt, $data) {
		$transactionId = $this->billing->transaction($actionsCnt, ['type' => TransactionType::SERVICE, 'data' => $data]);
		if ($transactionId && $this->billing->commit($transactionId))
			return $transactionId;
		return null;
	}

	/**
	 * Получить количество доступных Actions
	 * @return integer
	 */
	public function getAvailableActionsCnt() {
		return $this->billing->getAmount();
	}

	/**
	 * Пополнить
	 * @param integer $actionsCnt
	 * @param integer $paymentType
	 * @param boolean $subscription
	 * @return integer|null pendingTransactionId
	 */
	public function topUp($actionsCnt, $paymentType, $subscription) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return null;
		$fields = ['type' => TransactionType::TOP_UP, 'payment_type' => $paymentType];
		$transactionId = $this->billing->transaction($actionsCnt, $fields);
		if (!$transactionId)
			return null;
		if ($subscription)
			$subscription = 'Subscription / Recurring payments / Auto Top Up when the account balance gets low (' . $_SERVER['SERVER_NAME'] . ')';
		if ($pendingTransactionId = $paymentBackend->createTransaction($transactionId, $actionsCnt, $subscription))
			if ($data = $paymentBackend->getTransactions([$pendingTransactionId])) {
				$transaction = $data[0];
				foreach (['payment_amount', 'payment_data'] as $field)
					$fields[$field] = $transaction[$field];
				if (!$this->billing->update($transactionId, $fields))
					error_log(new \ErrorException('Transaction update failed, id:' . $transactionId . ', data:' . json_encode($fields), null, null, __FILE__, __LINE__));
				return $pendingTransactionId;
			}
		return null;
	}

	/**
	 * Получить список транзакций
	 * @param [integer]|null $transactionIds
	 * @param integer $time Unix Time, с какого времени вернуть данные, по-умолчанию 0 т.е. все данные
	 * @return [][id => integer, time => integer, actions_before => integer, actions_after => integer, actions_cnt => integer, type => integer,
	 *  data (optional) => string,
	 *  task_id (optional) => integer, test_name => string,
	 *  sched_id (optional) => integer, sched_name => string,
	 *  payment_type (optional) => integer, payment_amount => string, payment_data => string,
	 *  refundable (optional) => boolean]
	 */
	public function getTransactions($transactionIds = null, $time = 0) {
		$transactions = [];
		$data = $this->billing->getTransactions($transactionIds, $time);
		foreach ($data as $data1) {
			$transaction = [];
			foreach (['id', 'time'] as $field)
				$transaction[$field] = $data1[$field];
			foreach (['amount_before' => 'actions_before', 'amount_after' => 'actions_after', 'amount' => 'actions_cnt', 'key' => 'user_id'] as $src => $dst)
				$transaction[$dst] = $data1[$src];
			foreach (['type', 'data', 'task_id', 'test_name', 'sched_id', 'sched_name', 'payment_type', 'payment_amount', 'payment_data', 'ref_id'] as $field)
				if (isset($data1['data'][$field]))
					$transaction[$field] = $data1['data'][$field];
			if ($data1['amount'] > 0 && isset($data1['data']['transaction_data']) && $data1['data']['transaction_data'] && !isset($data1['data']['ref_id']))
				$transaction['refundable'] = true;
			$transactions[] = $transaction;
		}
		return $transactions;
	}

	/**
	 * @param integer|null $paymentType
	 * @param [integer]|null $pendingTransactionIds
	 * @return [][payment_type => integer, id => integer, time => integer,
	 *  transaction_id (optional) => integer (global transaction id, if user-initiated),
	 *  url (optional) => string (invoice url),
	 *  code (optional) => boolean (authorization code required),
	 *  actions_cnt => integer, payment_amount => string, payment_data => string]
	 */
	public function getPendingTransactions($paymentType = null, $pendingTransactionIds = null) {
		$transactions = [];
		if ($paymentType)
			$paymentTypes = [$paymentType];
		else
			$paymentTypes = array_keys($this->paymentBackends);
		foreach ($paymentTypes as $paymentType)
			if (isset($this->paymentBackends[$paymentType]))
				foreach ($this->paymentBackends[$paymentType]->getTransactions($pendingTransactionIds) as $transaction) {
					$transaction['payment_type'] = $paymentType;
					if (isset($transaction['external_id'])) {
						$transaction['transaction_id'] = $transaction['external_id'];
						unset($transaction['external_id']);
					}
					$transactions[] = $transaction;
				}
		return $transactions;
	}

	/**
	 * @param integer $paymentType
	 * @param integer $pendingTransactionId
	 * @param string $code
	 * @return boolean true - проведено
	 */
	public function processPendingTransaction($paymentType, $pendingTransactionId, $code = null) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		if ($pendingTransactions = $this->getPendingTransactions($paymentType, [$pendingTransactionId])) {
			$pendingTransaction = $pendingTransactions[0];
			if (isset($pendingTransaction['transaction_id'])) {
				if ($transactions = $this->billing->getTransactions([$pendingTransaction['transaction_id']]))
					$transaction = $transactions[0];
				else {
					error_log(new \ErrorException('Pending Transaction with unknown transaction_id: ' . json_encode($pendingTransaction), null, null, __FILE__, __LINE__));
					return false;
				}
			} else
				$transaction = ['actions_cnt' => $pendingTransaction['actions_cnt'],
					'data' => ['payment_type' => $paymentType, 'payment_amount' => $pendingTransaction['payment_amount'],
						'payment_data' => $pendingTransaction['payment_data'], 'async' => 1]];
		} else
			return false;
		$result = $paymentBackend->processTransaction($pendingTransactionId, $code);
		if (!$result)
			return false;
		if (!isset($pendingTransaction['transaction_id'])) {
			$transaction['data']['type'] = $pendingTransaction['actions_cnt'] < 0 ? TransactionType::REFUND : TransactionType::TOP_UP;
			$transaction['id'] = $this->billing->transaction($transaction['actions_cnt'], $transaction['data']);
			if (!$transaction['id']) {
				error_log(new \ErrorException('Async Transaction insert failed, pending transaction:' . json_encode($pendingTransaction), null, null, __FILE__, __LINE__));
				if ($result['transaction_data'] && !$paymentBackend->refund($result['transaction_data']))
					error_log(new \ErrorException('Refund failed, data:' . json_encode($result), null, null, __FILE__, __LINE__));
				return false;
			}
			$pendingTransaction['transaction_id'] = $transaction['id'];
		}
		foreach (['payment_data', 'transaction_data'] as $field)
			$transaction['data'][$field] = $result[$field];
		if (!$this->billing->update($transaction['id'], $transaction['data']))
			error_log(new \ErrorException('Transaction update failed, transaction:' . json_encode($transaction), null, null, __FILE__, __LINE__));
		if (!$result['transaction_data'])
			return false;
		if (!$this->billing->commit($transaction['id'])) {
			error_log(new \ErrorException('Transaction commit failed, transaction:' . json_encode($transaction), null, null, __FILE__, __LINE__));
			if (!$paymentBackend->refund($result['transaction_data']))
				error_log(new \ErrorException('Refund failed, data:' . json_encode($result), null, null, __FILE__, __LINE__));
			return false;
		}
		return true;
	}

	/**
	 * @param integer $paymentType
	 * @param integer $pendingTransactionId
	 * @return boolean
	 */
	public function cancelPendingTransaction($paymentType, $pendingTransactionId) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		return $paymentBackend->cancelTransaction($pendingTransactionId);
	}

	/**
	 * @param integer|null $paymentType
	 * @param [integer]|null $subscriptionIds
	 * @return [][payment_type => integer, id => integer, time => integer, actions_cnt => integer, payment_amount => string, payment_data => string]
	 */
	public function getSubscriptions($paymentType = null, $subscriptionIds = null) {
		$subscriptions = [];
		if ($paymentType)
			$paymentTypes = [$paymentType];
		else
			$paymentTypes = array_keys($this->paymentBackends);
		foreach ($paymentTypes as $paymentType)
			if (isset($this->paymentBackends[$paymentType]))
				foreach ($this->paymentBackends[$paymentType]->getSubscriptions($subscriptionIds) as $subscription) {
					$subscription['payment_type'] = $paymentType;
					$subscriptions[] = $subscription;
				}
		return $subscriptions;
	}

	/**
	 * @param integer $paymentType
	 * @param integer $subscriptionId
	 * @return boolean true - проведено
	 */
	public function processSubscription($paymentType, $subscriptionId) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		if ($subscriptions = $this->getSubscriptions($paymentType, [$subscriptionId]))
			$subscription = $subscriptions[0];
		else
			return false;
		$fields = ['type' => TransactionType::TOP_UP, 'payment_type' => $paymentType];
		foreach (['payment_amount' => 'payment_amount', 'payment_data' => 'subscription_data'] as $src => $dst)
			$fields[$dst] = $subscription[$src];
		$transactionId = $this->billing->transaction($subscription['actions_cnt'], $fields);
		if (!$transactionId)
			return false;
		$result = $paymentBackend->processSubscription($subscriptionId, $transactionId);
		if (!$result)
			return false;
		foreach (['payment_data', 'transaction_data'] as $field)
			$fields[$field] = $result[$field];
		if (!$this->billing->update($transactionId, $fields))
			error_log(new \ErrorException('Transaction update failed, id:' . $transactionId . ', data:' . json_encode($fields), null, null, __FILE__, __LINE__));
		if (!$result['transaction_data']) {
			// подписка не действует (сломалась или отменена пользователем в интефейсе платежной системы или карта протухла)
			$this->cancelSubscription($paymentType, $subscriptionId);
			return false;
		}
		if (!$this->billing->commit($transactionId)) {
			error_log(new \ErrorException('Transaction commit failed, id:' . $transactionId . ', data:' . json_encode($fields), null, null, __FILE__, __LINE__));
			if (!$paymentBackend->refund($result['transaction_data']))
				error_log(new \ErrorException('Refund failed, data:' . json_encode($result), null, null, __FILE__, __LINE__));
			return false;
		}
		return true;
	}

	/**
	 * @param integer $paymentType
	 * @param integer $subscriptionId
	 * @param integer $actionsCnt
	 * @return boolean
	 */
	public function modifySubscription($paymentType, $subscriptionId, $actionsCnt) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		return $paymentBackend->modifySubscription($subscriptionId, $actionsCnt);
	}

	/**
	 * @param integer $paymentType
	 * @param integer $subscriptionId
	 * @return boolean
	 */
	public function cancelSubscription($paymentType, $subscriptionId) {
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		return $paymentBackend->cancelSubscription($subscriptionId);
	}

	/**
	 * @param integer $transactionId
	 * @return boolean true - проведено
	 */
	public function refund($transactionId) {
		if ($result = $this->billing->getTransactions([$transactionId]))
			$transaction = $result[0];
		else
			return false;
		if (!isset($transaction['data']['transaction_data']))
			return false;
		if (!$transaction['data']['transaction_data'])
			return false;
		if (isset($transaction['data']['ref_id']))
			return false;
		$paymentType = $transaction['data']['payment_type'];
		if (isset($this->paymentBackends[$paymentType]))
			$paymentBackend = $this->paymentBackends[$paymentType];
		else
			return false;
		$actionsCnt = $this->billing->getAmount();
		if ($actionsCnt <= 0)
			return false;
		if ($actionsCnt > $transaction['amount'])
			$actionsCnt = $transaction['amount'];
		else
			$note = 'Top Up: ' . $transaction['amount'] . ' Actions, Available (Balance): ' . $actionsCnt . ' Actions, partial refund';
		$fields = ['type' => TransactionType::REFUND, 'ref_id' => $transactionId,
			'payment_type' => $paymentType, 'payment_data' => $transaction['data']['payment_data']];
		$refundTransactionId = $this->billing->transaction(- $actionsCnt, $fields);
		if (!$refundTransactionId)
			return false;
		$result = $paymentBackend->refund($transaction['data']['transaction_data'], $refundTransactionId,
			$actionsCnt != $transaction['amount'] ? $actionsCnt : null, isset($note) ? $note : null);
		if (!$result)
			return false;
		foreach (['payment_data', 'transaction_data'] as $field)
			$fields[$field] = $result[$field];
		if (!$this->billing->update($refundTransactionId, $fields))
			error_log(new \ErrorException('Transaction update failed, id:' . $refundTransactionId . ', data:' . json_encode($fields), null, null, __FILE__, __LINE__));
		if (!$result['transaction_data'])
			return false;
		$transaction['data']['ref_id'] = $refundTransactionId;
		if (!$this->billing->update($transactionId, $transaction['data']))
			error_log(new \ErrorException('Transaction update failed, transaction:' . json_encode($transaction), null, null, __FILE__, __LINE__));
		if (!$this->billing->commit($refundTransactionId))
			error_log(new \ErrorException('Transaction commit failed, id:' . $refundTransactionId . ', data:' . json_encode($fields), null, null, __FILE__, __LINE__));
		return true;
	}

	/**
	 * Удаляет старые записи из БД
	 * @param integer $time UnixTime старше которого удалить
	 */
	public function clear($time = 0) {
		foreach ($this->paymentBackends as $paymentBackend)
			$paymentBackend->clear($time);
		return $this->billing->clear($time);
	}
}
