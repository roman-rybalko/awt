#!/bin/sh

. ./.config.sh
{
	combine.pl website1.txt crawler1.txt software.txt free.txt
	combine.pl browser1.txt automation1.txt software.txt free.txt
} \
| filter \
| sort -u \
| csv
