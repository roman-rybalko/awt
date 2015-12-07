#! /bin/sh

if [ -z "$1" ]; then
	echo "USAGE: $0 <timeout_minutes> [config.sh] [config.sh] ..."
	exit 1
fi

timeout_minutes=$1
shift

pushd()
{
	oldd="`pwd`"
	cd "$1"
}

popd()
{
	cd "$oldd"
	oldd=.
}

for config in "$@"; do
	pushd "`dirname "$config"`"
	. ./"`basename "$config"`"
	if [ -n "$SINGLE_LOCK" ]; then
		T1=0`stat -c %Y "$SINGLE_LOCK" 2>/dev/null`
		T2=0`date -d "-$timeout_minutes minutes" +%s 2>/dev/null`
		if [ $T1 != 0 -a $T2 != 0 -a $T1 -lt $T2 ]; then
			shutdown -r
			echo "Watchdog, SINGLE_LOCK=$SINGLE_LOCK, T1=$T1, T2=$T2."
			exit 0
		fi
	fi
	popd
done
