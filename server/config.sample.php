<?php

class Config {
	const DB_DSN = 'mysql:host=localhost;dbname=XXX';
	const DB_USER = 'XXX';
	const DB_PASSWORD = 'XXX';
	const TESTNODE_TOKEN = 'xxx';
	public static $rootPath;
	const RESULTS_PATH = 'ui/results/';
	const MAIL_HOST = 'localhost';
	const MAIL_PORT = 25;
	const MAIL_USER = null;
	const MAIL_PASSWORD = null;
	const MAIL_SENDER_NAME = 'AWT Reporter';
	const MAIL_SENDER_EMAIL = 'dev@null.com';
	const MAIL_TEMPLATE_PATH = 'mail/';
	const UI_URL = 'https://advancedwebtesting.com/ui/';
	const UI_PATH = 'ui/';
	const REGISTRATION_TOP_UP = 100;
}

\Config::$rootPath = __DIR__ . '/';

?>