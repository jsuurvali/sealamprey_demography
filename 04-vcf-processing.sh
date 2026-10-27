#!/bin/bash

# concatenate all platypus output for the different parts of the genome
vcf-concat *vcf > ../pmar.vcf

awk 'NR < 49 || $7 == "PASS"' pmar.vcf > pmar.pass.vcf # extract only the header and variants flagged with PASS for passing all default filters of platypus.

# to sort the concatenated vcf file, it needs to be bgzipped and indexed first
bgzip -c pmar.pass.vcf > pmar.pass.vcf.gz
tabix -p vcf pmar.pass.vcf.gz
bcftools sort -Oz -o pmar.sorted.vcf.gz pmar.pass.vcf.gz
bcftools reheader -h new_header.txt pmar.sorted.vcf.gz -o platypus_concat.pass.renamed.vcf.gz # replace old sample names with more sensible ones for downstream analyses
tabix -p platypus_concat.pass.renamed.vcf.gz

# extract samples provided in samples.txt from the full set of what was sequenced together
# this keeps only individuals confirmed to be sea lamprey

bcftools view -S samples.pmar.txt platypus_concat.pass.renamed.vcf.gz -Oz -o tmp.vcf.gz
tabix -p vcf tmp.vcf.gz

# exclude all variants that were only found in the removed, non-sealamprey individuals
gatk SelectVariants -V tmp.vcf.gz --exclude-non-variants --remove-unused-alternates -O pmar.vcf.gz

# remove the INFO and FORMAT fields that were filled by Platypus - the variants are already filtered and it reduces file size massively
bcftools annotate -x INFO,^FORMAT/GT pmar.vcf.gz -Oz -o pmar.reduced.vcf.gz

# convert any MNV entries in the vcf into individual variants; normalize the vcf
bcftools norm -m-any -Oz -o step1.vcf.gz pmar.reduced.vcf.gz
bcftools norm -a --atom-overlaps . -Oz -o step2.vcf.gz step1.vcf.gz
bcftools norm -f GCF_010993605.1_kPetMar1.pri_genomic.fna -Oz -o step3.vcf.gz step2.vcf.gz
bcftools norm -m+any -Oz -o pmar.norm.reduced.vcf.gz step3.vcf.gz
rm step*

# convert chromosomes IDs in the vcf from NCBI IDs to chromosome numbers (e.g. NC_046069.1 becomes chr01)
bcftools annotate --rename-chrs chr_renaming.tsv -Oz -o pmar.norm.reduced.renamed.vcf.gz pmar.norm.reduced.vcf.gz
tabix -p vcf pmar.norm.reduced.renamed.vcf.gz

# the final part extracts the subset of data containing North-American individuals (nam)
# it also removes any variants that within this subset are non-polymorphic or have only missing data
bcftools view -S keeplists/keeplist.nam pmar.norm.reduced.renamed.vcf.gz | bcftools_view -i 'AC != AN && F_MISSING != 1 && AC != 0 && AN != 0' -Oz -o pmar.norm.reduced.renamed.nam.vcf.gz
