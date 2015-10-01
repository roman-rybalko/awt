<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
$userDb = new \WebConstructionSet\Database\Relational\User($db);
$user = new \WebConstructionSet\Accounting\User($userDb);
if ($user->getId())
	$user->logout();
$user->login('', 'Kh2j9EIE2oMPyaYTz7u83XdLnPPf7AoHLIDkyQdu19');
header('Location: ./');
