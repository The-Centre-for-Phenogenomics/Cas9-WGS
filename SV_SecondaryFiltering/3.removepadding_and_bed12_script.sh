#STEP 1: REMOVE 1 BP PADDING FOR START SITE TO RESTORE ORIGINAL COORDINATE
for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/*/final/*/*metasv_filtered*vcf*bedpe*noheader.fixed.sec_filt_ignoreStrands

do
    echo $i
    awk 'OFS="\t" {print $1, $2+1, $3, $4, $5+1, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22}' $i > $i.1bp.start

done

#STEP2: CONVERT BEDPE FILES TO BED12
for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/new*/*/final/*/*metasv_filtered*vcf*bedpe*noheader.fixed.sec_filt_ignoreStrands.1bp.start

do 

    echo $i
    svtools bedpetobed12 -i $i -o $i.bed12 -n $i

done
