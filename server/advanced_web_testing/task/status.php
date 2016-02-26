<?php

namespace AdvancedWebTesting\Task;

class Status {
	const INITIAL = 1;
	const STARTING = 2;
	const RUNNING = 3;
	const SUCCEEDED = 4;
	const FAILED = 5;
	const CANCELLED = 6;

	public static function toString($status) {
		switch ($status) {
			case Status::INITIAL:
				return 'initial';
			case Status::STARTING :
				return 'starting';
			case Status::RUNNING :
				return 'running';
			case Status::SUCCEEDED :
				return 'succeeded';
			case Status::FAILED :
				return 'failed';
			case Status::CANCELLED:
				return 'cancelled';
			default :
				return '';
		}
	}
}