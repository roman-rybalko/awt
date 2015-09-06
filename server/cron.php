<?php
require_once 'web_construction_set/autoload.php';
\Config::$rootPath = __DIR__ . '/htdocs/';
$sched = new \AdvancedWebTesting\Schedule();
$sched->run();
