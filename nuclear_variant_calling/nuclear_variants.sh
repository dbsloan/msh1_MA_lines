#!/usr/bin/bash

#Using GATK (4.6.1.0) to call nuclear variants


#generate col-cc.fasta from the following nuclear GenBank accessions and refs_cp28673mod.fas  organelle genomes

#CP116280.1
#CP116281.2
#CP116282.1
#CP116283.2
#CP116284.1

bwa index -a bwtsw col-cc.fasta
gatk CreateSequenceDictionary -R col-cc.fasta
samtools faidx col-cc.fasta


for file in *1.trim.fq

do

gatk FastqToSam FASTQ=$file FASTQ2=${file%1.trim.fq}2.trim.fq OUTPUT=${file%_1.trim.fq}.fastqtosam.bam READ_GROUP_NAME=RG1 SAMPLE_NAME=${file%_1.trim.fq} LIBRARY_NAME=${file%_1.trim.fq} PLATFORM=ILLUMINA

gatk SamToFastq I=${file%_1.trim.fq}.fastqtosam.bam FASTQ=${file%_1.trim.fq}.samtofastq.fq INTERLEAVE=true NON_PF=true

bwa mem -M -t 24 -p col-cc.fasta ${file%_1.trim.fq}.samtofastq.fq > ${file%_1.trim.fq}.bwamem.sam 

gatk MergeBamAlignment R=col-cc.fasta UNMAPPED_BAM=${file%_1.trim.fq}.fastqtosam.bam ALIGNED_BAM=${file%_1.trim.fq}.bwamem.sam O=${file%_1.trim.fq}.merged.bam CREATE_INDEX=true ADD_MATE_CIGAR=true CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS

gatk MarkDuplicates I=${file%_1.trim.fq}.merged.bam O=${file%_1.trim.fq}.markDup.bam METRICS_FILE=${file%_1.trim.fq}.markDup_metrics.txt OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 CREATE_INDEX=true; 

gatk HaplotypeCaller -R col-cc.fasta -I ${file%_1.trim.fq}.markDup.bam -O ${file%_1.trim.fq}.raw_variants.g.vcf -ERC GVCF

done


for file in *g.vcf; do gatk GenotypeGVCFs -R /home/dbsloan/20241127_msh1_ma_line_gatk/col-cc.fasta -V $file -O ${file%raw_variants.g.vcf}variant_calls.vcf; done


#this script only reports variants that are homozygous in a single individual and not detected in any other individual (eitehr het or homozygous). It also applies a minimum read depth filter. 

perl vcf_summary2.pl 20 *variant_calls.vcf > call_summary.Min20.UniqueHomos.txt

perl check_adjacent_variants.pl call_summary.Min20.UniqueHomos.txt call_summary.ZygosityMatrix.txt > call_summary.Min20.UniqueHomos.adjacent.txt 


#filtering the above...

#Removed all indels.

#Remove: 3 clustered variants in M3_8_F8 CP116281.2_chr2 pos 5135044-5135078
#Remove: 2 clustered variants in M3_6_F8 CP116281.2_chr2 pos 10880271-10880272
#Remove: 5 clustered variants in M2_8_F8 CP116282.1_chr3 pos 9552138-9552824
#Remove: 2 clustered variants in W2_3_F8 CP116283.2_chr4 pos 11114293-11114326
#Remove: 2 clustered variants in M2_6_F8 CP116284.1_chr5 pos 13114688-13114717
#Remove: 1 clustered variant  in M2_7_F8 CP116282.1_chr3	pos 2991582  (other neighboring variants were uncalled)
#Remove: 1 clustered variant  in M2_6_F8 CP116284.1_chr5 pos 14056827 (other neighboring variants were uncalled)


#Above filtering yielded: nuclear_SNVs.20241204.txt

perl extract_snp_context.pl nuclear_SNVs.txt col-cc.fasta 20 > nuclear_SNVs.context.txt 

#Also reported as DatasetS3.nuclear.xlsx
