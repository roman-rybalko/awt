<?php

namespace AdvancedWebTesting\User;

class Tools {
	public static function valueOrNull($array, $name) {
		return isset($array[$name]) && $array[$name] ? $array[$name] : null;
	}
}