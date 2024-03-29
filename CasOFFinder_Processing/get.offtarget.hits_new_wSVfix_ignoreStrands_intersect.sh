#!/bin/bash

module load bedtools

mkdir -p casoffinder_8mismatches_intersection_padded_June2022_ignoreStrands

BEDfilesFolder=/hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/manuscript_revisions/casoffinder_output/casoffinder-new-reference/padded_bed_files


#cat sample.gene.id.Dec2019_ADMO8621.txt | while read -r a b 
#cat sample.gene.id.Dec2019.txt | while read -r a b 
#cat sample.gene.id.Jan2021.txt | while read -r a b 
cat sample.gene.id.Feb2021.txt | while read -r a b

do 
    #printf $a"\t"$b"\n"
    ## INDELS
    for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/$a/applied_filters5_noZ/*_all78samples_ensemble_2padd.indels.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5_bcftools_isec/0000.vcf
    do 
        echo $i 
        bedtools intersect -a $i -b $BEDfilesFolder/$b.casoffinder.output.bed -wo > casoffinder_8mismatches_intersection_padded_June2022_ignoreStrands/$a.$b.vcf_overlaps_appliedFilt5.txt 
    done


    ## SNPS
    for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/samples/$a/applied_filters5_noZ/*_all78samples_ensemble_2padd.snps.2orMore.ADfilt.incJax2019.callableIntervals.applied_filters5_bcftools_isec/0000.vcf
    do 
        echo $i
        bedtools intersect -a $i -b $BEDfilesFolder/$b.casoffinder.output.bed -wo >> casoffinder_8mismatches_intersection_padded_June2022_ignoreStrands/$a.$b.vcf_overlaps_appliedFilt5.txt 
    done


    ## Metasv
    for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/$a/final/*/*metasv_filtered.vcf.bedpe.noheader.fixed.sec_filt_ignoreStrands.1bp.start.bed12
    do echo $i
        bedtools intersect -a $i -b $BEDfilesFolder/$b.casoffinder.output.bed -wo >> casoffinder_8mismatches_intersection_padded_June2022_ignoreStrands/$a.$b.vcf_overlaps_appliedFilt5.txt
    done

    echo

done
