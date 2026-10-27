#!/bin/bash

# create output folders
mkdir output joint joint/output


# estimate demographic history in each population on different chromosomes, given a pre-defined recombination rate and mutation rate
for i in anadromous cayuga champlain erie michigan huron seneca superior ontario; do
        mkdir output/${i}
        for j in {20..40}; do
                mkdir output/${i}/${j}
                smc++ estimate -o output/${i}/${j}/ -r 6.39e-08 2e-08 input/${i}/chr${j}.*txt
        done
done


# jointly estimate the history of anadromous sea lamprey and lamprey from one lake, again separately for different chromosomes
for i in champlain cayuga seneca ontario erie huron michigan superior; do
        mkdir joint/output/${i}
        for j in {20..40}; do
                mkdir joint/output/${i}/${j}
                smc++ split -o joint/output/${i}/${j} output/anadromous/${j}/model.final.json output/${i}/${j}/model.final.json joint/input/${i}/chr${j}.${i}.*.txt
        done
done


# plot the joint history estimates
cd joint/output
for j in cayuga champlain erie huron michigan ontario seneca superior; do
        cd $j
        for i in {20..40}; do
                cd $i
                smc++ plot ${j}${i}.plot.pdf model.final.json -c -x 1 100000 -y 1 100000
                cd ..
        done
        cd ..
done
