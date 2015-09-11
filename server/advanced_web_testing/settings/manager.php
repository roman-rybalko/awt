<?php

namespace AdvancedWebTesting\Settings;

/**
 * Настройки
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db, $userId) {
		$this->table = new \WebConstructionSet\Database\TableWrapper($db, 'settings', ['user_id' => $userId]);
		if (!$this->table->select(['user_id']))
			if (!$this->table->insert([]))
				throw \ErrorException('Settings data init failed', null, null, __FILE__, __LINE__);
	}

	public function set($email = null, $taskFailEmailReport = null, $taskSuccessEmailReport = null) {
		$settings = [];
		if ($email !== null)
			$settings['email'] = $email;
		if ($taskFailEmailReport !== null)
			$settings['task_fail_email_report'] = $taskFailEmailReport;
		if ($taskSuccessEmailReport !== null)
			$settings['task_success_email_report'] = $taskSuccessEmailReport;
		return $this->table->update($settings, []);
	}

	/**
	 * @return [email => string, task_fail_email_report => boolean, task_success_email_report => boolean]
	 */
	public function get() {
		$settings = [];
		if ($data = $this->table->select(['email', 'task_fail_email_report', 'task_success_email_report'])) {
			$data1 = $data[0];
			foreach (['email', 'task_fail_email_report', 'task_success_email_report'] as $param)
				if ($data1[$param])
					$settings[$param] = $data1[$param];
				else
					$settings[$param] = '';
		}
		return $settings;
	}
}