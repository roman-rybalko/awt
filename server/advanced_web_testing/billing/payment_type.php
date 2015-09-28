<?php

namespace AdvancedWebTesting\Billing;

class PaymentType {
	const MANUAL = 1;
	const PAYPAL = 2;

	public static function toString($type) {
		switch ($type) {
			case PaymentType::MANUAL:
				return 'manual';
			case PaymentType::PAYPAL:
				return 'paypal';
			default :
				return '';
		}
	}
}
