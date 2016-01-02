#! /bin/sh -e

case `hostname` in
	s1.*)
		H=s2.hosts.advancedwebtesting.net
	;;
	s2.*)
		H=s1.hosts.advancedwebtesting.net
	;;
	*)
		echo 'Unable to determine a replication peer.'
		exit 1
	;;
esac
P=64873
U=awt-repl
PW=`dirname $0`/`basename $0 .sh`.pw

LOCK=/tmp/`basename $0 .sh`.lock
LOG=/tmp/`basename $0 .sh`.log
if [ -e $LOCK ] && kill -0 `cat $LOCK` >/dev/null; then
	exit 0
fi

rm -Rf $LOCK
echo $$ > $LOCK

if rsync -aHSAXz6v --password-file=$PW --delete rsync://$U@$H:$P/www/* /var/www/ >$LOG 2>&1; then
	true
else
	rc=$?
	case $rc in
		24)
			# rsync warning: some files vanished before they could be transferred (code 24) at main.c(1655) [generator=3.1.1]
		;;
		*)
			echo "code: $rc"
			cat $LOG
		;;
	esac
fi

rm -Rf $LOCK $LOG
