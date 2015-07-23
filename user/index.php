<?php

require_once '../common/web_construction_set/autoload.php';
require_once '../common/advanced_web_testing/autoload.php';

header('Content-Type: text/xml');
//\WebConstructionSet\OutputBuffer\XsltHtml::init();
\WebConstructionSet\OutputBuffer\XmlFormatter::init();
echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<?xml-stylesheet type="text/xsl" href="ui/index.xsl"?>';
$user = new \AdvancedWebTesting\Ui\User();
$user->run();
