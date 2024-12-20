#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 library_list_file\n\n";

my $library_list_file = shift or die ($usage);

my @library_list = file_to_array($library_list_file);

foreach (@library_list){
	chomp $_;
	my @sl = split (/\t/, $_);
	system("cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o $sl[1]\_1.trim.fq -p $sl[1]\_2.trim.fq $sl[1]\_1.fastq.gz $sl[1]\_2.fastq.gz > $sl[1]\.cutadapt.log.txt");
	system("cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o $sl[2]\_1.trim.fq -p $sl[2]\_2.trim.fq $sl[2]\_1.fastq.gz $sl[2]\_2.fastq.gz > $sl[2]\.cutadapt.log.txt");

	system("bowtie2 --no-unal -p 24 -x refs_cp28673mod.fas -1 $sl[1]\_1.trim.fq,$sl[2]\_1.trim.fq -2 $sl[1]\_2.trim.fq,$sl[2]\_2.trim.fq -S $sl[0]\.sam > $sl[0]\.bowtie2.log.txt 2> $sl[0]\.bowtie2.err.txt");

	system ("samtools sort $sl[0]\.sam > $sl[0]\.bam");
	system ("samtools index $sl[0]\.bam");

	system ("perbase base-depth --max-depth 1000000 --threads 24 $sl[0]\.bam > $sl[0]\.depth.txt");
	
	unlink ("$sl[0]\.sam");
	unlink ("$sl[1]\_1.trim.fq");
	unlink ("$sl[1]\_2.trim.fq");
	unlink ("$sl[2]\_1.trim.fq");
	unlink ("$sl[2]\_2.trim.fq");
}

