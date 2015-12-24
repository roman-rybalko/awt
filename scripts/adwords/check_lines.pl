#! /usr/bin/perl

use strict;
use warnings;

die "USAGE: $0 <lines_cnt> <chars_cnt>
" if scalar(@ARGV) < 2;

my $lcnt = shift;
my $ccnt = shift;
my @lines;

while (<>) {
	my $c = length $_;
	die "Line length $c cannot be lenger than allowed $ccnt
" if $c > $ccnt;
	push @lines => $_;
}
my $l = scalar @lines;
die "Lines count $l is greater than allowed $lcnt
" if $l > $lcnt;
print @lines;
