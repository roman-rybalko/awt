#!/bin/sh

. ./.config.sh
{
	combine.pl advanced.txt website1.txt automation1.txt software.txt free.txt
	combine.pl advanced.txt browser1.txt automation1.txt software.txt free.txt
} \
| filter \
| sort -u \
| csv
