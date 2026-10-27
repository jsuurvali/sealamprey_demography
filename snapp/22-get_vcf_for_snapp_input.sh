#!/bin/bash

# extract samples of interest

bcftools view -S samples.txt /mnt/e/Dropbox/sealamprey/432/pmar.norm.reduced.renamed.vcf.gz -Oz -o tmp0.vcf.gz
tabix -p vcf tmp0.vcf.gz


# remove unused alleles and non-variants

java -jar ~/bin/gatk-4.6.2.0/gatk-package-4.6.2.0-local.jar SelectVariants -V tmp0.vcf.gz --exclude-non-variants --remove-unused-alternates -O tmp1.vcf.gz


# filter with bcftools: keep only biallelic SNPs, with no missing data and minor allele count more than 2 (maf > 0.025 with 50 individuals)

bcftools view -m2 -M2 -v snps -q 0.025:minor -e 'F_MISSING > 0' tmp1.vcf.gz -Oz -o tmp2.vcf.gz
tabix -p vcf tmp2.vcf.gz

# calculate hwe for main populations / lakes of interest

for i in portugal ctr champlain fingerlakes superior; do
   vcftools --gzvcf tmp2.vcf.gz --keep keeplists/keeplist.${i} --hardy --out ${i}
done

# load all files in the folder ending with hwe, then identify all snps in them that show up in 3 or more files (populations), write into a bed file

awk '$6 < 0.05 {print $1"\t"$2-1"\t"$2}' *.hwe | sort -u | bedtools sort > hwefilter.badsnps.bed


# use the bed files to filter the original vcf

bcftools view -T ^hwefilter.badsnps.bed tmp2.vcf.gz -Oz -o hwe_filtered.vcf.gz

# remove temporary vcf files
rm tmp*
