#! /bin/sh -e

AWTD="/srv/www/htdocs/awt/server"
AWTD="/var/www/awt"
B=awt.sql
B=/var/backups/awt/db.sql
U=awt-bak
P=9z4NC5cUD68XM7EYHrgKjF
DB=awt

mysqldump --compress --single-transaction --quick --compact --master-data \
	--no-create-db \
	--add-drop-table \
	--complete-insert --extended-insert \
	--result-file=$B \
	--user=$U --password=$P \
	$DB

chmod 0440 $B
