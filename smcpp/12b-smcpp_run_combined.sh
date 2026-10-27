#!/bin/bash

# create output folders
mkdir output joint/output


# estimate demographic history in each population, given a pre-defined recombination rate and mutation rate
for i in anadromous cayuga champlain erie michigan huron seneca superior ontario; do
	mkdir output/${i}
	smc++ estimate -o output/${i} -r 6.39e-08 3e-08 input/${i}/*.txt
done


# jointly estimate the history of anadromous sea lamprey and lamprey from one lake

for i in champlain cayuga seneca ontario erie huron michigan superior; do
	mkdir joint/output/${i}
	smc++ split -o joint/output/${i} output/anadromous/model.final.json output/${i}/model.final.json joint/input/${i}/*.txt
done


# plot the joint history estimates

cd joint/output
for i in cayuga champlain erie huron michigan ontario seneca superior; do
	cd $i
	smc++ plot ${i}.plot.pdf model.final.json -c -x 1 100000 -y 1 100000
	cd ..
done
