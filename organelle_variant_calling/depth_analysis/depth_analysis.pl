#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl mito_depth_file plastid_depth_file mito_sw_file bowtie_dir num_libs > output_file\n\n";

my $mito_file = shift or die ($usage);
my $plastid_file = shift or die ($usage);
my $mito_sw_file = shift or die ($usage);
my $bowtie_dir = shift or die ($usage);
my $num_libs = shift or die ($usage);

my @mito = file_to_array($mito_file);
my @plastid = file_to_array($plastid_file);

my $FH1 = open_file($mito_sw_file);
my $firt_mito_line = <$FH1>;
chomp $firt_mito_line;
my @sml = split (/\t/, $firt_mito_line);
@sml = @sml[1 .. $num_libs];

my %lib_HoA;


for (my $i=0; $i < $num_libs; ++$i){
	my $FH3 = open_file($mito_file);
	my $FH4 = open_file($plastid_file);
	my $lib = $sml[$i];
	while (my $mito_line = <$FH3>){
		chomp $mito_line;
		my @smcl = split(/\t/, $mito_line);
		$lib_HoA{$lib}[0] += $smcl[$i+2]; 
	}

	while(my $plastid_line = <$FH4>){
		chomp $plastid_line;
		my @spcl = split(/\t/, $plastid_line);
		$lib_HoA{$lib}[1] += $spcl[$i+2]; 
	}
}

foreach (@sml){
	my $FH5 = open_file("$bowtie_dir\/$_.bowtie2\.err\.txt");
	while (my $bt_line = <$FH5>){
		$bt_line =~ /overall/ or next;
		my @sl = split (/\s/, $bt_line);
		$lib_HoA{$_}[2] = $sl[0];
	}
}

print "Library\tmito_coverage\tplastid_coverage\torganelle_mapping\n";

foreach (sort keys %lib_HoA){
	print "$_\t$lib_HoA{$_}[0]\t$lib_HoA{$_}[1]\t$lib_HoA{$_}[2]\n";
}