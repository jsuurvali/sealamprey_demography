#!/bin/bash
# usage: 15-gone_prepare_input.sh <input vcf> <population name>
# prepares .map and .ped files to be used as inputs for the population genetics software GONE
# requires a list of samples in the population ("keeplist.<population_name>") as an additional input. Those samples must exist in the input vcf

INPUT_VCF=$1
POP=$2

mkdir ${POP} ${POP}/run0 # create a folder for output files
bcftools view -S keeplist.${POP} --regions chr01,chr02,chr03,chr04,chr05,chr06,chr07,chr08,chr09,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chr23,chr24,chr25,chr26,chr27,chr28,chr29,chr30,chr31,chr32,chr33,chr34,chr35,chr36,chr37,chr38,chr39,chr40,chr41,chr42,chr43,chr44,chr45,chr46,chr47,chr48,chr49,chr50 ${INPUT_VCF} \
| bcftools view -m2 -M2 -v snps \
| bcftools view -i 'AC != 0' -Oz -o ${POP}/${POP}.vcf.gz

cd ${POP}/run0
plink --vcf ${POP}.vcf.gz --vcf-half-call missing --chr-set 50 --recode --out ${POP}

# recommended next steps:
# - copy GONE's files and folders (from github) into the same run0 folder, with INPUT_PARAMETERS_FILE and script_GONE.sh in the same folder as the newly made .ped and .map
# - replace the default INPUT_PARAMETERS_FILE with an appropriate/updated one
# - to prepare input for replicate runs of GONE, make copies of the entire run0 folder and its contents - name them as run1, run2, run3, etc. Do it for each population.
# - run GONE ("script_GONE.sh", part of the github package) in each of the population_name/run folders
