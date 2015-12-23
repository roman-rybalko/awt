#! /usr/bin/perl

use strict;
use warnings;

print "\"Keyword report (" . time() . ")\"\n";
print "Keyword state,Keyword\n";
while (<>) {
	chomp;
	s/"/""/g;
	print "enabled,\"$_\"\n";
}
