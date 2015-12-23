#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl free.txt website1.txt crossbrowser.txt testing1.txt software1.txt free.txt
	combine.pl free.txt website1.txt task.txt automation1.txt software1.txt free.txt
	combine.pl free.txt website1.txt uptime.txt monitoring1.txt software1.txt free.txt
	combine.pl free.txt crossbrowser.txt testing1.txt preposition.txt article.txt website1.txt software1.txt free.txt
	combine.pl free.txt task.txt automation1.txt preposition.txt article.txt website1.txt software1.txt free.txt
	combine.pl free.txt monitoring1.txt preposition.txt article.txt website1.txt software1.txt free.txt
	combine.pl free.txt software1.txt website1.txt crossbrowser.txt testing1.txt free.txt
	combine.pl free.txt software1.txt website1.txt task.txt automation1.txt free.txt
	combine.pl free.txt software1.txt website1.txt uptime.txt monitoring1.txt free.txt
	combine.pl free.txt software1.txt crossbrowser.txt testing1.txt preposition.txt article.txt website1.txt free.txt
	combine.pl free.txt software1.txt task.txt automation1.txt preposition.txt article.txt website1.txt free.txt
	combine.pl free.txt software1.txt monitoring1.txt preposition.txt article.txt website1.txt free.txt
} | grep -vP 'web.+web' | grep -vP 'url.+web' | grep -vP 'web.+url' | grep -vP 'free.+free' | grep -vP 'ware.+ware' \
| fix_keywords.pl -p | sort -u | txt2csv.pl > out/`basename $0 .sh`.csv
