# Single-Nucleotide-Polymorphism

## About
This project involves a comprehensive analysis of single nucleotide polymorphisms (SNPs) using whole genome sequencing of multiple wheat accessions. The pipeline is designed to handle multiple accessions and large chromosomes, which may need to be split into smaller sub-chromosomes. I've aimed to include all essential steps for data processing and analysis. It is recommended for use on a high-performance computing cluster (HPC-SLURM) particularly for the initial VCF data generation, though the scripts can be adapted for use on any linux-based environment.

## Software
The workflow utilizes the following software:
1. GATK4 (v4.5)
2. samtools (v1.20)
3. bcftools (v1.20)
4. vcftools (v0.1.16)
5. picard 
6. plink (v1.90)
8. BWA (v0.7.17)
9. mosdepth (v0.3.8)
10. XP-CLR (v1.1.2)
11. R (v4.3.3)
    - tidyverse (v2.0.0)
    - GenomicRanges (v3.20)



