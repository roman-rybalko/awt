#! /bin/sh

if [ -z "$1" ]; then
	echo "USAGE: $0 <timeout_minutes> <config.sh>"
	exit 1
fi
timeout_minutes=$1
config="$2"

cd "`dirname "$config"`"
. ./"`basename "$config"`"

if [ -n "$SINGLE_LOCK" ]; then
	T1=0`stat -c %Y "$SINGLE_LOCK" 2>/dev/null`
	T2=0`date -d "-$timeout_minutes minutes" +%s 2>/dev/null`
	[ $T1 = 0 -o $T2 = 0 ] || [ $T1 -gt $T2 ] || { shutdown -r && echo "Shutdown scheduled, SINGLE_LOCK=$SINGLE_LOCK, T1=$T1, T2=$T2." ; }
fi
