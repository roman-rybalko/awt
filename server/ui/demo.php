<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
$userDb = new \WebConstructionSet\Database\Relational\User($db);
$user = new \WebConstructionSet\Accounting\User($userDb);
if ($user->getId())
	$user->logout();
$user->login('', null);
header('Location: ./' . (empty($_SERVER['QUERY_STRING']) ? '' : '?' . $_SERVER['QUERY_STRING']));
