<?php

class Config {
	const DB_DSN = 'mysql:host=localhost;dbname=awt';
	const DB_USER = 'awt';
	const DB_PASSWORD = 'awt';
	const TESTNODE_TOKEN = 'EtZGlOGWMGtEOptUcaQN98KTnPrXpvXgpY1orOue04';
	public static $rootPath;
	const RESULT_DATA_PATH = 'htdocs/results/';
	const MAIL_HOST = 'smtp.yandex.ru';
	const MAIL_PORT = 587;
	const MAIL_USER = 'test@advancedwebtesting.com';
	const MAIL_PASSWORD = 'test12';
	const MAIL_SENDER_NAME = 'Advanced Web Testing';
	const MAIL_SENDER_EMAIL = 'test@advancedwebtesting.com';
	const MAIL_TEMPLATE_PATH = 'mail/';
	const MAIL_ROOT_URL = 'http://www/awt/server/htdocs/';
	const WWW_PATH = 'htdocs/';
	const REGISTRATION_TOP_UP = 100;
}

\Config::$rootPath = __DIR__ . '/';

?>