<?php

namespace AdvancedWebTesting;

class Tools {
	public static function valueOrNull($array, $name, $value = null) {
		return isset($array[$name]) && $array[$name] !== $value ? $array[$name] : null;
	}
}