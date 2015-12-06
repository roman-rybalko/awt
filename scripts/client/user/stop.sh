#! /bin/sh

set -e
set -x

cd "`dirname "$0"`"
. ./config.sh
stop()
{
	s=$1
	pgrep ${NODE_ID}-$s | xargs kill
	while pgrep ${NODE_ID}-$s; do sleep 1; done
}
stop batch
[ -z "$SEL_ADDR" ] || stop selenium
if [ -n "$X_FILE" ]; then
	stop x
	rm -Rf "$X_FILE"
fi
