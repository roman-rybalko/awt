#!/bin/sh

PATH=../../scripts/adwords:$PATH
{
	combine.pl website1.txt automation1.txt
} | grep -vP 'web.+web' | grep -vP 'url.+web' | grep -vP 'web.+url' | grep -vP 'free.+free' | grep -vP 'ware.+ware' \
| fix_keywords.pl | sort -u > out/`basename $0 .sh`.txt
