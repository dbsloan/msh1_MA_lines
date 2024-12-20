#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE perl $0 deletion_file freq_dip_threshold genome_name reference_fasta max_pos > output\n\n";

my $deletion_file = shift or die ($usage);
my $freq_dip_threshold = shift or die ($usage); #for a deletion to extended the frequency of the next calls needs to be at least this proporiton of teh previous deletion frequency
my $genome_name = shift or die ($usage); #script can only process one genome at a time. It will use the genome name given here to filter out any variants from other genomes.
my $fasta_file = shift or die ($usage); 
my $max_pos = shift or die ($usage); #excludes positions greater than this value (handy for only counting one copy of IR)

my %fasta=fasta2hash($fasta_file);
my $seq = $fasta{$genome_name};
my @file_lines = file_to_array($deletion_file);

my %files_list;

foreach (@file_lines){
	my @sl = split (/\t/, $_);
	$sl[1] eq $genome_name or next;
	$sl[2] > $max_pos and next;
	$files_list{$sl[0]} = 1;
}

print "Library\tGenome\tStartPos\tEndPos\tDeletion\tContext\n";

foreach (sort keys %files_list){
	
	my $current_deletion_start = 0;
	my $current_deletion_pos = 0;
	my $current_deletion_freq = 0;
	my $active_del = 0;
	
	foreach my $line (@file_lines){
		chomp $line;
		my @sl = split (/\t/, $line);
		$sl[0] eq $_ or next;
		$sl[1] eq $genome_name or next;
		$sl[2] > $max_pos and next;
		
		if ($active_del){
		
			if ($sl[2] - $current_deletion_pos == 1){
				if ($sl[4] / $current_deletion_freq > $freq_dip_threshold){
					$current_deletion_pos = $sl[2];
					$current_deletion_freq = $sl[4];					
				}else{
					$active_del = 0;
					my $del = substr($seq, $current_deletion_start - 1, $current_deletion_pos - $current_deletion_start + 1);
					my $context = substr($seq, $current_deletion_start - 21, 41);
					print "$_\t$genome_name\t$current_deletion_start\t$current_deletion_pos\t$del\t$context\n";
					$current_deletion_start = 0;
					$current_deletion_pos = 0;
					$current_deletion_freq = 0;
				}
			}else{
				my $del = substr($seq, $current_deletion_start - 1, $current_deletion_pos - $current_deletion_start + 1);
				my $context = substr($seq, $current_deletion_start - 21, 41);
				print "$_\t$genome_name\t$current_deletion_start\t$current_deletion_pos\t$del\t$context\n";
				$current_deletion_start = $sl[2];
				$current_deletion_pos = $sl[2];
				$current_deletion_freq = $sl[4];
			}
		}else{
			$current_deletion_start = $sl[2];
			$current_deletion_pos = $sl[2];
			$current_deletion_freq = $sl[4];
			$active_del = 1;
		}
	}
	if ($active_del){
		my $del = substr($seq, $current_deletion_start - 1, $current_deletion_pos - $current_deletion_start + 1);
		my $context = substr($seq, $current_deletion_start - 21, 41);
		print "$_\t$genome_name\t$current_deletion_start\t$current_deletion_pos\t$del\t$context\n";	
	}
}