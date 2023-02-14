for i in /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/circlesq/*/identified/*_identified_matched.txt
do
    file=$(basename -s .txt $i)
    echo $i
    awk 'OFS="\t" {print $1, $2-1, $3+1, $6}' $i > /hpf/largeprojects/lauryl/results/bcbio_nextgen/no_ADKT8417/sfilters/circlesq/post-processing/bed_files/$file.bed

done
