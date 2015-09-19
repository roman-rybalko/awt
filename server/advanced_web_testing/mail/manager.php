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
	public function scheduleEmailVerification($email, $url) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => 'email_verification', 'email' => $email, 'url' => $url,
			'message_id' => $this->makeMessageId(), 'time' => time(),
			'root_url' => \WebConstructionSet\Url\Tools::getMyUrlPath()
		]], $this->userId);
	}

	/**
	 * @param string $email
	 * @param integer $taskId
	 * @return integer reportId
	 */
	public function scheduleTaskReport($email, $taskId) {
		return $this->anacron->create(['start' => time(), 'period' => Manager::RETRY_TIMEOUT, 'data' => [
			'type' => 'task_report', 'email' => $email, 'task_id' => $taskId,
			'message_id' => $this->makeMessageId(), 'time' => time(),
			'root_url' => \WebConstructionSet\Url\Tools::getMyUrlPath()
		]], $this->userId);
	}

	public function send() {
		if ($jobs = $this->anacron->ready($this->userId)) {
			$sender = new \AdvancedWebTesting\Mail\Sender(\Config::MAIL_HOST, \Config::MAIL_PORT, \Config::MAIL_USER, \Config::MAIL_PASSWORD);
			$composer = new \AdvancedWebTesting\Mail\Composer(\Config::$rootPath . \Config::MAIL_TEMPLATE_PATH . 'index.xsl');
			foreach ($jobs as $job) {
				$data = $job['data'];
				$userId = $job['key'];
				$mailData = '<mail message_id="' . htmlspecialchars($data['message_id']) . '"'
					. ' date="' . htmlspecialchars(date('r', $data['time'])) . '"'
					. ' from="' . htmlspecialchars(\Config::MAIL_SENDER_NAME . ' <' . \Config::MAIL_SENDER_EMAIL . '>') . '"'
					. ' to="' . htmlspecialchars($data['email']) . '"'
					. ' root_url="' . htmlspecialchars($data['root_url']) . '">';
				switch ($data['type']) {
					case 'email_verification':
						$mailData .= '<verification url="' . htmlspecialchars($data['url']) . '"/>';
						break;
					case 'task_report':
						$taskUsr = new \AdvancedWebTesting\User\Task($this->db, $userId);
						$mailData .= $taskUsr->get($data['task_id']);
						break;
					default:
						error_log('Bad mail task type: ' . $data['type']);
						$mailData = '';
						break;
				}
				$mailData .= '</mail>';
				if ($mailBody = $composer->process($mailData))
					if ($reply = $sender->send(\Config::MAIL_SENDER_EMAIL, $data['email'], $mailBody)) {
						$histMgr = new \AdvancedWebTesting\History\Manager($this->db, $userId);
						switch ($data['type']) {
							case 'email_verification':
								$histMgr->add('mail_verification', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply]);
								break;
							case 'task_report':
								$taskMgr = new \AdvancedWebTesting\Task\Manager($this->db, $userId);
								if ($tasks = $taskMgr->get([$data['task_id']]))
									$task = $tasks[0];
								$histMgr->add('mail_task', ['rcpt' => $data['email'] , 'message_id' => $data['message_id'], 'smtp_response' => $reply,
									'task_id' => $data['task_id'], 'test_name' => $task['test_name']]);
								break;
						}
						$this->anacron->delete($job['id'], $job['key']);
					}
			}
		}
	}

	private function makeMessageId() {
		return time() . rand() . '@' . $_SERVER['HTTP_HOST'];
	}
}
