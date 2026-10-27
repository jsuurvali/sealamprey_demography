#!/bin/bash

# Platypus was run separately on individual larger chromosomes, or on sets of multiple smaller contigs
# Lists of which ones to call variants on during a particular run were provided in separate files as additional "regions" input

REGIONS=$1
OUT_PREFIX=$2
BAMS=$(ls *.nodup.rg.q20f3.bam | paste -sd,)

Platypus.py callVariants \
  --nCPU=18 \
  --regions=${REGIONS} \
  --maxReads=10000000 \
  --bamFiles=${BAMS} \
  --refFile=GCF_010993605.1_kPetMar1.pri_genomic.fna \
  --output=${OUT_PREFIX}.vcf \
  --logFileName=${OUT_PREFIX}.log
