#!/bin/bash
module load bedtools
for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/*/final/*/*metasv_filtered*vcf*bedpe*noheader.fixed

do
    #printf "$i\n"
    cp $i $i.sec_filt_ignoreStrands
    for j in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/*/final/*/*metasv_filtered*vcf*bedpe*noheader.fixed
    do
        if [ $i == $j ]
        then
            continue
        else
            echo $i $j
            pairToPair -a $i.sec_filt_ignoreStrands -b $j -type neither -is > temp2.bedpe
            mv temp2.bedpe $i.sec_filt_ignoreStrands
        fi
    done
done
