#!/bin/bash

bcftools view -h pmar.norm.reduced.renamed.vcf.gz | grep contig | cut -c14- | sed 's/\,length\=/\t/' | tr -d '>' | awk '{print $1"\t0\t"$2}' | bedtools sort > chrlen.bed
bedtools merge -i pmar.norm.reduced.renamed.vcf.gz -d 10000 | bedtools sort > 10k.bed
bedtools subtract -a chrlen.bed -b 10k.bed | awk '$3-$2 >= 10000 {if($2 < 10000) print $1,"0",$3 ; else print $0}' | join - chrlen.bed | awk 'BEGIN {OFS="\t"} {if ($5-$3 < 10000) print $1,$2,$5; else print $1,$2,$3}' | bedtools sort | bedtools merge > 10k_noSNPs_ALL_mask.bed
rm 10k.bed chrlen.bed
