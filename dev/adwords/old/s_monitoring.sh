#!/bin/sh

. ./.config.sh
{
	combine.pl advanced.txt website1.txt uptime.txt monitoring1.txt software.txt
} \
| filter \
| sort -u \
| csv
