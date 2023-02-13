#!/bin/bash

for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/*/final/*/*metasv_filtered*vcf*bedpe
do
   echo $i
   cp $i $i.noheader
   sed -i '/^#/d' $i.noheader
   awk 'OFS="\t" {print $1, $2-1, $3, $4, $5-1, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22}' $i.noheader > $i.noheader.fixed
done
