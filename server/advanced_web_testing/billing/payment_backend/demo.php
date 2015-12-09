<?php

namespace AdvancedWebTesting\Billing\PaymentBackend;

class Demo implements \AdvancedWebTesting\Billing\PaymentBackend {
	private $subscriptions;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->subscriptions = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'demo_subscriptions', ['user_id' => $userId]);
	}

	/**
	 * @param integer $externalId
	 * @param integer $actionsCnt
	 * @param string|null $subscription
	 * @return integer|null $transactionId
	 */
	public function createTransaction($externalId, $actionsCnt, $subscription = null) {
		return null;
	}

	/**
	 * @param [integer]|null $ids
	 * @return [][id => integer, time => integer, external_id => integer, user_id => integer,
	 *  subscription_id (optional) => integer,
	 *  url => string, actions_cnt => integer, payment_amount => string, payment_data => string]
	 * payment_data отобразится в описании транзакции
	 */
	public function getTransactions($transactionIds = null) {
		return [];
	}

	/**
	 * @param integer $transactionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function processTransaction($transactionId, $code = null) {
		return ['payment_data' => 'Bad Transaction #' . $transactionId, 'transaction_data' => null];
	}

	/**
	 * @param integer $transactionId
	 * @return boolean
	 */
	public function cancelTransaction($transactionId) {
		return false;
	}

	/**
	 * @param [integer]|null $subsctiptionIds
	 * @return [][id => integer, time => integer, user_id => integer, actions_cnt => integer, payment_amount => string, payment_data = string]
	 * payment_data отобразится в описании подписки
	 */
	public function getSubscriptions($subsctiptionIds = null) {
		$data = [];
		$fields = ['id', 'time', 'actions_cnt', 'user_id'];
		if ($subsctiptionIds === null)
			$data = $this->subscriptions->select($fields);
		else
			foreach ($subsctiptionIds as $subsctiptionId)
				if ($data1 = $this->subscriptions->select($fields, ['id' => $subsctiptionId]))
					$data = array_merge($data, $data1);
		foreach ($data as &$data1) {
			$data1['payment_amount'] = $data1['actions_cnt'] . ' Test Actions';
			$data1['payment_data'] = 'Demo Subscription #' . $data1['id'];
		}
		return $data;
	}

	/**
	 * @param integer $subsctiptionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 *  null - ошибка связи
	 *  transaction_data = null - пополнение не прошло, подписка битая
	 */
	public function processSubscription($subsctiptionId, $externalId) {
		$data = $this->subscriptions->select(['actions_cnt'], ['id' => $subsctiptionId]);
		if (!$data)
			return ['payment_data' => 'Bad Subscription #' . $subsctiptionId, 'transaction_data' => null];
		return ['payment_data' => 'Demo Transaction #' . $externalId, 'transaction_data' => $externalId];
	}

	/**
	 * @param integer $subsctiptionId
	 * @param integer $actionsCnt
	 * @return boolean
	 */
	public function modifySubscription($subsctiptionId, $actionsCnt) {
		$actionsCnt = $actionsCnt + 0;
		if (!$actionsCnt)
			return false;
		return $this->subscriptions->update(['actions_cnt' => $actionsCnt, 'time' => time()], ['id' => $subsctiptionId]);
	}

	/**
	 * @param integer $subsctiptionId
	 * @return boolean
	 */
	public function cancelSubscription($subsctiptionId) {
		return false;
	}

	/**
	 * @param mixed $transactionData
	 * @param integer|null $actionsCnt
	 * @param string|null $note
	 * @return [payment_amount => string, payment_data => string, transaction_data => mixed|null ] | null
	 *  null - ошибка связи
	 *  transaction_data = null - ошибка операции
	 */
	public function refund($transactionData, $externalId, $actionsCnt = null, $note = null) {
		$actionsCnt = $actionsCnt + 0;
		if (!$actionsCnt)
			$actionsCnt = 'ZZz';
		return ['payment_amount' => $actionsCnt . ' Test Actions', 'payment_data' => 'Demo Refund #' . $externalId, 'transaction_data' => $externalId];
	}

	/**
	 * Удалить лог и др. служебные данные
	 * @param integer $time UnixTime старше которого удалить
	 */
	public function clear($time) {
		return 0;
	}
}
