#!/usr/bin/perl
use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 fasta_file > output\n\n";

my $fasta_file = shift or die ($usage);

my %fasta = fasta2hash($fasta_file);

print "Genome\tPosition\tBase\tRepLength\n";

foreach (sort keys %fasta){
	my $seq = uc($fasta{$_});
#	print "$seq\n";
	find_identical_runs($_, $seq);
}



# Function to find substrings of 5 or more consecutive identical bases
sub find_identical_runs {
    my ($genome, $dna_sequence) = @_;
    my $position = 0;

    while ($dna_sequence =~ /(A{5,}|T{5,}|C{5,}|G{5,})/) {
        my $substring = $1;
        my $position2 = index($dna_sequence, $substring) + 1; # Get 1-based index
        $position += $position2;
        print "$genome\t$position\t" . substr ($substring,0,1) . "\t" . length ($substring) . "\n";
        $position += length($substring) - 1; # Update position for the next match
        $position2 += length($substring) - 1;
        $dna_sequence = substr ($dna_sequence, $position2);
        
#        print "\n$substring\t$position\t$position2\n$dna_sequence\n\n";
    }
}
