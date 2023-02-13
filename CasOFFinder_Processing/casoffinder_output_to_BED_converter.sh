#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------
## By: Sam Khalouei
## Date: 2021-01-09
## Purpose: 
## How to run: 
#-----------------------------------------------------------------------------------------------------------------------------------------------

mkdir -p padded_bed_files

for file in $(ls /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/manuscript_revisions/casoffinder_output/casoffinder-new-reference/*casoffinder.output.txt); do 
	ls $file; 
	python step1acs_casoffinder_output_to_BED_converter.py $file
done
