#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 min_depth vcf_files (space delimited)\n\n";

my $min_depth = shift or die ($usage);
my @files;

while (my $file = shift @ARGV){
	push (@files, $file);
}

@files or die ($usage);

my %var_hash; #keys chrom \ pos \ var --> value: count of files with variant
my %var_hash2; #keys chrom \ pos \ var --> value: file

foreach (@files){

	my @file_lines = file_to_array($_);
	
	foreach my $line (@file_lines){
		$line =~ /^\#/ and next;
		my @sl = split (/\t/, $line);
	
		++$var_hash{"$sl[0]\t$sl[1]\t$sl[3]\_$sl[4]"};
		if ($sl[7] =~ /^AC\=2/){
			if ($sl[7] =~ /DP\=(\d+)\;/){
				$1 >= $min_depth or next;
				$var_hash2{"$sl[0]\t$sl[1]\t$sl[3]\_$sl[4]"} = $_;
			}else{
				die("\nERROR: could not parse depth from the following line in $_\n$line\n\n");		
			}
		}
	}
}

print "Sample\tChrom\tPosition\tRef\tAlt\n";

foreach (sort keys %var_hash){
	$var_hash{$_} > 1 and next;
	exists ($var_hash2{$_}) or next;
	my @sf = split (/\./, $var_hash2{$_});
	print "$sf[0]\t";
	my @sk = split (/\t/, $_);
	print "$sk[0]\t$sk[1]\t";
	my @sv = split (/\_/, $sk[2]);
	print "$sv[0]\t$sv[1]\n";	
}