#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl free1.txt advanced.txt website1.txt crossbrowser.txt testing1.txt
	combine.pl free1.txt advanced.txt website1.txt task.txt automation1.txt
	combine.pl free1.txt advanced.txt website1.txt uptime.txt monitoring1.txt
} | grep -vP 'web.+web' | grep -vP 'web.+url' | grep -vP 'url.+web' \
| fix_keywords.pl -b | sort -u | txt2csv.pl > out/`basename $0 .sh`.csv
