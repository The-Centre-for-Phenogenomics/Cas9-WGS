#!/bin/bash

module load bcftools

outputFile=Cb_out_prcnt_of_commonVars_callableInterval.snps.txt

rm -f $outputFile
end=0

echo -n "	" >> $outputFile ## puts an initial tab in the beginning of the first row before sample names so that they align well


## while loop to put the samples list on the first row of the output file
cat Bb_out_78samples_List.txt | while read sample1; do
	echo -n $sample1"	" >> $outputFile
done 
echo >> $outputFile ## print return character after sample names on the first line



## For obtaining the Percent of one to one comparisons from the "isec_OUTPUTb_snps" folder, we have to obtain the "sample1" and "sample2"
##   from the list below
cat Bb_out_78samples_List.txt | while read sample1; do
	echo -n $sample1"	" >> $outputFile ## put the sample name in the beginning of each line
	echo $sample1 ## show run progress at the terminal

	## keep printing progressively more Tabs on each line after the sample name so that we only get half of the matrix in the output
	end=$(($end + 1))
	for j in $(seq 1 $end); do
		echo -n "	" >> $outputFile
	done


	## obtain sample2 from the order of the samples in "Bb_out_78samples_List.txt" since otherwise the order will be based on how the samples
	##  are listed in the folder by bash
	cat Bb_out_78samples_List.txt | while read sample2; do
		if [ -d isec_OUTPUTb_snps/${sample1}___AND___${sample2} ]; then
			sample1unique=$(cat isec_OUTPUTb_snps/${sample1}___AND___${sample2}/0000.vcf | grep -v "^#" | wc -l)
			sample2unique=$(cat isec_OUTPUTb_snps/${sample1}___AND___${sample2}/0001.vcf | grep -v "^#" | wc -l)
			sample1and2common=$(cat isec_OUTPUTb_snps/${sample1}___AND___${sample2}/0002.vcf | grep -v "^#" | wc -l)

			## the calculation requires floating decimal numbers which bash can not handle well, so better to call a Python file
			Percent=$(python Cb_percentCalculate.py $sample1unique $sample2unique $sample1and2common)
			echo "Percent: "$Percent

			echo -n $Percent"	" >> $outputFile ## for each comparison print the Percent of common variants to the output
		fi
	done 

	echo >> $outputFile ## print return character in the output file

done 

