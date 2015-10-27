#! /bin/sh

set -e
set -x

cd "`dirname "$0"`"
. ./config.sh
rm -Rf "$SEL_HOME"
[ -z "$SINGLE_LOCK" ] || rm -Rf "$SINGLE_LOCK"
