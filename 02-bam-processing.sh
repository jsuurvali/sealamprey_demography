#!/bin/bash

SAMPLE=$1


### use bwa mem to map data to the sea lamprey reference genome kPetMar1.pri

bwa mem -t 8 GCF_010993605.1_kPetMar1.pri_genomic.fna ${SAMPLE}_trim_R1.fastq.gz ${SAMPLE}_trim_R2.fastq.gz | samtools sort -@8 -o ${SAMPLE}.bam
samtools index ${SAMPLE}.bam



### identify and remove duplicated reads, saving deduplication metrics to a log file

mkdir nodup_metrics

java -Xmx4g -jar picard.jar MarkDuplicates REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT I=${SAMPLE}.bam O=${SAMPLE}.nodup.bam M=nodup_metrics/${SAMPLE}.txt TAGGING_POLICY=All
samtools index ${SAMPLE}.nodup.bam



### add read group information to each sample (using sample id itself here), required for variant calling with Platypus to work and not throw errors

java -Xmx4g -jar picard.jar AddOrReplaceReadGroups INPUT=${SAMPLE}.nodup.bam OUTPUT=${SAMPLE}.nodup.rg.bam RGID=id${SAMPLE} RGLB=lb${SAMPLE} RGPL=illumina RGPU=illumina RGSM=sm${SAMPLE}
samtools index ${SAMPLE}.nodup.rg.bam



### filter the bam files, retaining only reads mapped in a proper pair, with a quality score of at least 20

samtools view -@4 -bh -f3 -F1548 -q20 ${SAMPLE}.nodup.rg.bam > ${SAMPLE}.nodup.rg.q20f3.bam
samtools index ${SAMPLE}.nodup.rg.q20f3.bam
