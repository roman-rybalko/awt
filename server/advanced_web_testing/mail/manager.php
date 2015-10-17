<?php

namespace AdvancedWebTesting\Mail;

/**
 * Управление отправкой почты
 * Model (MVC)
 */
class Manager {
	private $anacron, $db, $userId;
	const RETRY_TIMEOUT = 3600;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->anacron = new \WebConstructionSet\Database\Relational\Anacron($db, 'mail_schedule');
		$this->db = $db;
		$this->userId = $userId;
	}

	/**
	 * @param string $email
	 * @param string $url Адрес, который вставить в сообщение, по которому должен перейти пользователь.
	 * @return integer reportId
	 */
	public function emailVerification($email, $login, $url) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => Type::EMAIL_VERIFICATION, 'email' => $email,
			'login' => $login, 'url' => $url,
			'message_id' => $this->makeMessageId(), 'time' => time(), 'root_url' => \Config::UI_URL
		]], $this->userId);
	}

	/**
	 * @param string $email
	 * @param integer $taskId
	 * @return integer reportId
	 */
	public function taskReport($email, $taskId) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => Type::TASK_REPORT, 'email' => $email,
			'task_id' => $taskId,
			'message_id' => $this->makeMessageId(), 'time' => time(), 'root_url' => \Config::UI_URL
		]], $this->userId);
	}

	public function schedFailReport($email, $testId, $testName, $schedId, $schedName, $message) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => Type::SCHED_FAIL_REPORT, 'email' => $email,
			'test_id' => $testId, 'test_name' => $testName, 'sched_id' => $schedId, 'sched_name' => $schedName, 'message' => $message,
			'message_id' => $this->makeMessageId(), 'time' => time(), 'root_url' => \Config::UI_URL
		]], $this->userId);
	}

	public function passwordReset($email, $login, $url) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => Type::PASSWORD_RESET, 'email' => $email,
			'login' => $login, 'url' => $url,
			'message_id' => $this->makeMessageId(), 'time' => time(), 'root_url' => \Config::UI_URL
		]], $this->userId);
	}

	public function send() {
		if ($jobs = $this->anacron->ready($this->userId)) {
			$sender = new \AdvancedWebTesting\Mail\Sender(\Config::MAIL_HOST, \Config::MAIL_PORT, \Config::MAIL_USER, \Config::MAIL_PASSWORD);
			$composer = new \AdvancedWebTesting\Mail\Composer(\Config::$rootPath . \Config::MAIL_TEMPLATE_PATH . 'index.xsl');
			foreach ($jobs as $job) {
				$data = $job['data'];
				$userId = $job['key'];
				if (!$data['email']) {
					$this->anacron->delete($job['id'], $job['key']);
					error_log('Mail Manager: empty rcpt, job:' . json_encode($job));
					continue;
				}
				$mailData = '<mail message_id="' . htmlspecialchars($data['message_id']) . '"'
					. ' date="' . htmlspecialchars(date('r', $data['time'])) . '"'
					. ' from="' . htmlspecialchars(\Config::MAIL_SENDER_NAME . ' <' . \Config::MAIL_SENDER_EMAIL . '>') . '"'
					. ' to="' . htmlspecialchars($data['email']) . '"'
					. ' root_url="' . htmlspecialchars($data['root_url']) . '">';
				switch ($data['type']) {
					case Type::EMAIL_VERIFICATION:
						$mailData .= '<verification login="' . htmlspecialchars($data['login']) . '" url="' . htmlspecialchars($data['url']) . '"/>';
						break;
					case Type::TASK_REPORT:
						$taskUsr = new \AdvancedWebTesting\User\Task($this->db, $userId);
						$mailData .= $taskUsr->get($data['task_id']);
						break;
					case Type::SCHED_FAIL_REPORT:
						$mailData .= '<sched_fail message="' . $data['message'] . '"'
							. ' test_id="' . $data['test_id'] . '" test_name="' . htmlspecialchars($data['test_name']) . '"'
							. ' sched_id="' . $data['sched_id'] . '" sched_name="' . htmlspecialchars($data['sched_name']) . '"'
							. '/>';
						break;
					case Type::PASSWORD_RESET:
						$mailData .= '<password_reset login="' . htmlspecialchars($data['login']) . '" url="' . htmlspecialchars($data['url']) . '"/>';
						break;
					default:
						$this->anacron->delete($job['id'], $job['key']);
						error_log('Bad mail task type: ' . $data['type'] . ', job:' . json_encode($job));
						continue;
				}
				$mailData .= '</mail>';
				if ($mailBody = $composer->process($mailData))
					if ($reply = $sender->send(\Config::MAIL_SENDER_EMAIL, $data['email'], $mailBody)) {
						$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
						switch ($data['type']) {
							case Type::EMAIL_VERIFICATION:
								$histMgr->add('mail_verification', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply]);
								break;
							case Type::TASK_REPORT:
								$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
								if ($tasks = $taskMgr->get([$data['task_id']]))
									$task = $tasks[0];
								$histMgr->add('mail_task', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply,
									'task_id' => $data['task_id'], 'test_name' => $task['test_name']]);
								break;
							case Type::SCHED_FAIL_REPORT:
								$histMgr->add('mail_sched_fail', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply,
									'test_id' => $data['test_id'], 'test_name' => $data['test_name'],
									'sched_id' => $data['sched_id'], 'sched_name' => $data['sched_name']]);
								break;
							case Type::PASSWORD_RESET:
								$histMgr->add('mail_password_reset', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply]);
								break;
						}
						$this->anacron->delete($job['id'], $job['key']);
					}
			}
		}
	}

	private function makeMessageId() {
		return time() . rand() . '@' . parse_url(\Config::UI_URL)['host'];
	}
}
