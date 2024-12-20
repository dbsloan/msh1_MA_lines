#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE perl $0 insertion_file > output\n\n";

my $file = shift or die ($usage);

my @file_lines = file_to_array($file);

my $header = shift @file_lines;

chomp $header;
print "$header\tInsertion\tRead_Count\tOther_Insertions\n";

my $line_count = 0;

foreach (@file_lines){
	
	++$line_count;
	print STDERR "Processing line $line_count\n";
	
	chomp $_;
	my @variant_features = split (/\t/, $_);
	
	my $lib = $variant_features[0];
	my $genome = $variant_features[1];
	my $pos = $variant_features[2];
	
	my %insertion_hash;
	
	my $FH = open_file ("$lib\.sam");
	
	while (my $sam_line = <$FH>){
		$sam_line =~ /^\@/ and next;
		my @sl = split (/\t/, $sam_line);
		$sl[5] =~ /I/ or next;
		$sl[2] eq $genome or next;
		$sl[3] < $pos or next;
		
		my $map_pos = $sl[3];
		my $cigar = $sl[5];
		my $read_pos = 1;
		
		while ($cigar){
			
			if ($cigar =~ /^(\d+[IDM])/){
				my $segment = $1;
				my $length = substr($segment, 0, -1);
				my $type = substr($segment, -1);
				$cigar = substr($cigar, length($segment));
				
				if ($map_pos == $pos + 1){
					if ($type eq 'I'){
						++$insertion_hash{substr($sl[9], $read_pos - 1, $length)};
					}
					last;
				}
				
				if ($type eq 'M'){
					$map_pos += $length;
					$read_pos += $length;
				}elsif ($type eq 'D'){
					$map_pos += $length;	
				}elsif ($type eq 'I'){
					$read_pos += $length;	
				}else{
					die ("\nERROR: unrecognized cigar element: $type\n\n");				
				}
			}elsif($cigar =~ /^\d+$/){
				last;
			}else{
				die ("\nERROR: cannot parse cigar string: $cigar\n\n");
			}
		
		}
		
	}
	
	%insertion_hash or die ("\nERROR: no insertions detected for the following line:\n$_\n\n");
	my @sorted_keys = sort { $insertion_hash{$b} <=> $insertion_hash{$a} } keys %insertion_hash;
	print "$_\t$sorted_keys[0]\t$insertion_hash{$sorted_keys[0]}";
	shift @sorted_keys;
	@sorted_keys and print "\t$sorted_keys[0]\($insertion_hash{$sorted_keys[0]})";
	shift @sorted_keys;
	foreach my $key (@sorted_keys){
		print "; $key\($insertion_hash{$key})";
	}
	print "\n";
}
