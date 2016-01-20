<?php

namespace AdvancedWebTesting;

class Demo {
	private $db;

	public function __construct() {
		$this->db = new \WebConstructionSet\Database\Relational\Pdo(\Config::DB_DSN, \Config::DB_USER, \Config::DB_PASSWORD);
	}

	public function run() {
		$userDb = new \WebConstructionSet\Database\Relational\User($this->db);
		$user = new \WebConstructionSet\Accounting\User($userDb);
		if ($user->getId())
			$user->logout();
		$user->login('', null);
		$url = './';
		if (!empty($_SERVER['QUERY_STRING']))
			$url .= '?' . $_SERVER['QUERY_STRING'];
?>
<html>
<body>
Please, wait for page content is being preloaded...<br/>
<a href="./<?php echo $url; ?>" id="redirect">Continue</a><br/>
<script type="text/javascript">
	document.location = './<?php echo $url; ?>';
	var el = document.getElementById('redirect');
	el.parentElement.removeChild(el);
</script>
</body>
</html>
<?php
	}
}