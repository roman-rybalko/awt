#! /bin/sh

cd "`dirname "$0"`"
. ./config.sh
if [ -n "$SINGLE_LOCK" ]; then
	T1=0`stat -c %Y "$SINGLE_LOCK" 2>/dev/null`
	T2=0`date -d '-10 minutes' +%s 2>/dev/null`
	[ $T1 = 0 -o $T2 = 0 ] || [ $T1 -gt $T2 ] || rm -Rvf "$SINGLE_LOCK"
fi
