<?php
require_once '../common/web_construction_set/autoload.php';
header('Content-Type: text/xml');
//\WebConstructionSet\OutputBuffer\XsltHtml::init();
//\WebConstructionSet\OutputBuffer\XmlFormatter::init();
echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<?xml-stylesheet type="text/xsl" href="ui/index.xsl"?>';
\Config::$rootPath = __DIR__ . '/';
$user = new \AdvancedWebTesting\User();
$user->run();
