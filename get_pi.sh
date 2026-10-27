#!/bin/bash

# usage: get_pi.sh population_name
# requires 2 input files:

POP=$1

# calculate pi in 20 kb windows, then output the average pi value in each window
vcftools --gzvcf pmar.norm.reduced.renamed.nam.biallelic.snps.vcf.gz \
	 --keep keeplist.${POP} \
	 --window-pi 20000 \
	 --out pi.20k.pmar.norm.reduced.renamed.nam.biallelics.snps.${POP}


# calculate the mean of last column in the pi outfile, ignoring the first line
awk 'BEGIN {sum=0} NR > 1 {sum=sum+$NF} END {print sum/(NR-1)}' pi.20k.pmar.norm.reduced.renamed.nam.biallelics.snps.${POP}.windowed.pi
