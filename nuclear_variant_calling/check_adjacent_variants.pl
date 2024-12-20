#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 filtered_calls_file full_matrix_file > output\n\n";

my $call_file = shift or die ($usage);
my $matrix_file = shift or die ($usage);

my @call_lines = file_to_array($call_file);

my $first_line = shift (@call_lines);

chomp $first_line;
print "$first_line\tBeforeGenotype\tBeforeCount\tAfterGenotype\tAfterCount\n";

my %call_HoA;
foreach (@call_lines){
	chomp $_;
	my @sl = split (/\t/, $_);
	$call_HoA{"$sl[1]\_$sl[2]\_$sl[3]\_$sl[4]"}[0] = $sl[0];
}

my %library_index_hash;

my @matrix_lines = file_to_array ($matrix_file);

my $first_matrix_line = shift @matrix_lines;
chomp $first_matrix_line;
my @sfml = split (/\t/, $first_matrix_line);

for (my $i = 4; $i < scalar(@sfml); ++$i){
	$library_index_hash{$sfml[$i]} = $i;
}

for (my $i = 0; $i < scalar(@matrix_lines); ++$i){
	my $line = $matrix_lines[$i];
	chomp $line;
	my @sl = split (/\t/, $line);
	if (exists ($call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[0])){
		my $lib = $call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[0];
		$sl[$library_index_hash{$lib}] == 2 or die ("\nERROR: $lib does not have a value of 2 for this line: \n$line\n\n");
		my $previous_line = $matrix_lines[$i-1];
		my $next_line = $matrix_lines[$i+1];
		chomp $previous_line;
		chomp $next_line;
		my @spl = split (/\t/, $previous_line);
		my @snl = split (/\t/, $next_line);
		my $previousGeno = $spl[$library_index_hash{$lib}];
		my $nextGeno = $snl[$library_index_hash{$lib}];
		my $previousCount = 0;
		my $nextCount = 0;
		
		for (my $j=4; $j < scalar (@spl); ++$j){
			$spl[$j] and ++$previousCount;
			$snl[$j] and ++$nextCount;
		}
		
		$call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[1] = $previousGeno;
		$call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[2] = $previousCount;
		$call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[3] = $nextGeno;
		$call_HoA{"$sl[0]\_$sl[1]\_$sl[2]\_$sl[3]"}[4] = $nextCount;
	}
}

foreach (@call_lines){
	chomp $_;
	print "$_";
	my @sl = split (/\t/, $_);
	print "\t", $call_HoA{"$sl[1]\_$sl[2]\_$sl[3]\_$sl[4]"}[1];
	print "\t", $call_HoA{"$sl[1]\_$sl[2]\_$sl[3]\_$sl[4]"}[2];
	print "\t", $call_HoA{"$sl[1]\_$sl[2]\_$sl[3]\_$sl[4]"}[3];
	print "\t", $call_HoA{"$sl[1]\_$sl[2]\_$sl[3]\_$sl[4]"}[4], "\n";	
}