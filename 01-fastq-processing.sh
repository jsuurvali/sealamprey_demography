#!/bin/bash

SAMPLE=$1

# concatenate data for samples ran on multiple lanes (after initial quality control)

cat ${SAMPLE}_L00*_R1_001.fastq.gz > ${SAMPLE}_R1.fastq.gz
cat ${SAMPLE}_L00*_R2_001.fastq.gz > ${SAMPLE}_R2.fastq.gz

# quality-trim, remove adapters, output statistics

fastp \
  -i ${SAMPLE}_R1.fastq.gz \
  -I ${SAMPLE}_R2.fastq.gz \
  -o ${SAMPLE}_trim_R1.fastq.gz \
  -O ${SAMPLE}_trim_R2.fastq.gz \
  -j ${SAMPLE}.fastp.json \
  -h ${SAMPLE}.fastp.html \
  --detect_adapter_for_pe \
  --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
  --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
  --fix_mgi_id \
  --thread 4 \
  -c -g -D -l 70


# additional QC statistics for the trimmed files

fastqc -f fastq ${SAMPLE}_trim_R*.fastq.gz -t 2 -o qc_logs
