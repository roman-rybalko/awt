#! /bin/sh

set -e
set -x

cd "`dirname "$0"`"
. ./config.sh
cd client
if [ -n "$X_FILE" ]; then
	pgrep ${NODE_ID}-x || nohup npm run-script x >> ../x.log 2>&1 &
	while ! [ -e "$X_FILE" ]; do sleep 1; done
fi
if [ -n "$SEL_ADDR" ]; then
	pgrep ${NODE_ID}-selenium || HOME="$SEL_HOME" nohup npm run-script selenium >> ../selenium.log 2>&1 &
	while ! GET "$SEL_ADDR"; do sleep 1; done
	pgrep ${NODE_ID}-batch || nohup npm run-script batch >> ../batch.log 2>&1 &
else
	pgrep ${NODE_ID}-batch || PATH=$HOME/bin:$PATH HOME="$SEL_HOME" nohup npm run-script batch >> ../batch.log 2>&1 &
fi
