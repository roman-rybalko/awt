#!/bin/sh

. ./.config.sh
{
	combine.pl website1.txt testing1.txt
} \
| filter \
| fix_keywords.pl | sort -u \
| txt
