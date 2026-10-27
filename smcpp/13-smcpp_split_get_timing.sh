#!/bin/sh
# gets the highest value in column 2 (x axis, = time) for a non-ancestral population from the csv output of smcpp
# this corresponds to an estimate of split timing from the other ancestral population

# usage: script.sh input_file


INFILE=$1

grep -v "nadromous" ${INFILE} | cut -d',' -f2 | sort -n | tail -n1
