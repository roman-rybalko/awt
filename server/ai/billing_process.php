<?php
require_once '../web_construction_set/autoload.php';
$db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
$billMgr = new \AdvancedWebTesting\Billing\Manager($db, null);
header('Content-Type: text/plain');
$pendingTransactions = $billMgr->getPendingTransactions();
print_r($pendingTransactions);
foreach ($pendingTransactions as $pendingTransaction) {
	echo 'processing transaction payment_type:',
		\AdvancedWebTesting\Billing\PaymentType::toString($pendingTransaction['payment_type']),
		' id:', $pendingTransaction['id'],
		' result:';
	$billMgr2 = new \AdvancedWebTesting\Billing\Manager($db, $pendingTransaction['user_id']);
	print_r($billMgr2->processPendingTransaction($pendingTransaction['payment_type'], $pendingTransaction['id']));
	echo "\n";
}
$pendingTransactions = $billMgr->getPendingTransactions();
print_r($pendingTransactions);
