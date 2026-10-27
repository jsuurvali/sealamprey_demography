#!/bin/bash
# usage: smcpp_prepare_input.sh <chr>
# population and samples names are already defined within this file

CHR=$1

# calculate population-specific frequency spectra for smc++ input

mkdir input input/anadromous input/champlain input/cayuga input/seneca input/ontario input/erie input/huron input/michigan input/superior

for i in CTR_04 NCSM_53260; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/anadromous/${CHR}.anadromous.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20; done
for i in FwSeCC_01 FwSeCC_09; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/seneca/${CHR}.seneca.${i}.txt ${CHR} Seneca:FwSeCC_01,FwSeCC_02,FwSeCC_03,FwSeCC_04,FwSeCC_05,FwSeCC_06,FwSeCC_07,FwSeCC_08,FwSeCC_09; done
for i in FwCaNY_03 FwCaNY_36; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/cayuga/${CHR}.cayuga.${i}.txt ${CHR} Cayuga:FwCaNY_03,FwCaNY_04,FwCaNY_05,FwCaNY_11,FwCaNY_13,FwCaNY_18,FwCaNY_20,FwCaNY_35,FwCaNY_36; done
for i in FwChMB_03 FwChTB_01; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/champlain/${CHR}.champlain.${i}.txt ${CHR} Champlain:FwChMB_03,FwChMB_06,FwChMB_07,FwChMB_12,FwChMB_15,FwChMC_02,FwChPB_01,FwChSB_05,FwChTB_01; done
for i in FwOnBLR_02 FwOnDF_29; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/ontario/${CHR}.ontario.${i}.txt ${CHR} Ontario:FwOnBLR_02,FwOnBLR_18,FwOnDF_05,FwOnDF_08,FwOnDF_09,FwOnDF_18,FwOnDF_22,FwOnDF_28,FwOnDF_29; done
for i in FwErBC_08 FwErGO_09; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/erie/${CHR}.erie.${i}.txt ${CHR} Erie:FwErBC_08,FwErBC_13,FwErBC_14,FwErBC_17,FwErBC_18,FwErBC_19,FwErBC_29,FwErGO_01,FwErGO_09; done
for i in FwHuAG_23 FwHuSM_13; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/huron/${CHR}.huron.${i}.txt ${CHR} Huron:FwHuAG_23,FwHuAG_26,FwHuBL_08,FwHuBL_29,FwHuCH_02,FwHuCH_09,FwHuCH_28,FwHuSM_08,FwHuSM_13; done
for i in FwMiGR_06 FwMiMAN_24; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/michigan/${CHR}.michigan.${i}.txt ${CHR} Michigan:FwMiGR_06,FwMiGR_07,FwMiGR_16,FwMiGR_20,FwMiMAN_07,FwMiMAN_08,FwMiMAN_17,FwMiMAN_22,FwMiMAN_24; done
for i in FwSuBR_27 FwSuTQ_30; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz input/superior/${CHR}.superior.${i}.txt ${CHR} Superior:FwSuBR_27,FwSuRO_10,FwSuRO_27,FwSuTQ_04,FwSuTQ_12,FwSuTQ_15,FwSuTQ_16,FwSuTQ_19,FwSuTQ_30; done




# calculate joint frequency spectra (anadromous + 1 other population) for smc++ input

mkdir joint joint/input joint/input/champlain joint/input/cayuga joint/input/seneca joint/input/ontario joint/input/erie joint/input/huron joint/input/michigan joint/input/superior

for i in CTR_04 NCSM_53260 FwSeCC_01 FwSeCC_09; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/seneca/${CHR}.seneca.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Seneca:FwSeCC_01,FwSeCC_02,FwSeCC_03,FwSeCC_04,FwSeCC_05,FwSeCC_06,FwSeCC_07,FwSeCC_08,FwSeCC_09; done
for i in CTR_04 NCSM_53260 FwCaNY_03 FwCaNY_36; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/cayuga/${CHR}.cayuga.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Cayuga:FwCaNY_03,FwCaNY_04,FwCaNY_05,FwCaNY_11,FwCaNY_13,FwCaNY_18,FwCaNY_20,FwCaNY_35,FwCaNY_36; done
for i in CTR_04 NCSM_53260 FwChMB_03 FwChTB_01; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/champlain/${CHR}.champlain.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Champlain:FwChMB_03,FwChMB_06,FwChMB_07,FwChMB_12,FwChMB_15,FwChMC_02,FwChPB_01,FwChSB_05,FwChTB_01; done
for i in CTR_04 NCSM_53260 FwOnBLR_02 FwOnDF_29; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/ontario/${CHR}.ontario.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Ontario:FwOnBLR_02,FwOnBLR_18,FwOnDF_05,FwOnDF_08,FwOnDF_09,FwOnDF_18,FwOnDF_22,FwOnDF_28,FwOnDF_29; done
for i in CTR_04 NCSM_53260 FwErBC_08 FwErGO_09; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/erie/${CHR}.erie.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Erie:FwErBC_08,FwErBC_13,FwErBC_14,FwErBC_17,FwErBC_18,FwErBC_19,FwErBC_29,FwErGO_01,FwErGO_09; done
for i in CTR_04 NCSM_53260 FwHuAG_23 FwHuSM_13; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/huron/${CHR}.huron.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Huron:FwHuAG_23,FwHuAG_26,FwHuBL_08,FwHuBL_29,FwHuCH_02,FwHuCH_09,FwHuCH_28,FwHuSM_08,FwHuSM_13; done
for i in CTR_04 NCSM_53260 FwMiGR_06 FwMiMAN_24; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/michigan/${CHR}.michigan.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Michigan:FwMiGR_06,FwMiGR_07,FwMiGR_16,FwMiGR_20,FwMiMAN_07,FwMiMAN_08,FwMiMAN_17,FwMiMAN_22,FwMiMAN_24; done
for i in CTR_04 NCSM_53260 FwSuBR_27 FwSuTQ_30; do smc++ vcf2smc --mask 10k_noSNPs_ALL_mask.bed.gz -d ${i} ${i} ../pmar.norm.reduced.renamed.vcf.gz joint/input/superior/${CHR}.superior.${i}.txt ${CHR} Anadromous:CTR_04,DR2021_001,DR2021_002,NCSM_46040,NCSM_53260,PR2021_01,RI_07,RI_14,RI_20 Superior:FwSuBR_27,FwSuRO_10,FwSuRO_27,FwSuTQ_04,FwSuTQ_12,FwSuTQ_15,FwSuTQ_16,FwSuTQ_19,FwSuTQ_30; done
