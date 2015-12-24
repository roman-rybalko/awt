#!/usr/bin/perl

use strict;
use warnings;

die "USAGE: $0 <messages.xml>" unless @ARGV;

my $xsl = shift;
my $X;
open($X, '<', $xsl) or die "Can't open file $xsl";

my $msg;
my $text;
while (<$X>) {
	if (m~<message\s+value\s*=\s*"(\S+)"\s*>~) {
		$msg = $1;
		$text = "";
		next;
	}
	if ($msg && m~</message>~) {
		print "\n$msg\n$text";
		$msg = undef;
		next;
	}
	if ($msg) {
		$text .= $_;
	}
}
print "\n";
