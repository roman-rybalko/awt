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
	const SIGN_UP_BONUS = 200;
	const PAYPAL_USER = 'paypal-dev-biz1_api1.romanr.info';
	const PAYPAL_PASSWORD = 'EVZ94D6J4D79666B';
	const PAYPAL_SIGNATURE = 'AFcWxV21C7fd0v3bYYYRCpSSRl31A4mKpRLpIJARBcgYnwfQqUCoZFC3';
	const PAYPAL_SANDBOX = true;
}

\Config::$rootPath = __DIR__ . '/';

?>