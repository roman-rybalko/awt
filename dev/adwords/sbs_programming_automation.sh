#!/bin/sh

. ./.config.sh
{
	combine.pl proglangs1.txt advanced.txt website1.txt automation1.txt
	combine.pl proglangs1.txt advanced.txt browser1.txt automation1.txt
} \
| filter \
| sort -u \
| csv
