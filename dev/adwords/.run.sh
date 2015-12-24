#!/bin/sh

rm -Rf out
mkdir out
for s in *.sh; do
	echo $s
	./$s
done
chmod og-w out/*
