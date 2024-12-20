#!/usr/bin/perl;

use strict;
use warnings;
use sloan;

my $sra_list_file = shift or die ("give file\n");

my @accs = file_to_array($sra_list_file);

foreach (@accs){
	chomp $_;
	system ("fasterq-dump $_");
	system ("gzip $_\*");
}
