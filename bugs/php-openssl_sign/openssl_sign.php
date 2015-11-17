<?php

$data = file_get_contents('txt');

// fetch private key from file and ready it
$pkeyid = openssl_pkey_get_private("file://key.pem");

// compute signature
openssl_sign($data, $signature, $pkeyid);

// free the key from memory
openssl_free_key($pkeyid);

echo base64_encode($signature), "\n";
