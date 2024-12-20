#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 snp_file ref_fasta context_length> output\n\n";

my $snp_file = shift or die ($usage);
my $fasta_file = shift or die ($usage);
my $context_length = shift or die ($usage);

my %fasta = fasta2hash($fasta_file);

my @snp_lines = file_to_array($snp_file);

my $first_line = shift @snp_lines;
chomp $first_line;

print "$first_line\tContext\n";

foreach (@snp_lines){
	
	chomp $_;
	my @sl = split (/\t/, $_);
	
	my $context = substr ($fasta{$sl[1]}, $sl[2] - $context_length - 1, 2*$context_length + 1);
	
	substr ($sl[3], 0, 1) eq substr ($fasta{$sl[1]}, $sl[2] - 1, 1) or die ("\nERROR: nucleotides do not match for:\n$_\n\n");

	print "$_\t$context\n";

}