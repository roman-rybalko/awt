<?php

namespace AdvancedWebTesting\Mail;

set_include_path(get_include_path() . PATH_SEPARATOR . __DIR__ . '/sender/');
include_once 'Net/SMTP.php';
\PEAR::setErrorHandling(PEAR_ERROR_EXCEPTION);

/**
 * Отправка почты
 * Model (MVC)
 */
class Sender {
	private $smtp;
	const TIMEOUT = 10;

	/**
	 * Присоединиться к хосту, пройти аутентификацию
	 * @param string $host
	 * @param integer $port
	 * @param string $user
	 * @param string $password
	 */
	public function __construct($host, $port = 587, $user = null, $password = null) {
		$this->smtp = new \Net_SMTP($host, $port, null,
			false /* getResponse() does not work with pipelining */, Sender::TIMEOUT);
		$this->smtp->connect(Sender::TIMEOUT);
		if ($user !== null)
			try {
				$this->smtp->auth($user, $password);
			} catch (\Exception $e) {
				error_log('Mail\Sender::__construct(response=' . implode(' ', $this->smtp->getResponse()) . ')');
				throw $e;
			}
	}

	/**
	 * Отправить сообщение
	 * @param string $sender
	 * @param string $rcpt
	 * @param string $data
	 * @return string|null ответ на команду DATA
	 */
	public function send($sender, $rcpt, $data) {
		try {
			$this->smtp->rset();
			$this->smtp->mailFrom($sender);
			$this->smtp->rcptTo($rcpt);
			$this->smtp->data($data);
			return implode(' ', $this->smtp->getResponse());
		} catch (\Exception $e) {
			error_log('Mail\Sender::send(from=' . $sender . ' to=' . $rcpt . ' response=' . implode(' ', $this->smtp->getResponse()) . '): ' . $e);
			return null;
		}
	}

	/**
	 * Отправить QUIT, закрыть соединение
	 */
	public function __destruct() {
		try {
			$this->smtp->disconnect();
		} catch (\Exception $e) {
			error_log('Mail\Sender::__destruct(response=' . implode(' ', $this->smtp->getResponse()) . '): ' . $e);
		}
	}
}
