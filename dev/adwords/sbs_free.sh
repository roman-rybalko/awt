#!/bin/sh

. ./.config.sh
{
	combine.pl free1.txt advanced.txt website1.txt crossbrowser.txt testing1.txt
	combine.pl free1.txt advanced.txt website1.txt automation1.txt
	combine.pl free1.txt advanced.txt browser1.txt automation1.txt
	combine.pl free1.txt advanced.txt website1.txt uptime.txt monitoring1.txt
} \
| filter \
| sort -u \
| csv
