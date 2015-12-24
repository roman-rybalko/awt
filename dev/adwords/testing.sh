#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl free.txt advanced.txt website1.txt crossbrowser.txt testing1.txt software.txt
} | grep -vP 'web.+web' | grep -vP 'url.+web' | grep -vP 'web.+url' | grep -vP 'free.+free' | grep -vP 'ware.+ware' \
| sort -u | txt2csv.pl > out/`basename $0 .sh`.csv
