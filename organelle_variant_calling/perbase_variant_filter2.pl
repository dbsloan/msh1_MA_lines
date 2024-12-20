#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 variant_summary_file  min_freq wt_multiplier mut_count wt_count output_base_name\n\n";

my $file = shift or die ($usage);
my $min_freq = shift or die ($usage);
my $multiplier = shift or die ($usage);
my $mut_count = shift or die ($usage); #number of mutant libraries. These are assumed to be listed before wt libs in the file
my $wt_count = shift or die ($usage); #number of wt libraries
my $output = shift or die ($usage); 


my $FH1 = open_output("$output\.filt_matrix.txt");
my $FH2 = open_output("$output\.filt_list.txt");


my @file_lines = file_to_array ($file);

my $first_line = shift (@file_lines);

print $FH1 $first_line;
print $FH2 "Library\tGenome\tPosition\tType\tFreq\n";

chomp $first_line;
my @lib_names = split(/\t/, $first_line);


foreach (@file_lines){
	chomp $_;
	my @sl = split (/\t/, $_);
	my $sum = 0;
	my $count = 0;
	for (my $i = $mut_count+2; $i < $mut_count + $wt_count + 2; ++$i) {
		unless ($sl[$i] eq 'N/A'){
			$sum += $sl[$i];
			++$count;
		}
	}
	my $wt_mean = $sum / $count;
		
	my $variant_present = 0;
	
	for (my $i = 2; $i < $mut_count + $wt_count + 2; ++$i) {
		unless ($sl[$i] eq 'N/A'){
			if ($sl[$i] >= $min_freq and $sl[$i] >= $multiplier * $wt_mean){
				$variant_present = 1;
				print $FH2 "$lib_names[$i]\t$sl[0]\t$sl[1]\t$sl[$i + $mut_count + $wt_count]\t$sl[$i]\n";
			}
		}
	}
	
	$variant_present and print $FH1 $_, "\n";

}
