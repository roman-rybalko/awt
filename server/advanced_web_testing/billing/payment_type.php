<?php

namespace AdvancedWebTesting\Billing;

class PaymentType {
	const DEMO = 1;
	const PAYPAL = 2;
	const RBKMONEY = 3;

	public static function toString($type) {
		switch ($type) {
			case PaymentType::DEMO:
				return 'Demo';
			case PaymentType::PAYPAL:
				return 'PayPal';
			case PaymentType::RBKMONEY:
				return 'RBK Money';
			default:
				return '';
		}
	}
}
