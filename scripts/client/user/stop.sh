#! /bin/sh

set -e
set -x

cd "`dirname "$0"`"
. ./config.sh
#for s in batch selenium x; do
for s in batch x; do
#for s in batch; do
	pgrep ${NODE_ID}-$s | xargs kill
	while pgrep ${NODE_ID}-$s; do sleep 1; done
done
rm -Rf "$X_FILE"
