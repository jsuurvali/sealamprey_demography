#!/bin/sh

sampleset=$1

mkdir ${sampleset}
bcftools view -S keeplists/keeplist.${sampleset} hwe_filtered.vcf.gz | bcftools view -m2 -M2 -v snps -e 'F_MISSING > 0 | MAC < 3' | bcftools +prune -N "rand" -n 1 -Oz -o ${sampleset}.vcf.gz
python3 vcf-to-snapp_input.py -i ${sampleset}.vcf.gz -o ${sampleset}.vcf.gz.nex
