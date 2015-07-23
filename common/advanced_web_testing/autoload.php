<?php

/**
 * Загружает класс.
 * Путь к файлу: Path\NameSpace\ClassName -> path/name_space/class_name.php
 * @param string $classname
 */
spl_autoload_register(function($classname) {
	$names = explode('\\', $classname);
	foreach ($names as &$name) {
		$new_name = strtolower($name[0]);
		for ($i = 1; $i < strlen($name); ++$i) {
			if (ctype_upper($name[$i]))
				$new_name .= '_';
			$new_name .= strtolower($name[$i]);
		}
		$name = $new_name;
	}
	$filename = implode('/', $names) . '.php';
	// пробуем загрузить по абсолютному пути (наши классы), затем по относительному (пользовательские классы)
	if (file_exists(dirname(__FILE__) . '/../' . $filename)) {  // пробуем загрузить если autoload.php лежит рядом с нашими классами
		require_once dirname(__FILE__) . '/../' . $filename;
	} else if (file_exists(dirname(__FILE__) . '/' . $filename)) {  // пробуем загрузить если autoload.php лежит в корне
		require_once dirname(__FILE__) . '/' . $filename;
	} else if (file_exists($filename)) {  // пробуем загрузить по относительному пути
		require_once $filename;
	}
});
