<?php

class Config {
	const DB_DSN = 'mysql:host=localhost;dbname=awt';
	const DB_USER = 'awt';
	const DB_PASSWORD = 'awt';
	const TESTNODE_TOKEN = 'EtZGlOGWMGtEOptUcaQN98KTnPrXpvXgpY1orOue04';
	public static $rootPath;
	const RESULTS_PATH = 'ui/results/';
	const MAIL_HOST = 'smtp.yandex.ru';
	const MAIL_PORT = 587;
	const MAIL_USER = 'test@advancedwebtesting.com';
	const MAIL_PASSWORD = 'test12';
	const MAIL_SENDER_NAME = 'Advanced Web Testing';
	const MAIL_SENDER_EMAIL = 'test@advancedwebtesting.com';
	const MAIL_TEMPLATE_PATH = 'mail/';
	const UI_URL = 'http://www/awt/server/ui/';
	const UI_PATH = 'ui/';
	const REGISTRATION_TOP_UP = 100;
}

\Config::$rootPath = __DIR__ . '/';

?>