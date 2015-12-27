<?php

namespace AdvancedWebTesting;

class Error {
	public function run() {
		if (isset($_POST['data']))
			error_log($_POST['data']);
		if (isset($_GET['data']))
			error_log($_GET['data']);
	}
}