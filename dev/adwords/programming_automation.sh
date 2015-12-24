#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl proglangs1.txt advanced.txt website1.txt task.txt automation1.txt free.txt
} | grep -vP 'web.+web' | grep -vP 'web.+url' | grep -vP 'url.+web' | grep -vP 'auto.+auto' \
| fix_keywords.pl -b | sort -u | txt2csv.pl > out/`basename $0 .sh`.csv
