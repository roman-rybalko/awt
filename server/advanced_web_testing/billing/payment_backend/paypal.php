<?php

namespace AdvancedWebTesting\Billing\PaymentBackend;

class Paypal implements \AdvancedWebTesting\Billing\PaymentBackend {
	private $paypal, $actionPrice, $currencyCode, $subscriptionActions;

	/**
	 * @param \WebConstructionSet\Database\Relational $db
	 * @param integer $userId
	 * @param double $actionPrice
	 * @param string $currencyCode
	 */
	public function __construct(\WebConstructionSet\Database\Relational $db, $userId, $actionPrice = 1, $currencyCode = 'RUB') {
		$this->paypal = new \WebConstructionSet\Billing\Paypal($db, \Config::PAYPAL_USER, \Config::PAYPAL_PASSWORD, \Config::PAYPAL_SIGNATURE, \Config::PAYPAL_SANDBOX, $userId);
		$this->actionPrice = $actionPrice;
		$this->currencyCode = $currencyCode;
		$this->subscriptionActions = new \WebConstructionSet\Database\Relational\KeyValue($db, 'paypal_subscription_actions', 'id', 'cnt');
	}

	/**
	 * @param integer $externalId
	 * @param integer $actionsCnt
	 * @param string|null $subscriotion
	 * @return integer|null $transactionId
	 */
	public function createTransaction($externalId, $actionsCnt, $subscriotion = null) {
		$params = [
			'L_PAYMENTREQUEST_0_ITEMCATEGORY0' => 'Digital',
			'L_PAYMENTREQUEST_0_NAME0' => 'Test Action',
			'L_PAYMENTREQUEST_0_AMT0' => $this->actionPrice,
			'L_PAYMENTREQUEST_0_QTY0' => $actionsCnt,
			'PAYMENTREQUEST_0_ITEMAMT' => $actionsCnt * $this->actionPrice,
			'NOSHIPPING' => 1,
			'ALLOWNOTE' => 0,
		];
		return $this->paypal->initiateTransaction($externalId, $actionsCnt * $this->actionPrice, $this->currencyCode, $subscriotion, $params);
	}

	/**
	 * @param [integer]|null $ids
	 * @return [][id => integer, time => integer, external_id => integer, user_id => integer,
	 *  url => string, actions_cnt => integer, payment_amount => string, payment_data => string]
	 * payment_data отобразится в описании транзакции
	 */
	public function getTransactions($transactionIds = null) {
		$transactions = [];
		$data = $this->paypal->getTransactions($transactionIds);
		foreach ($data as $data1) {
			$transaction = [];
			foreach (['id' => 'id', 'time' => 'time', 'invnum' => 'external_id', 'key' => 'user_id', 'url' => 'url', 'token' => 'payment_data'] as $src => $dst)
				$transaction[$dst] = $data1[$src];
			$transaction['actions_cnt'] = round($data1['amt'] / $this->actionPrice);
			$transaction['payment_amount'] = $data1['amt'] . ' ' . $data1['currencycode'];
			$transactions[] = $transaction;
		}
		return $transactions;
	}

	/**
	 * @param integer $transactionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function processTransaction($transactionId) {
		$data = $this->paypal->processTransaction($transactionId);
		if (!$data)
			return null;
		if (isset($data['subscription_id']))
			$this->subscriptionActions->set($data['subscription_id'], round($data['amt'] / $this->actionPrice));
		return ['payment_data' => $data['data'], 'transaction_data' => $data['transactionid']];
	}

	/**
	 * @param integer $transactionId
	 * @return boolean
	 */
	public function cancelTransaction($transactionId) {
		return $this->paypal->cancelTransaction($transactionId);
	}

	/**
	 * @param [integer]|null $subsctiptionIds
	 * @return [][id => integer, time => integer, user_id => integer, actions_cnt => integer, payment_amount => string, payment_data = string]
	 * payment_data отобразится в описании подписки
	 */
	public function getSubscriptions($subsctiptionIds = null) {
		$subsctiptions = [];
		$data = $this->paypal->getSubscriptions($subsctiptionIds);
		foreach ($data as $data1) {
			$subsctiption = [];
			foreach (['id' => 'id', 'time' => 'time', 'billingagreementid' => 'payment_data', 'key' => 'user_id'] as $src => $dst)
				$subsctiption[$dst] = $data1[$src];
			$subsctiption['actions_cnt'] = $this->subscriptionActions->getValue($data1['id']);
			$subsctiption['payment_amount'] = ($subsctiption['actions_cnt'] * $this->actionPrice) . ' ' . $this->currencyCode;
			$subsctiptions[] = $subsctiption;
		}
		return $subsctiptions;
	}

	/**
	 * @param integer $subsctiptionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 *  null - ошибка связи
	 *  transaction_data = null - пополнение не прошло, подписка битая
	 */
	public function processSubscription($subsctiptionId, $externalId) {
		$actionsCnt = $this->subscriptionActions->getValue($subsctiptionId);
		if (!$actionsCnt)
			return ['payment_data' => 'Bad TopUp Amount', 'transaction_data' => null];
		$params = [
			'L_ITEMCATEGORY0' => 'Digital',
			'L_NAME0' => 'Test Action',
			'L_AMT0' => $this->actionPrice,
			'L_QTY0' => $actionsCnt,
			'ITEMAMT' => $actionsCnt * $this->actionPrice,
		];
		$data = $this->paypal->processSubscription($subsctiptionId, $externalId, $actionsCnt * $this->actionPrice, $this->currencyCode, $params);
		if (!$data)
			return null;
		return ['payment_data' => $data['data'], 'transaction_data' => $data['transactionid']];
	}

	/**
	 * @param integer $subsctiptionId
	 * @param integer $actionsCnt
	 * @return boolean
	 */
	public function modifySubscription($subsctiptionId, $actionsCnt) {
		if ($this->subscriptionActions->getValue($subsctiptionId) === null)
			return null;
		return $this->subscriptionActions->set($subsctiptionId, $actionsCnt);
	}

	/**
	 * @param integer $subsctiptionId
	 * @return boolean
	 */
	public function cancelSubscription($subsctiptionId) {
		$this->subscriptionActions->delete($subsctiptionId);
		return $this->paypal->cancelSubscription($subsctiptionId);
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
		$params = [];
		if ($actionsCnt) {
			$params['REFUNDTYPE'] = 'Partial';
			$params['AMT'] = $actionsCnt * $this->actionPrice;
			$params['CURRENCYCODE'] = $this->currencyCode;
		}
		if ($note)
			$params['NOTE'] = $note;
		$data = $this->paypal->refund($transactionData, $params);
		if (!$data)
			return null;
		if (!$data['data'])
			$data['data'] = $actionsCnt ? 'Partial Refund' : 'Full Refund';
		return ['payment_amount' => $data['amt'] . ' ' . $data['currencycode'],
			'payment_data' => $data['data'], 'transaction_data' => $data['transactionid']];
	}
}
