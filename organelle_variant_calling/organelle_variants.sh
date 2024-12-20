#!/usr/bin/bash

#run mapping and summary counts
for file in *1.fq.gz; do 

  cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o ${file%1.fq.gz}1.trim.fq -p ${file%1.fq.gz}2.trim.fq $file ${file%1.fq.gz}2.fq.gz > ${file%_1.fq.gz}.cutadapt.log.txt

  bowtie2 --no-unal -p 24 -x refs_cp28673mod.fas -1 ${file%1.fq.gz}1.trim.fq -2 ${file%1.fq.gz}2.trim.fq -S ${file%_1.fq.gz}.sam > ${file%_1.fq.gz}.bowtie2.log.txt 2> ${file%_1.fq.gz}.bowtie2.err.txt

  samtools sort ${file%_1.fq.gz}.sam > ${file%_1.fq.gz}.bam

  samtools index ${file%_1.fq.gz}.bam

  perbase base-depth --max-depth 1000000 --threads 24 ${file%_1.fq.gz}.bam > ${file%_1.fq.gz}.depth.txt

done


#summarize variants

ls *depth.txt | cat > perbase_files.txt

perl perbase_variant_summary2.pl perbase_files.txt refs_cp28673mod.fas 0.2 50 > perbase_summary.txt

perl perbase_variant_filter2.pl perbase_summary.txt 0.2 3 22 20 perbase_summary



#Plastid SNV filtering and summary
#manual filtering of output to generate plastid_SNVs.txt

perl extract_snp_context.pl plastid_SNVs.txt refs_cp28673mod.fas 20 > plastid_SNVs.context.txt


#Plastid deletions filtering and summary

grep DEL perbase_summary.filt_list.txt > perbase_summary.filt_list.dels.txt 

perl deletion_merge.pl perbase_summary.filt_list.dels.txt 0.5 plastid refs_cp28673mod.fas 128214 > plastid_deletions.txt


#Plastid insertions filtering and summary

grep INS perbase_summary.filt_list.txt > perbase_summary.filt_list.insertions.txt 

perl insertion_context.pl perbase_summary.filt_list.insertions.txt plastid refs_cp28673mod.fas 128214 > plastid_insertions.txt 


#manual filtering of plastid_insertions.txt to generate plastid_insertions_inputs.txt

perl extract_insertions.pl plastid_insertions_inputs.txt > plastid_insertions_withTypes.txt



#Mito SNV filtering and summary
#manual extraction of output to generate mito_SNVs.txt


perl extract_snp_context.pl mito_SNVs.txt refs_cp28673mod.fas 20 > mito_SNVs.context.txt


#Mito deletions filtering and summary

perl deletion_merge.pl perbase_summary.filt_list.dels.txt 0.5 mito refs_cp28673mod.fas 1000000 > mito_deletions.txt


#Mito insertions filtering and summary

perl insertion_context.pl perbase_summary3.filt_list.insertions.txt mito refs_cp28673mod.fas 1000000 > mito_insertions.txt 


#manual filtering of mito_insertions.txt to generate mito_insertions_inputs.txt

perl extract_insertions.pl mito_insertions_inputs.txt > mito_insertions_withTypes.txt


#manual filtering steps based on blast searches for recombinant and numt-related sequences to generate mito_variants_for_function.txt and plastid_variants_for_function.txt

#add functional annotation

perl variant_function_summary.pl mito_variants_for_function.txt NC_037304.coordmap.txt > mito_variants_for_function.expanded.txt 

perl variant_function_summary.pl plastid_variants_for_function.txt NC_000932.mod28673.coordmap.txt > plastid_variants_for_function.expanded.txt 


#stored as final calls
#SNVs: final_callsets/DatasetS1.SNVs.xlsx
#SNVs: final_callsets/DatasetS1.indels.xlsx
 


