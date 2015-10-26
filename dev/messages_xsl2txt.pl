#!/usr/bin/perl

use strict;
use warnings;

die "USAGE: $0 <messages.xsl> <messages.txt>" unless @ARGV;

my $xsl = shift;
my $X;
open($X, '<', $xsl) or die "Can't open file $xsl";

my $txt = shift;
my $T;
open($T, '>', $txt) or die "Can't open file $txt";

my $msg;
my $text;
while (<$X>) {
	if (m~<xsl:template\s+match\s*=\s*"\s*message\s*\[\s*\@value\s*=\s*'(\S+)'\s*\]\s*"\s+mode\s*=\s*"message"\s*>~) {
		$msg = $1;
		$text = "";
		next;
	}
	if ($msg && m~</xsl:template>~) {
		print $T "\n$msg\n$text";
		$msg = undef;
		next;
	}
	if ($msg) {
		$text .= $_;
	}
}
print $T "\n";
