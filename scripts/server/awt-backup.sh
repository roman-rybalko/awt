#! /bin/sh -e

AWTD="/srv/www/htdocs/awt/server"
AWTD="/var/www/awt"
B=awt.sql
B=/var/backups/awt.sql
GC="php $AWTD/getconf.php"
H=`$GC DB_DSN | sed -r -e 's/.*host=([^;]+).*/\1/'`
DB=`$GC DB_DSN | sed -r -e 's/.*dbname=([^;]+).*/\1/'`

mysqldump --single-transaction --quick \
	--compact --complete-insert --extended-insert --no-create-db --no-create-info \
	--result-file=$B \
	--user=`$GC DB_USER` --password=`$GC DB_PASSWORD` --host=$H $DB

chmod og-rwx $B
