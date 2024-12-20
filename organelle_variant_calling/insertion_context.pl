#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE perl $0 insertion_file genome_name reference_fasta max_pos > output\n\n";


my $insertion_file = shift or die ($usage);
my $genome_name = shift or die ($usage); #script can only process one genome at a time. It will use the genome name given here to filter out any variants from other genomes.
my $fasta_file = shift or die ($usage); 
my $max_pos = shift or die ($usage); #excludes positions greater than this value (handy for only counting one copy of IR)

my %fasta=fasta2hash($fasta_file);
my $seq = $fasta{$genome_name};

my @file_lines = file_to_array($insertion_file);

print "Library\tGenome\tPos\tFreq\tContext\n";


foreach my $line (@file_lines){
	chomp $line;
	my @sl = split (/\t/, $line);
	$sl[1] eq $genome_name or next;
	$sl[2] > $max_pos and next;

	print "$sl[0]\t$sl[1]\t$sl[2]\t$sl[4]\t", substr($seq, $sl[2] - 20, 40), "\n";
	
}
