<?php
require_once '../web_construction_set/autoload.php';
\Config::$rootPath = __DIR__ . '/';
$sched = new \AdvancedWebTesting\Sched();
$sched->run();
