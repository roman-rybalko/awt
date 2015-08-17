<?php

namespace AdvancedWebTesting\User;

date_default_timezone_set('UTC');

class Tools {
	public static function formatTime($time) {
		return date('Y/m/d H:i:s', $time) . ' UTC';
	}

	public static function valueOrNull($array, $name) {
		return isset($array[$name]) && $array[$name] ? $array[$name] : null;
	}
}