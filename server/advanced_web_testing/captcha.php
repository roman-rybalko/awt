<?php

namespace AdvancedWebTesting;

require_once __DIR__ . '/captcha/Captcha.php';

/**
 * Генерация и обработка captcha
 * View, Controller (MVC)
 */
class Captcha {
	const TIMEOUT = 60;

	public function __construct() {
		if (session_status() != PHP_SESSION_ACTIVE)
			session_start();
	}

	public function get() {
		if (isset($_SESSION['captcha_value']))
			if (time() < $_SESSION['captcha_time'] + Captcha::TIMEOUT) {
				$value = $_SESSION['captcha_value'];
				unset($_SESSION['captcha_value']);
				unset($_SESSION['captcha_time']);
				return $value;
			}
		return null;
	}

	public function display() {
		$_SESSION['captcha_time'] = time();
		$captcha = new \SimpleCaptcha();
		$captcha->sessionVar = 'captcha_value';
		$captcha->createImage();
	}
}
