<?php

namespace AdvancedWebTesting\Billing;

class PaymentType {
	const PAYPAL = 1;
	const RBKMONEY = 2;

	public static function toString($type) {
		switch ($type) {
			case PaymentType::PAYPAL:
				return 'PayPal';
			case PaymentType::RBKMONEY:
				return 'RBK Money';
			default:
				return '';
		}
	}
}
