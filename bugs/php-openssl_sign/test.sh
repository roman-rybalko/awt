#! /bin/sh
openssl genrsa -out key.pem 1024
openssl rsa -pubout -in key.pem -out key.pub
php openssl_sign.php | base64 -d > sig
#openssl rsautl -sign -inkey key.pem -out sig -in txt
openssl rsautl -verify -inkey key.pub -pubin -in sig > txt.v
diff -u txt txt.v && echo OK
rm -f key.pem key.pub sig txt.v
