#! /bin/sh -ex

DUMP=$1

echo "set autocommit = 0;"
echo "start transaction;"
sed -r -e 's/.*insert into (\S+).*/delete from \1;/i' < $DUMP
cat $DUMP
echo "commit;"
