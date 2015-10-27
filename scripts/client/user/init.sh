#! /bin/sh

set -e
set -x

cd "`dirname "$0"`"
. ./config.sh
rm -Rf "$SEL_HOME"
mkdir -p "$SEL_HOME"
chmod 0700 "$SEL_HOME"
[ -z "$SINGLE_LOCK" ] || while ! mkdir "$SINGLE_LOCK"; do sleep 1; done
