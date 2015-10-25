<?php

namespace AdvancedWebTesting\Mail;

/**
 * Типы отправляемых сообщений
 */
class Type {
	const EMAIL_VERIFICATION = 1;
	const TASK_REPORT = 2;
	const SCHED_FAIL_REPORT = 3;
	const RESET_PASSWORD = 4;
	const DELETE_ACCOUNT = 5;
}