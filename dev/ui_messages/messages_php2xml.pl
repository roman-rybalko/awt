#!/usr/bin/perl
use strict;
use warnings;
my %msgs;
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<messages>
";
while (<>) {
	if (m~<message\s+type\s*=\s*"\w+"\s+value\s*=\s*"(\S+)"~ && !$msgs{$1}) {
		$msgs{$1} = 1;
		print "
<message value=\"$1\">
	XXX$1ZZZ
</message>
";
	}
}
print "
</messages>
";
