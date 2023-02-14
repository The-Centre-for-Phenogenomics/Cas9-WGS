#!/bin/bash


files=../*casoffinder.output.txt
for file in ${files[@]}; do 
  Rscript SUPP_get_offtarget_numbers.Feb2022.R $file $1
done

Rscript 2.Combine_and_cleanup_offtargets_per_guide.R 
