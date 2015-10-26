#!/usr/bin/perl
use strict;
use warnings;
my %msgs;
while (<>) {
	if (m~<message\s+type\s*=\s*"\w+"\s+value\s*=\s*"(\S+)"\s*/>~ && !$msgs{$1}) {
		$msgs{$1} = 1;
		print "
<xsl:template match=\"message[\@value='$1']\" mode=\"message\">
	XXX$1ZZZ
</xsl:template>
";
	}
}
