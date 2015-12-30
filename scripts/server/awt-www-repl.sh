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

L=/tmp/`basename $0 .sh`.lock
if [ -e $L ] && kill -0 `cat $L` >/dev/null; then
	exit 0
fi

rm -Rf $L
echo $$ > $L

rsync -aHSAXz6 --password-file=$PW --delete rsync://$U@$H:$P/www/* /var/www/

rm -Rf $L
