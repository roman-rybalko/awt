<?php

namespace AdvancedWebTesting\Billing;

class TransactionType {
	const TOP_UP = 1;
	const SERVICE = 2;
	const TASK_START = 3;
	const TASK_FINISH = 4;
	const REFUND = 5;

	public static function toString($type) {
		switch ($type) {
			case TransactionType::TOP_UP:
				return 'top_up';
			case TransactionType::SERVICE:
				return 'service';
			case TransactionType::TASK_START:
				return 'task_start';
			case TransactionType::TASK_FINISH :
				return 'task_finish';
			case TransactionType::REFUND:
				return 'refund';
			default:
				return '';
		}
	}
}
