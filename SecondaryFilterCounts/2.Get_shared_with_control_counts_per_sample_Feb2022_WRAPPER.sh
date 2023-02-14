#!/bin/bash

files=intermediate_files/*_concat_Feb2022_callers.txt
for file in ${files[@]}; do 
  Rscript 2acs.Get_shared_with_control_counts_per_sample_Feb2022.R $file
done
