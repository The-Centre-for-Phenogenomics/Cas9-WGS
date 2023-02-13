#!/bin/bash

#PBS -N CRISPR_variant_counts
#PBS -l walltime=24:00:00,nodes=1:ppn=1
#PBS -joe .
#PBS -d .
#PBS -l vmem=25g,mem=25g

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/*gatk-haplotype-annotated-decomposed_NOrsIdCol_rsSNPINDEL_annotated.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $dir)))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $sample $num_variants >> Feb2022_unfiltered_gatk_numbers.txt
  
done

####QUAL, GQ, AF, ./. 0/.0 filters#######

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_gatk_numbers.txt
  
done

####General repeat filter#####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRep_2padd.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_repeat_numbers.txt
  
done


####Tandem repeat filter####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRep_noTanRep_2padd.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_repeat_tandem_numbers.txt
  
done


####dbSNP filter (SNPS)####


vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRepeat_2padd.snps.vcf.gz

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_dbsnp_snps.txt
  
done

####dbSNP filter (indels)####
vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRepeat_2padd.indels.vcf.gz

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_dbsnp_indels.txt
  
done


###EVA filter (snps)#####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_noEVA_2padd.snps.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_eva_snps.txt
  
done


####EVA filter (indels)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_noEVA_2padd.indels.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_eva_indels.txt
  
done


####AD filter (snps)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.snps.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_AD_snps.txt
  
done


####AD filter (indels)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.indels.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_AD_indels.txt
  
done

####AD filter (concat)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/*/*/final/2*/applied_filters5/*-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $(dirname $dir))))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_AD_concat.txt
  
done


####callable intervals (snps)####
vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/*/applied_filters5_noZ/*ADfilt_noRepeat_nodbsnp150_noEVA_2padd_callableInterval.snps.unique.vcf.gz

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $dir))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_callable_snps.txt
  
done


####callable intervals (indels)####
vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/*/applied_filters5_noZ/*ADfilt_noRepeat_nodbsnp150_noEVA_2padd_callableInterval.indels.unique.vcf.gz

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $dir))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_callable_indels.txt
  
done


####callable intervals (concat)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/*/applied_filters5_noZ/*ADfilt_noRepeat_nodbsnp150_noEVA_2padd_callableInterval.concat.unique.vcf.gz

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $dir))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_callable_concat.txt
  
done


####secondary filtered (snps)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/*/applied_filters5_noZ/*_all78samples_ensemble_2padd.snps.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5_bcftools_isec/0000.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $dir)))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_secondary_snp.txt
  
done

####secondary filtered (indels)####

vcfs=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/*/applied_filters5_noZ/*_all78samples_ensemble_2padd.indels.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5_bcftools_isec/0000.vcf

for vcf in ${vcfs[@]}; do
  dir=$(dirname $vcf)
  sample=$(basename $(dirname $(dirname $dir)))
  num_variants=$(bcftools stats $vcf | grep "number of records:" )
  echo $vcf
  echo $sample $num_variants >> Feb2022_filtered_secondary_indel.txt
  
done

