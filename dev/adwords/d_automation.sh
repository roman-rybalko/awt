#!/bin/sh

. ./.config.sh
{
	combine.pl website1.txt automation1.txt
	combine.pl browser1.txt automation1.txt
	combine.pl website1.txt crawler1.txt
} \
| filter \
| fix_keywords.pl | sort -u \
| txt
