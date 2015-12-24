#!/bin/sh

. ./.config.sh
{
	combine.pl website1.txt monitoring1.txt
} \
| filter \
| fix_keywords.pl | sort -u \
| txt
