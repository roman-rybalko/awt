<?php
require_once __DIR__ . '/config.php';
echo @constant('\Config::' . $argv[1]);
