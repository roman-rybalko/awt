<?php

namespace AdvancedWebTesting\User;

class Tools {
	public static function formatTime($time) {
		return date('Y/m/d H:i:s', $time) . ' UTC';
	}

	public static function valueOrNull($array, $name) {
		return isset($array[$name]) && $array[$name] ? $array[$name] : null;
	}
}