<?php

namespace AdvancedWebTesting\Billing;

interface PaymentBackend {
	/**
	 * @param integer $externalId
	 * @param integer $actionsCnt
	 * @param string|null $subscription
	 * @return integer|null $transactionId
	 */
	public function createTransaction($externalId, $actionsCnt, $subscription = null);

	/*
	 * Транзакции могут появляться из:
	 * 1) createTransaction() - пользователь оплачивает на сайте, может породить несколько транзакций но только одну с external_id
	 * 2) processTansaction() - может породить отдельную транзакцию, например для инициации подписки с вводом кода авторизации
	 * 3) сhargeback (обработчик сигналов платежной системы) - пользователь инициирует возврат через платежную систему
	 * Транзакции, инициированные на сайте, уже имеют external_id.
	 * Для остальных (асинхронных) транзакций external_id не задан - он будет наначен при обработке, в processPendingTransaction().
	 *
	 * processSubscription() и refund() должны производить финансовые операции синхронно,
	 * т.е. по завершении этих методов финансовые переводы должны быть завершены и отражены в балансе.
	 * Связано с тем, что processSubscription() и refund() могут вызываться в цикле с условием выхода по сумме баланса.
	 * Порождение транзакций из processSubscription() и refund() может привести к продолжению использования
	 * битой подписки (processSubscription() возвращает "хорошо" но её транзакции невыполняются)
	 * или неполному вовзрату баланса при закрытии аккаунта (refund() породил транзакции, часть которых не выполнилась).
	 * Эти проблемы, разумеется, возможно решить, но за счет усложнения бизнес-логики, сложность которой в модуле биллинга
	 * и так выше нормы и требует уменьшения.
	 */

	/**
	 * @param [integer]|null $ids
	 * @return [][id => integer, time => integer, user_id => integer,
	 *  external_id (optional) => integer (external transaction id, if initiated via createTransaction()),
	 *  url (optional) => string (invoice url),
	 *  code (optional) => boolean (authorization code is required),
	 *  actions_cnt => integer, payment_amount => string, payment_data => string]
	 * payment_data отобразится в описании транзакции
	 */
	public function getTransactions($transactionIds = null);

	/**
	 * @param integer $transactionId
	 * @param string $code authorization code (if required)
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 */
	public function processTransaction($transactionId, $code = null);

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
	 * @param integer $externalId
	 * @return [payment_data => string, transaction_data => mixed|null ] | null
	 *  null - ошибка связи
	 *  transaction_data = null - пополнение не прошло, подписка битая
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
	 *  null - ошибка связи
	 *  transaction_data = null - ошибка операции
	 */
	public function refund($transactionData, $externalId, $actionsCnt = null, $note = null);

	/**
	 * Удалить лог и др. служебные данные
	 * @param integer $time UnixTime старше которого удалить
	 */
	public function clear($time);
}
