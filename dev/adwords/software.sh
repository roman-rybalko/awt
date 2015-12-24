#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl advanced.txt website1.txt crossbrowser.txt testing1.txt software1.txt free.txt
	combine.pl advanced.txt website1.txt task.txt automation1.txt software1.txt free.txt
	combine.pl advanced.txt website1.txt uptime.txt monitoring1.txt software1.txt free.txt
} | grep -vP 'web.+web' | grep -vP 'url.+web' | grep -vP 'web.+url' | grep -vP 'free.+free' | grep -vP 'ware.+ware' | grep -vP 'auto.+auto' \
| sort -u | txt2csv.pl > out/`basename $0 .sh`.csv
