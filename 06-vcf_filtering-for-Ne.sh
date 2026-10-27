#!/bin/sh

POP=$1

bcftools view -S keeplist.${POP} -m2 -M2 -v snps -q 0.05:minor -i 'F_MISSING == 0' pmar.norm.reduced.renamed.nam.vcf.gz -Oz -o pmar.norm.reduced.biallelic.maf005.${POP}.vcf.gz
tabix -p vcf pmar.norm.reduced.biallelic.maf005.${POP}.vcf.gz
bcftools view -h pmar.norm.reduced.biallelic.maf005.${POP}.vcf.gz > ${POP}.header

mkdir Ne
for i in {1..20}; do
        bcftools view -H pmar.norm.reduced.biallelic.maf005.${POP}.vcf.gz | shuf -n 10000 | cat ${POP}.header - | bcftools view -Oz > Ne/${POP}.10k.${i}.vcf.gz
done
