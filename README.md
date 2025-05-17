# msh1_MA_lines
Scripts and data related to analysis of *Arabidopsis thaliana* msh1 mutant and wild type mutation accumulation lines

### Directories
- [organelle_variant_calling](organelle_variant_calling): Workflow and files for detection of mitochondrial and plastid variants in MA lines from this study
- [nuclear_variant_calling](nuclear_variant_calling): Workflow and files for detection of nuclear SNVs in MA lines from this study
- [Weng_2019_lines](Weng_2019_lines): Workflow and files for detection of mitochondrial and plastid variants in MA lines from [Weng et al. 2019](https://doi.org/10.1534/genetics.118.301721).
- [Sanger_data](Sanger_data): Sanger sequencing ab1 files generated to confirm a sample of variant calls.
- [germination_data](germination_data): Data showing lower rates of germination in msh1 compared to WT lines
- [overdispersion_test](overdispersion_test): R code to perform test for overdispersion of mutations per MA lines relative to a Poisson distribution

### Dependencies
- [sloan.pm Perl module](https://github.com/dbsloan/perl_modules)
- Cutadapt
- Bowtie 2
- Samtools
- BWA
- GATK
- Perbase

### Reference
- Broz AK, Hodous MM, Zou Y, Vail PC, Wu Z, Sloan DB. Submitted. Flipping the switch on some of the slowest mutating genomes: Direct measurements of plant mitochondrial and plastid mutation rates in msh1 mutants. [bioRxiv preprint](https://www.biorxiv.org/content/10.1101/2025.01.08.631957v1)