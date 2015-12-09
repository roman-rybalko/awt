<?php

namespace AdvancedWebTesting\Billing\PaymentBackend;

require_once __DIR__ . '/webmoney/vendor/autoload.php';

class Webmoney implements \AdvancedWebTesting\Billing\PaymentBackend {
	private $transactions, $subscriptions;
	private $wm, $wmId, $wmPurse, $wmCert, $wmCertKey, $wmSecretKey, $wmValidityPeriodDays, $wmDayLimit, $wmWeekLimit, $wmMonthLimit;
	private $currency, $actionPrice, $serverName;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId, $actionPrice = 1, $lang = 'EN') {
		$fields = [];
		if ($userId !== null)
			$fields['user_id'] = $userId;
		$this->transactions = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'webmoney_transactions', $fields);
		$this->subscriptions = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'webmoney_subscriptions', $fields);

		$this->wm = new \baibaratsky\WebMoney\WebMoney(new \baibaratsky\WebMoney\Request\Requester\CurlRequester());
		$this->wmId = \Config::WEBMONEY_ID;
		$this->wmPurse = \Config::WEBMONEY_PURSE;
		$this->wmCert = \Config::WEBMONEY_CERT;
		$this->wmCertKey = \Config::WEBMONEY_CERT_KEY;
		$this->wmSecretKey = \Config::WEBMONEY_SECRET_KEY;
		$this->wmValidityPeriodDays = \Config::BILLING_PENDING_PURGE_PERIOD;
		$this->wmDayLimit = \Config::WEBMONEY_DAY_LIMIT;
		$this->wmWeekLimit = \Config::WEBMONEY_WEEK_LIMIT;
		$this->wmMonthLimit = \Config::WEBMONEY_MONTH_LIMIT;

		switch ($purseType = substr($this->wmPurse, 0, 1)) {
			case 'R':
				$this->currency = 'RUB';
				break;
			case 'Z':
				$this->currency = 'USD';
				break;
			case 'E':
				$this->currency = 'EUR';
				break;
			default:
				$this->currency = 'WM' . $purseType;
		}
		$this->actionPrice = $actionPrice;
		$this->serverName = parse_url(\Config::UI_URL, PHP_URL_HOST);
	}

	/**
	 * @param integer $externalId
	 * @param integer $actionsCnt
	 * @param string|null $subscription
	 * @return integer|null $transactionId
	 */
	public function createTransaction($externalId, $actionsCnt, $subscription = null) {
		$request = new \baibaratsky\WebMoney\Api\X\X22\Request(\baibaratsky\WebMoney\Api\X\X22\Request::AUTH_SHA256, $this->wmSecretKey);
		$request->setSignerWmid($this->wmId);
		$request->setPayeePurse($this->wmPurse);
		$request->setValidityPeriodInHours($this->wmValidityPeriodDays * 24);
		$request->setPaymentAmount($this->actionPrice * $actionsCnt);
		$request->setPaymentNumber($externalId);
		$request->setPaymentDescription($actionsCnt . ' Test Actions (' . $_SERVER['SERVER_NAME'] . ')');
		$request->setSuccessUrl(\WebConstructionSet\Url\Tools::getMyUrl());
		$request->setSuccessMethod(\baibaratsky\WebMoney\Api\X\X22\Request::URL_METHOD_GET);
		$request->setFailUrl(\WebConstructionSet\Url\Tools::getMyUrl());
		$request->setFailMethod(\baibaratsky\WebMoney\Api\X\X22\Request::URL_METHOD_GET);

		// X22 bug workaround - success/fail url query params are removed by WM
		$params = [];
		parse_str($_SERVER['QUERY_STRING'], $params);
		foreach ($params as $name => $value)
			$request->setUserTag($name, $value);

		$request->sign();

		if (!$request->validate()) {
			error_log(new \ErrorException('X22 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		if ($response->getReturnCode()) {
			error_log(new \ErrorException('X22 call failed, code: ' . $response->getReturnCode() . ', description: ' . $response->getReturnDescription(), null, null, __FILE__, __LINE__));
			return null;
		}

		$fields = ['time' => time(), 'external_id' => $externalId, 'url' => $response->getUrl(\baibaratsky\WebMoney\Api\X\X22\Response::URL_LANG_EN),
			'actions_cnt' => $actionsCnt, 'payment_data' => $response->getTransactionToken()];
		if ($subscription)
			$fields['subscription'] = $subscription;
		return $this->transactions->insert($fields);
	}

	/**
	 * @param [integer]|null $ids
	 * @return [][id => integer, time => integer, user_id => integer,
	 *  external_id (optional) => integer (external transaction id, if initiated via createTransaction()),
	 *  url (optional) => string (invoice url),
	 *  code (optional) => boolean (authorization code is required),
	 *  actions_cnt => integer, payment_amount => string, payment_data => string]
	 * payment_data отобразится в описании транзакции
	 */
	public function getTransactions($transactionIds = null) {
		$data = [];
		$fields = ['id', 'time', 'user_id', 'external_id', 'url', 'actions_cnt', 'payment_data', 'purse_id'];
		if ($transactionIds === null)
			$data = $this->transactions->select($fields);
		else
			foreach ($transactionIds as $transactionId)
				if ($data1 = $this->transactions->select($fields, ['id' => $transactionId]))
					$data = array_merge($data, $data1);
		foreach ($data as &$data1) {
			$data1['payment_amount'] = ($data1['actions_cnt'] * $this->actionPrice) . ' ' . $this->currency;
			if (!$data1['external_id'])
				unset($data1['external_id']);
			if (!$data1['url'])
				unset($data1['url']);
			if ($data1['purse_id']) {
				$data1['code'] = 1;
				$data1['actions_cnt'] = 0;
			} else
				unset($data1['purse_id']);
		}
		return $data;
	}

	/**
	 * @param integer $transactionId
	 * @param string $code authorization code (if required)
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function processTransaction($transactionId, $code = null) {
		if ($transactions = $this->transactions->select(['id', 'external_id', 'subscription', 'actions_cnt', 'wmid', 'purse', 'purse_id', 'started'], ['id' => $transactionId]))
			$transaction = $transactions[0];
		else
			return null;

		if (!$transaction['started'])
			return null;

		if ($transaction['purse_id']) {
			if ($code === null)
				return;

			if (!$this->finishSubscription($transaction, $code))
				return null;

			return ['payment_data' => 'Purse: ' . $transaction['purse'] . ', ' . $transaction['subscription'], 'transaction_data' => $transaction['purse']];
		} else {
			$request = new \baibaratsky\WebMoney\Api\X\X18\Request(\baibaratsky\WebMoney\Api\X\X18\Request::AUTH_SHA256, $this->wmSecretKey);
			$request->setSignerWmid($this->wmId);
			$request->setPayeePurse($this->wmPurse);
			$request->setPaymentNumber($transaction['external_id']);
			$request->setPaymentNumberType(\baibaratsky\WebMoney\Api\X\X18\Request::PAYMENT_NUMBER_TYPE_ORDER);
			$request->sign();

			if (!$request->validate()) {
				error_log(new \ErrorException('X18 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
				return null;
			}

			$response = $this->wm->request($request);

			if ($response->getReturnCode()) {
				// garbage here: payment not found bla bla bla
				//$this->transactions->update(['payment_data' => 'X18 Code: ' . $response->getReturnCode() . ', X18 Description: ' . $response->getReturnDescription()], ['id' => $transactionId]);
				return null;
			}

			if (!$this->transactions->delete(['id' => $transactionId]))
				return null;

			if ($transaction['subscription'])
				$this->startSubscription($transaction, $response->getPayerWmid(), $response->getPayerPurse());

			return ['payment_data' => 'Transaction Id: ' . $response->getTransactionId() . ', Invoice Id: ' . $response->getInvoiceId() . ', Purse: ' . $response->getPayerPurse(),
				'transaction_data' => $response->getTransactionId()
			];
		}
	}

	private function startSubscription($transaction, $payerWmid, $payerPurse) {
		$request = new \baibaratsky\WebMoney\Api\X\X21\TrustRequest\Request(\baibaratsky\WebMoney\Api\X\X21\TrustRequest\Request::AUTH_LIGHT);
		$request->cert($this->wmCert, $this->wmCertKey);
		$request->setSignerWmid($this->wmId);
		$request->setPayeePurse($this->wmPurse);
		$request->setDayLimit($this->wmDayLimit);
		$request->setWeekLimit($this->wmWeekLimit);
		$request->setMonthLimit($this->wmMonthLimit);
		$request->setClientNumber($payerPurse);
		$request->setClientNumberType(\baibaratsky\WebMoney\Api\X\X21\TrustRequest\Request::CLIENT_NUMBER_TYPE_PURSE);
		$request->setSmsType(\baibaratsky\WebMoney\Api\X\X21\TrustRequest\Request::SMS_TYPE_SMS);
		$request->setLanguage(\baibaratsky\WebMoney\Api\X\X21\TrustRequest\Request::LANGUAGE_EN);

		if (!$request->validate()) {
			error_log(new \ErrorException('X21R validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		switch ($response->getReturnCode()) {
			case 0:
				break;
			case 608:  /// already have a trust
				return $this->subscriptions->insert(['time' => time(), 'actions_cnt' => $transaction['actions_cnt'], 'wmid' => $payerWmid, 'purse' => $payerPurse]);
			default:
				error_log(new \ErrorException('X21R call failed, code: ' . $response->getReturnCode() . ', description: ' . $response->getReturnDescription(), null, null, __FILE__, __LINE__));
				return null;
		}

		return $this->transactions->insert(['time' => time(), 'subscription' => $transaction['subscription'],
			'actions_cnt' => $transaction['actions_cnt'],
			'payment_data' => $response->getUserDescription(),
			'wmid' => $payerWmid, 'purse' => $payerPurse, 'purse_id' => $response->getRequestId(),
			'started' => 1
		]);
	}

	private function finishSubscription($transaction, $code) {
		$request = new \baibaratsky\WebMoney\Api\X\X21\TrustConfirm\Request(\baibaratsky\WebMoney\Api\X\X21\TrustConfirm\Request::AUTH_LIGHT);
		$request->cert($this->wmCert, $this->wmCertKey);
		$request->setSignerWmid($this->wmId);
		$request->setRequestId($transaction['purse_id']);
		$request->setConfirmationCode($code);
		$request->setLanguage(\baibaratsky\WebMoney\Api\X\X21\TrustConfirm\Request::LANGUAGE_EN);

		if (!$request->validate()) {
			error_log(new \ErrorException('X21C validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		if ($response->getReturnCode()) {
			$this->transactions->update(['payment_data' => $response->getUserDescription()], ['id' => $transaction['id']]);
			return null;
		}

		if (!$this->transactions->delete(['id' => $transaction['id']]))
			return null;

		return $this->subscriptions->insert(['time' => time(), 'actions_cnt' => $transaction['actions_cnt'], 'wmid' => $transaction['wmid'], 'purse' => $transaction['purse']]);
	}

	/**
	 * @param integer $transactionId
	 * @return boolean
	 */
	public function cancelTransaction($transactionId) {
		return $this->transactions->delete(['id' => $transactionId]);
	}

	/**
	 * @param [integer]|null $subsctiptionIds
	 * @return [][id => integer, time => integer, user_id => integer, actions_cnt => integer, payment_amount => string, payment_data = string]
	 * payment_data отобразится в описании подписки
	 */
	public function getSubscriptions($subsctiptionIds = null) {
		$data = [];
		$fields = ['id', 'time', 'user_id', 'actions_cnt', 'wmid', 'purse'];
		if ($subsctiptionIds === null)
			$data = $this->subscriptions->select($fields);
		else
			foreach ($subsctiptionIds as $subsctiptionId)
				if ($data1 = $this->subscriptions->select($fields, ['id' => $subsctiptionId]))
					$data = array_merge($data, $data1);
		foreach ($data as &$data1) {
			$data1['payment_amount'] = ($data1['actions_cnt'] * $this->actionPrice) . ' ' . $this->currency;
			$data1['payment_data'] = $data1['purse'];
			unset($data1['purse']);
		}
		return $data;
	}

	/**
	 * @param integer $subsctiptionId
	 * @param integer $externalId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 *  null - ошибка связи
	 *  transaction_data = null - пополнение не прошло, подписка битая
	 */
	public function processSubscription($subsctiptionId, $externalId) {
		if ($subsctiptions = $this->subscriptions->select(['id', 'actions_cnt', 'wmid', 'purse'], ['id' => $subsctiptionId]))
			$subsctiption = $subsctiptions[0];
		else
			return null;

		$request = new \baibaratsky\WebMoney\Api\X\X1\Request(\baibaratsky\WebMoney\Api\X\X1\Request::AUTH_LIGHT);
		$request->cert($this->wmCert, $this->wmCertKey);
		$request->setSignerWmid($this->wmId);
		$request->setOrderId($externalId);
		$request->setCustomerWmid($subsctiption['wmid']);
		$request->setPurse($this->wmPurse);
		$request->setAmount($subsctiption['actions_cnt'] * $this->actionPrice);
		$request->setDescription('Subscription #' . $subsctiption['id'] . ': ' . $subsctiption['actions_cnt'] . ' Test Actions (' . $this->serverName . ')');
		$request->setExpiration($this->wmValidityPeriodDays);
		$request->setOnlyAuth(false);

		if (!$request->validate()) {
			error_log(new \ErrorException('X1 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		if ($response->getReturnCode()) {
			return ['payment_data' => 'X1 Code: ' . $response->getReturnCode() . ', X1 Description: ' . $response->getReturnDescription(), 'transaction_data' => null];
			return null;
		}

		$request = new \baibaratsky\WebMoney\Api\X\X2\Request(\baibaratsky\WebMoney\Api\X\X2\Request::AUTH_LIGHT);
		$request->cert($this->wmCert, $this->wmCertKey);
		$request->setSignerWmid($this->wmId);
		$request->setTransactionExternalId($externalId);
		$request->setPayerPurse($subsctiption['purse']);
		$request->setPayeePurse($this->wmPurse);
		$request->setAmount($subsctiption['actions_cnt'] * $this->actionPrice);
		$request->setInvoiceId($response->getInvoiceId());

		if (!$request->validate()) {
			error_log(new \ErrorException('X2 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		if ($response->getReturnCode())
			return ['payment_data' => 'X2 Code: ' . $response->getReturnCode() . ', X2 Description: ' . $response->getReturnDescription(), 'transaction_data' => null];

		return ['payment_data' => 'Subscription #' . $subsctiption['id'] . ', Transaction Id: ' . $response->getTransactionId()
			. ', Invoice Id: ' . $response->getInvoiceId()
			. ', Order Id: ' . $response->getOrderId() . ', Purse: ' . $response->getPayerPurse(), 'transaction_data' => $response->getTransactionId()];
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
		return $this->subscriptions->delete(['id' => $subsctiptionId]);
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
		$amount = $actionsCnt * $this->actionPrice;
		$transactionId = $transactionData;

		if (!$amount) {
			$request = new \baibaratsky\WebMoney\Api\X\X18\Request(\baibaratsky\WebMoney\Api\X\X18\Request::AUTH_SHA256, $this->wmSecretKey);
			$request->setSignerWmid($this->wmId);
			$request->setPayeePurse($this->wmPurse);
			$request->setPaymentNumber($transactionId);
			$request->setPaymentNumberType(\baibaratsky\WebMoney\Api\X\X18\Request::PAYMENT_NUMBER_TYPE_TRANSACTION);
			$request->sign();

			if (!$request->validate()) {
				error_log(new \ErrorException('X18 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
				return null;
			}

			$response = $this->wm->request($request);

			if ($response->getReturnCode())
				return ['payment_amount' => '',
					'payment_data' => 'X18 Code: ' . $response->getReturnCode() . ', X18 Description: ' . $response->getReturnDescription(),
					'transaction_data' => null
				];

			$amount = $response->getAmount();
		}

		$request = new \baibaratsky\WebMoney\Api\X\X14\Request(\baibaratsky\WebMoney\Api\X\X14\Request::AUTH_LIGHT);
		$request->cert($this->wmCert, $this->wmCertKey);
		$request->setSignerWmid($this->wmId);
		$request->setTransactionId($transactionId);
		$request->setAmount($amount);

		if (!$request->validate()) {
			error_log(new \ErrorException('X14 validate failed: ' . json_encode($request->getErrors()), null, null, __FILE__, __LINE__));
			return null;
		}

		$response = $this->wm->request($request);

		if ($response->getReturnCode())
			return ['payment_amount' => $amount . ' ' . $this->currency,
				'payment_data' => 'X14 Code: ' . $response->getReturnCode() . ', X14 Description: ' . $response->getReturnDescription(),
				'transaction_data' => null
			];

		return ['payment_amount' => $amount . ' ' . $this->currency,
			'payment_data' => 'Transaction Id: ' . $response->getRefundTransactionId() . ', Purse: ' . $response->getPayeePurse()
				. ($note ? ', Note: ' . $note : '') . ', Description: ' . $response->getDescription(),
			'transaction_data' => $response->getRefundTransactionId()
		];
	}

	/**
	 * Удалить лог и др. служебные данные
	 * @param integer $time UnixTime старше которого удалить
	 */
	public function clear($time) {
		return 0;
	}

	public function handleResultUrl() {
		header('Content-Type: text/plain');
		if (isset($_POST['LMI_PREREQUEST'])) {
			if ($this->transactions->update(['started' => 1], ['external_id' => $_POST['LMI_PAYMENT_NO']])) {
				echo 'YES';
				return;
			}
			if ($this->transactions->select(['id'], ['external_id' => $_POST['LMI_PAYMENT_NO']])) {
				echo 'The payment has already been started. Please, try another one.';
				return;
			}
			echo 'The payment is not registered. Please, try another one.';
			return;
		}
		print_r($_POST);
		echo 'Okay, come again :)';
	}
}
