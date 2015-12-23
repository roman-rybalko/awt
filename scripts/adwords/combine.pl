#! /usr/bin/perl

use strict;
use warnings;

die "USAGE: $0 file1 [file2] [file3] ...
" unless @ARGV;

my @groups;

foreach my $f (@ARGV) {
	my $F;
	open $F, "<", $f or die "Can't open file $f";
	my @strings = <$F>;
	chomp @strings;
	push @groups => \@strings;
}

sub process {
	my $prefix = shift;
	my @groups = @_;
	if (!@groups) {
		$prefix =~ s/^\s+//;
		$prefix =~ s/\s+$//;
		$prefix =~ s/\s+/ /g;
		print "$prefix\n";
		return;
	}
	my @strings = @{shift @groups};
	foreach my $string (@strings) {
		process($prefix . ' ' . $string, @groups);
	}
}

process('', @groups);
