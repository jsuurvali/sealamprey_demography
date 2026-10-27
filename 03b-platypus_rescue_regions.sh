#!/bin/bash

# Platypus initially did not call variants on some smaller intervals and warned about needing higher maxReads there.
# Those intervals were rescued by calling variants there as recommended, with a higher value for the maxReads parameter.
# the bufferSize parameter was also adjusted to account for the shorter length of the intervals (the default is 1 Mb)

REGIONS_HICOV=$1
OUT_PREFIX=$2
BAMS=$(ls *.nodup.rg.q20f3.bam | paste -sd,)

Platypus.py callVariants \
  --nCPU=1 \
  --regions=${REGIONS_HICOV} \
  --maxReads=100000000 \
  --bufferSize=50000 \
  --bamFiles=${BAMS} \
  --refFile=GCF_010993605.1_kPetMar1.pri_genomic.fna \
  --output=${OUT_PREFIX}.vcf \
  --logFileName=${OUT_PREFIX}.log
