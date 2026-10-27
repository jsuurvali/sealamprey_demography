#!/bin/bash

# filter the vcf by keeping only sites with biallelic snps with no missing data
bcftools view -m2 -M2 -v snps -i 'F_MISSING == 0 && AN != 0 && AC != 0 && AN != AC' pmar.norm.reduced.renamed.nam.vcf.gz -Oz -o pmar.norm.reduced.renamed.nam.nomissing.vcf.gz

# output a list of sample names for downstream use
bcftools query -l pmar.norm.reduced.renamed.nam.nomissing.vcf.gz > pmar.norm.reduced.renamed.nam.nomissing.samples.tsv

# exclude sites with globally significant deviations from Hardy-Weinberg equilibrium
vcftools --gzvcf pmar.norm.reduced.renamed.nam.nomissing.vcf.gz --hwe 0.05 --out a --recode

# filter for biallelic SNPs with no missing data and minor allele frequency of at least 0.05. Prune sites in strong LD with nearby sites
bcftools view -q 0.05:minor -m2 -M2 -v snps -i 'F_MISSING == 0' a.recode.vcf | bcftools +prune -m 0.2 -Oz -o pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.vcf.gz

# convert to .geno format to estimate population structure
bcftools query -f '[\t%GT]\n' pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.vcf.gz | sed -re 's/\t//' -e 's/0\/0/0/g' -e 's/0\/1/1/g' -e 's/1\/0/1/g' -e 's/1\/1/2/g' | tr -d '\t' > pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.geno


