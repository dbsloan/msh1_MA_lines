#!/usr/bin/bash

#Analyzing organellar variants from previously published Arabidopsis MA sequencing.

#the following script downloads all SRA accessions from Weng et al. 2019 (https://academic.oup.com/genetics/article/211/2/703/5931174), using fasterq-dump from SRA toolkit and then gzip the resulting files

perl SRA_download.pl SRA_accession_list.txt 

#perform read trimming, mapping and depth claculations

perl run_weng_libraries.pl fastq_pairings.txt


for file in *depth.txt; do echo $file >> perbase_file_list.txt; done

perl perbase_variant_summary2.pl perbase_file_list.txt refs_cp28673mod.fas 0.2 50 > perbase_file_summary.txt

perl perbase_variant_filter2.pl perbase_file_summary.txt 0.2 3 1 106 perbase_file_summary
