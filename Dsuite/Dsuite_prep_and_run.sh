#!/bin/sh


# from the full input file, extract individuals of interest, and only snps with no missing data
bcftools view -S samples.txt platypus.concat.pass.norm.reduced.chrnames.vcf.gz | bcftools view -m2 -M2 -v snps -e 'F_MISSING > 0 | MAC < 3' -Oz -o tmp.vcf.gz
tabix -p vcf tmp.vcf.gz

# clean the file to retain only biallelic snps. Remove any unused alternate alleles and non-variant sites.
java -jar -Xmx20G gatk-package-4.6.2.0-local.jar SelectVariants \
  -V tmp.vcf.gz \
  -O lamprey.snps.nomiss.vcf.gz \
  --exclude-non-variants \
  --remove-unused-alternates \
  --select-type-to-include SNP \
  --restrict-alleles-to BIALLELIC

rm tmp*



# run dsuite, do an fbranch test, and plot the output

Dsuite Dtrios -t tree.nwk lamprey.snps.nomiss.vcf.gz SETS.txt
Dsuite Fbranch tree.nwk SETS_tree.txt > Fbranch.txt
python3 Dsuite/utils/dtools.py Fbranch.txt tree.nwk
