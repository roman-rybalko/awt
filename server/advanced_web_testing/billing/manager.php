<?php

namespace AdvancedWebTesting\Billing;

/**
 * Финансы
 * Model (MVC)
 */
class Manager {
	private $billing, $userId;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->billing = new \WebConstructionSet\Database\Relational\Billing($db, 'billing', 0);
		$this->userId = $userId;
	}

	/**
	 * Списывает средства за запуск
	 * @param integer $taskId
	 * @param string $testName
	 * @param $schedId
	 * @param $schedName
	 * @return integer transactionId
	 */
	public function taskStart($taskId, $testName, $schedId = null, $schedName = null) {
		$fields = ['type' => TransactionType::TASK_START, 'task_id' => $taskId, 'test_name' => $testName];
		if ($schedId !== null) {
			$fields['sched_id'] = $schedId;
			$fields['sched_name'] = $schedName;
		}
		return $this->billing->transaction(- Price::TASK_START, $fields, $this->userId);
	}

	/**
	 * Списывает средства за Test Actions
	 * @param integer $taskId
	 * @param string $taskName
	 * @param integer $actionsCnt
	 * @return integer transactionId
	 */
	public function taskEnd($taskId, $testName, $actionsCnt) {
		return $this->billing->transaction(- Price::TASK_ACTION * $actionsCnt,
			['type' => TransactionType::TASK_END, 'task_id' => $taskId, 'test_name' => $testName],
			$this->userId);
	}

	/**
	 * Пополнить
	 * @param integer $actionsCnt
	 * @param double $paymentAmount
	 * @param integer $paymentType
	 * @param string $paymentData
	 * @return transactionId
	 */
	public function topUp($actionsCnt, $paymentType, $paymentAmount, $paymentData) {
		return $this->billing->transaction($actionsCnt,
			['type' => TransactionType::TOP_UP, 'payment_type' => $paymentType, 'payment_amount' => $paymentAmount, 'payment_data' => $paymentData],
			$this->userId);
	}

	/**
	 * Изменение баланса вручную
	 * @param integer $actionsCnt
	 * @param string $data
	 * @return integer transactionId
	 */
	public function service($actionsCnt, $data) {
		return $this->billing->transaction($actionsCnt, ['type' => TransactionType::SERVICE, 'data' => $data], $this->userId);
	}

	/**
	 * Получить количество доступных Actions
	 * @return integer
	 */
	public function getActionsCount() {
		return $this->billing->getAmount($this->userId);
	}

	/**
	 * Получить список транзакций
	 * @param [integer]|null $transactionIds
	 * @return [][id => integer, time => integer, actions_before => integer, actions_after => integer, type => integer,
	 *  task_id (optional) => integer, test_name => string,
	 *  sched_id (optional) => integer, sched_name => string,
	 *  payment_type (optional) => integer, payment_amount => double, payment_data => string]
	 */
	public function getTransactions($transactionIds = null) {
		$transactions = [];
		$data = $this->billing->getTransactions(null, $this->userId);
		foreach ($data as $data1) {
			$transaction = [];
			foreach (['id', 'time'] as $field)
				$transaction[$field] = $data1[$field];
			foreach (['amount_before' => 'actions_before', 'amount_after' => 'actions_after', 'amount' => 'actions'] as $src => $dst)
				$transaction[$dst] = $data1[$src];
			$transaction = array_merge($transaction, $data1['data']);
			$transactions[] = $transaction;
		}
		return $transactions;
	}
}
