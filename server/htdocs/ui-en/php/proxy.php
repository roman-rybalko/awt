<?php
require_once '../../../web_construction_set/autoload.php';
if (isset($_COOKIE['proxy_target'])) {
	header('Location: ' . \WebConstructionSet\Url\Tools::getMyUrlName() . '?' . $_COOKIE['proxy_target'] . '?' . $_SERVER['QUERY_STRING']);
	setcookie('proxy_target', '', 1);  // delete cookie
	exit(0);
}
$proxy = new \WebConstructionSet\ContentModifier\Proxy($_SERVER['QUERY_STRING']);
$mod = new \WebConstructionSet\ContentModifier\Proxy\Modifier\Html();
$mod->base(function($href) {
	$href = preg_replace('/^\s+/', '', $href);
	if (preg_match('~^\w+://~', $href))
		return $href;
	if (preg_match('~^//~', $href))
		return $href;
	if (preg_match('~^/~', $href))
		return \WebConstructionSet\Url\Tools::normalize(\WebConstructionSet\Url\Tools::makeServerUrl($_SERVER['QUERY_STRING']) . $href);
	if ($href) {
		return \WebConstructionSet\Url\Tools::normalize(preg_replace('~/[^\/]+$~', '/', $_SERVER['QUERY_STRING']) . $href);
	}
	return $_SERVER['QUERY_STRING'];
});
$mod->addScript(null, 'var _proxy_url = \'' . \WebConstructionSet\Url\Tools::getMyUrlName() . '\';');
$mod->addScript(null, 'var _target_url = \'' . $_SERVER['QUERY_STRING'] . '\';');
$mod->addScript(\WebConstructionSet\Url\Tools::getNeighbourUrl('../js/jquery.min.js'));
$mod->addScript(\WebConstructionSet\Url\Tools::getNeighbourUrl('../js/jquery.cookie.min.js'));
$mod->addScript(\WebConstructionSet\Url\Tools::getNeighbourUrl('../js/xpath-browser-server.js'));
$mod->addScript(\WebConstructionSet\Url\Tools::getNeighbourUrl('../js/xpath-composer-server.js'));
$mod->addScript(\WebConstructionSet\Url\Tools::getNeighbourUrl('../js/proxy.js'));
$proxy->addModifier($mod);
$proxy->run();
