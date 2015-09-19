<?php

namespace AdvancedWebTesting\Mail;

include_once __DIR__ . '/composer/functions.php';

/**
 * Формирование почтового сообщения
 * Model (MVC)
 */
class Composer {
	private $xslt, $xslBasePath;

	public function __construct($xsltFile) {
		$errHandler = new \WebConstructionSet\Xml\LibxmlErrorHandler();
		$this->xslt = new \XSLTProcessor();
		$this->xslt->registerPHPFunctions([
			'composer_file2b64',
			'composer_mime_encode',
			'composer_random',
			'composer_basename',
			'composer_transform',
			'composer_fileName2mimeType'
		]);
		$xsl = new \DOMDocument();
		if (!$xsl->load($xsltFile))
			throw new \ErrorException('XSLT file ' . $xsltFile . ' load failed: ' . $errHandler->getErrorString(), null, null, __FILE__, __LINE__);
		if (!$this->xslt->importStylesheet($xsl))
			throw new \ErrorException('XSLT stylesheet ' . $xsltFile . ' import failed: ' . $errHandler->getErrorString(), null, null, __FILE__, __LINE__);
		$this->xslBasePath = $xsltFile;
	}

	/**
	 * @param string $xml буфер с XML
	 * @return string буфер с результатом
	 */
	public function process($xmlData) {
		$errHandler = new \WebConstructionSet\Xml\LibxmlErrorHandler();
		$xml = new \DOMDocument();
		if (is_string($xmlData))
			$xml->loadXML($xmlData);
		else
			$xml->appendChild($xml->importNode($xmlData, true));
		if ($errstr = $errHandler->getErrorString()) {
			error_log('AdvancedWebTesting\Mail\Composer::process(): xml load failed: ' . $errstr);
			return null;
		}
		$xml->documentURI = $this->xslBasePath;
		$data = $this->xslt->transformToXml($xml);
		if ($errstr = $errHandler->getErrorString()) {
			error_log('AdvancedWebTesting\Mail\Composer::process(): transform failed: ' . $errstr);
			return null;
		}
		$data = str_replace("\r\n", "\n", $data);
		$data = str_replace("\n", "\r\n", $data);
		return $data;
	}
}
