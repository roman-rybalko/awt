<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
$wm = new \AdvancedWebTesting\Billing\PaymentBackend\Webmoney($db, null);
$wm->handleResultUrl();
