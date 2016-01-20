#!/bin/sh

. ./.config.sh
{
	combine.pl advanced.txt website1.txt automation1.txt software.txt
	combine.pl advanced.txt browser1.txt automation1.txt software.txt
} \
| filter \
| sort -u \
| csv
