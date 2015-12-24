#!/bin/sh

. ./.config.sh
{
	combine.pl advanced.txt website1.txt crossbrowser.txt testing1.txt software.txt free.txt
} \
| filter \
| sort -u \
| csv
