#!/usr/bin/perl

use strict;
use warnings;

die "USAGE: $0 <messages.txt> <messages.xml>" unless @ARGV;

my $txt = shift;
my $T;
open($T, '<', $txt) or die "Can't open file $txt";

my $xsl = shift;
my $X;
open($X, '<', $xsl) or die "Can't open file $xsl";

my %msgs;
my $msg;
my $text;
my $state;
while (<$T>) {
	if (/^\s*$/) {
		if ($msg) {
			$msgs{$msg} = $text;
			$msg = undef;
		}
		$state = 1;
		next;
	}
	if ($state == 1 && /(\S+)/) {
		$msg = $1;
		$text = '';
		$state = 2;
		next;
	}
	if ($state == 2) {
		$text .= $_;
	}
}

while (<$X>) {
	if (/XXX(\S+)ZZZ/) {
		$text = $msgs{$1};
		print $text if $text;
		warn "$1\n" unless $text;
		next;
	}
	print;
}
