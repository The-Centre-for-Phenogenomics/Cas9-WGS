#!/bin/bash

mkdir intermediate_files
cat 78samples_List.txt | while read sample; do
  echo $sample 
  zgrep "$sample" /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/Crispr3_Ensemble_Scripts_and_Output_Files/all78samples_ensemble_2padd.snps.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5.out.vcf.gz > intermediate_files/${sample}_snp_Feb2022.txt
  zgrep "$sample" /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/Crispr3_Ensemble_Scripts_and_Output_Files/all78samples_ensemble_2padd.indels.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5.out.vcf.gz > intermediate_files/${sample}_indel_Feb2022.txt
done

files=intermediate_files/*_Feb2022.txt

#now extract only information with sample names
for file in ${files[@]}; do 
  echo $file
  grep -o -P "CALLERS=.*?;" $file > ${file%.txt}_callers.txt
done

cat 78samples_List.txt | while read sample; do
   echo $sample
   cat intermediate_files/${sample}_snp_Feb2022_callers.txt intermediate_files/${sample}_indel_Feb2022_callers.txt > intermediate_files/${sample}_concat_Feb2022_callers.txt
done

rm -r intermediate_files/*_snp_Feb2022.txt
rm -r intermediate_files/*_indel_Feb2022.txt
rm -r intermediate_files/*_snp_Feb2022_callers.txt
rm -r intermediate_files/*_indel_Feb2022_callers.txt
