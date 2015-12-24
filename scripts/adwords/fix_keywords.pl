#! /usr/bin/perl

use strict;
use warnings;
use Getopt::Std;

my %opts;
getopts('pebh', \%opts);

die "USAGE: $0 [options] file
USAGE: $0 [options] < file
Options:
	-p	phrase match
	-e	exact match
	-b	broad match modifiers
	-h	help
" if $opts{h};

my $phraseMatch = $opts{p};
my $exactMath = $opts{e};
my $broadMatchModifiers = $opts{b};

sub process {
	my $line = shift;
	$line =~ s/^[\s\["']+//;
	$line =~ s/[\s\]"']+$//;
	my @words = split(/\s+/, $line);
	foreach my $word (@words) {
		$word =~ s/^\++//;
		$word = '+' . $word if $word !~ /^\-/ && $broadMatchModifiers;
	}
	return join(' ', @words);
}

while (<>) {
	chomp;
	my $line = process($_);
	$line = '"' . $line . '"' if $phraseMatch;
	$line = '[' . $line . ']' if $exactMath;
	print "$line\n";
}
