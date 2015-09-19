<?php

require_once 'web_construction_set/autoload.php';

$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);

$taskSched = new \AdvancedWebTesting\Task\Schedule($db, null);
try {
	$taskSched->start();
} catch (\Exception $taskSchedException) {}

$mailMgr = new \AdvancedWebTesting\Mail\Manager($db, null);
try {
	$mailMgr->send();
} catch (\Exception $mailMgrException) {}

if (isset($taskSchedException))
	throw $taskSchedException;
if (isset($mailMgrException))
	throw $mailMgrException;
