<?php

namespace AdvancedWebTesting\Billing;

interface PaymentBackend {
	/**
	 * @param integer $externalId
	 * @param integer $actionsCnt
	 * @param string|null $subscriotion
	 * @return integer|null $transactionId
	 */
	public function createTransaction($externalId, $actionsCnt, $subscriotion = null);

	/**
	 * @param [integer]|null $ids
	 * @return [][id => integer, time => integer, external_id => integer, user_id => integer,
	 *  subscription_id (optional) => integer,
	 *  url => string, actions_cnt => integer, payment_amount => string, payment_data => string]
	 * payment_data отобразится в описании транзакции
	 */
	public function getTransactions($transactionIds = null);

	/**
	 * @param integer $transactionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function processTransaction($transactionId);

	/**
	 * @param integer $transactionId
	 * @return boolean
	 */
	public function cancelTransaction($transactionId);

	/**
	 * @param [integer]|null $subsctiptionIds
	 * @return [][id => integer, time => integer, user_id => integer, actions_cnt => integer, payment_amount => string, payment_data = string]
	 * payment_data отобразится в описании подписки
	 */
	public function getSubscriptions($subsctiptionIds = null);

	/**
	 * @param integer $subsctiptionId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 * может создать транзакцию
	 * null или transaction_data != null - подписка еще действует
	 */
	public function processSubscription($subsctiptionId, $externalId);

	/**
	 * @param integer $subsctiptionId
	 * @param integer $actionsCnt
	 * @return boolean
	 */
	public function modifySubscription($subsctiptionId, $actionsCnt);

	/**
	 * @param integer $subsctiptionId
	 * @return boolean
	 */
	public function cancelSubscription($subsctiptionId);

	/**
	 * @param mixed $transactionData
	 * @param integer|null $actionsCnt
	 * @param string|null $note
	 * @return [payment_amount => string, payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function refund($transactionData, $externalId, $actionsCnt = null, $note = null);
}
