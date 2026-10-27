#!/bin/bash

for i in anad cayuga seneca champlain fingerlakes ontario erie huron michigan superior greatlakes freshwater; do for j in anad cayuga seneca champlain fingerlakes ontario erie huron michigan superior greatlakes freshwater; do vcftools --gzvcf pmar.norm.reduced.renamed.nam.biallelic.snps.vcf.gz --weir-fst-pop keeplist.$i --weir-fst-pop keeplist.$j --fst-window-size 20000 --out fst.20k.pmar.norm.reduced.renamed.nam.biallelics.snps.${i}.${j}; done; done
grep weighted fst.20k.pmar.norm.reduced.renamed.nam.biallelics.snps.*log | cut -d"." -f10- | sed -e 's/\.log.*\://' -e 's/\./\ /' | awk '{if ($3<0) print $1,$2,0; else print $0}'
