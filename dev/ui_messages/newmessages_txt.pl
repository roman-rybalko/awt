#!/usr/bin/perl

use strict;
use warnings;

my $line1 = '';
my $line2 = '';
while(<>) {
	print $line2 if /^\s*$/ && $line2 =~ /\S/ && $line1 =~ /^\s*$/;
	$line1 = $line2;
	$line2 = $_;
}
