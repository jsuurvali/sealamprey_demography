#!/bin/bash
# start from a folder that contains GONE analyses, with one subfolder for each population.
# The subfolders should each contain one or more runs of the tool on the same dataset, labeled as "run0", "run1", etc


grep "." */*/Output_Ne* | grep -v averages | grep -v _mean | awk 'BEGIN {FS="[:/\t]" ; OFS = "\t"} {print $1,$2,$4,$5}' > gone_results.tsv

# grep -v here is used to remove the info rows in the headers
# awk is used to extract the name of the population, the number of the run, and the output of GONE: for each data point, Ne and the # of generations before present
# note that GONE by default does perform replicate runs but outputs only their geometric mean, Ne and # of generations of each "run" represents that geometric mean from one batch of replicate runs
