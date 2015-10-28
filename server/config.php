<?php

if (file_exists(dirname(__FILE__) . '/config.local.php'))
	require_once dirname(__FILE__) . '/config.local.php';
else
	require_once dirname(__FILE__) . '/config.sample.php';
