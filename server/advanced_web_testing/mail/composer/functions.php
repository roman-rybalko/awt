<?php

function composer_file2b64($scope, $name) {
	switch ($scope) {
		case 'www':
			$path = \Config::$rootPath . \Config::WWW_PATH . $name;
			break;
		case 'result':
			$path = \Config::$rootPath . \Config::RESULT_DATA_PATH . $name;
			break;
		default:
			return '';
			break;
	}
	$data = file_get_contents($path);
	$data = base64_encode($data);
	$data = chunk_split($data, 72);
	return $data;
}

function composer_mime_encode($value) {
	return mb_encode_mimeheader($value, 'UTF-8');
}

// xsl generate-id() генерит коллизии
function composer_random() {
	return time() . rand();
}

function composer_basename($path) {
	return basename($path);
}

function composer_transform($xsltFile, $nodes) {
	$data = '';
	foreach ($nodes as $node) {
		$composer = new \AdvancedWebTesting\Mail\Composer(dirname($node->baseURI) . '/' . $xsltFile);
		$data .= $composer->process($node);
	}
	return $data;
}

function composer_fileName2mimeType($fileName) {
	if (preg_match('/\.jpg$|\.jpeg$/i', $fileName))
		return 'image/jpeg';
	if (preg_match('/\.gif$/i', $fileName))
		return 'image/gif';
	if (preg_match('/\.png$/i', $fileName))
		return 'image/png';
	if (preg_match('/\.bmp$/i', $fileName))
		return 'image/bmp';
	return 'application/octet-stream';
}