#!/bin/bash

#PBS -N Crisper_Primary_Filtering
#PBS -l walltime=24:00:00,nodes=1:ppn=1
#PBS -joe .
#PBS -d .
#PBS -l vmem=25g,mem=25g

# $1 is the full path to the final folder of the bcbio VCF file (usually ../final/data_samplename with the name of the file having "sample-gatk-haplotype-annotated-decomposed.vcf.gz" format
module load bcftools
module load htslib
module load bedtools
module load python
module load tabix

#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/allVCFs_exJax2.txt
#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_WILLVCFsRaw.txt
#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_BaylorRaw.txt
#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_NUT5895_NUT5896.txt
#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_jax2_adaptrim_RawVCF.txt
#inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_Jax2_GET2349.txt
inputVCF=/hpf/largeprojects/lauryl/scripts/filters_scripts/CRISPR_filters5_inputVCFs/new_AllVCFsRaw_rsIDsUpdated.txt


#TODO: add the writting to the log file
## List of PRIMARY FILTERS
#  Remove LowQual, LowGQ, LowAF, ./., 0/0   
#  Remove REPEATS     
#  Remove dbSNPs     
#  Remove EVAs
#  Apply the new AD filter to them
#  Concatenate SNPs and INDELs VCF files 


while IFS='' read -r VCF || [[ -n "$VCF" ]]; do

	if [[ ! $VCF = *".vcf"* ]]; then continue; fi
	fullpath=$VCF
	dir=$(dirname $fullpath)
	sample=$(basename $(dirname $(dirname $dir)))

	echo $sample

	mkdir -p $dir/applied_filters5



	######################################   Remove LowQual, LowGQ, LowAF, ./., 0/0   #####################################

	bcftools filter -m '+' -O v -i 'QUAL>30 && MIN(FMT/DP)>9 && MIN(FMT/GQ)>30 && MIN(AF>0.1)' $fullpath | grep -v '\.\/\.' | grep -v '0/0' > $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf && \
	bgzip -cf $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf > $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf.gz && \
	tabix -pvcf $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf.gz



	#############################################     Remove REPEATS     ###################################################

	repeats_file=/hpf/largeprojects/lauryl/scripts/filters_scripts/repeats_BED/2018_0426_repeats_2padd.bed
	tandem_repeats_file=/hpf/largeprojects/lauryl/scripts/filters_scripts/repeats_BED/2018_0426_tandem_repeats_2padd.bed

	noRepeatsVCF_noHeader=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRep_noHeader.vcf
	noRepeatsVCF_wHeader=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRep_2padd.vcf

	noRepeats_noTandemRepeatsVCF_noHeader=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRep_noTanRep_noHeader.vcf
	noRepeats_noTandemRepeatsVCF_wHeader=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRep_noTanRep_2padd.vcf

	bedtools subtract -a $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf.gz -b $repeats_file > $noRepeatsVCF_noHeader && \
	zcat $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf.gz | grep "^#" > $noRepeatsVCF_wHeader && cat $noRepeatsVCF_noHeader >> $noRepeatsVCF_wHeader && \
	bgzip -cf $noRepeatsVCF_wHeader > $noRepeatsVCF_wHeader.gz && tabix -pvcf $noRepeatsVCF_wHeader.gz && \

	bedtools subtract -a $noRepeatsVCF_wHeader.gz -b $tandem_repeats_file > $noRepeats_noTandemRepeatsVCF_noHeader && \
	zcat $dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt.vcf.gz | grep "^#" > $noRepeats_noTandemRepeatsVCF_wHeader && cat $noRepeats_noTandemRepeatsVCF_noHeader >> $noRepeats_noTandemRepeatsVCF_wHeader && \
	bgzip -cf $noRepeats_noTandemRepeatsVCF_wHeader > $noRepeats_noTandemRepeatsVCF_wHeader.gz && tabix -pvcf $noRepeats_noTandemRepeatsVCF_wHeader.gz

	rm -rf $noRepeatsVCF_noHeader
	rm -rf $noRepeats_noTandemRepeatsVCF_noHeader



	#############################################     Remove dbSNPs     ###################################################

	dbsnp_indels='/hpf/largeprojects/lauryl/scripts/run_forge/dbsnp/raw150/dbSNP150_chr.indels.vt.vcf.gz'
	dbsnp_snps='/hpf/largeprojects/lauryl/scripts/run_forge/dbsnp/raw150/dbSNP150_chr.snps.vt.vcf.gz'

	snps_out=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_2padd.snps.vcf.gz
	indels_out=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_2padd.indels.vcf.gz

	nodb_snps=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_2padd.snps.vcf
	nodb_indels=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_2padd.indels.vcf


	## Break the sample file into SNPs and Indels+MNPs
	bcftools view --exclude-types indels $noRepeats_noTandemRepeatsVCF_wHeader.gz | bgzip -cf > $snps_out && tabix -pvcf $snps_out   
	bcftools view --exclude-types snps $noRepeats_noTandemRepeatsVCF_wHeader.gz | bgzip -cf > $indels_out && tabix -pvcf $indels_out

	bcftools isec -C -O v -w1 $snps_out $dbsnp_snps > $nodb_snps && bgzip -cf $nodb_snps > $nodb_snps.gz && tabix -pvcf $nodb_snps.gz   
	bcftools isec -C -O v -w1 $indels_out $dbsnp_indels > $nodb_indels && bgzip -cf $nodb_indels > $nodb_indels.gz && tabix -pvcf $nodb_indels.gz;




	#############################################     Remove EVAs     ###################################################
	
	eva_indels='/hpf/largeprojects/lauryl/results/bcbio_nextgen/control_VQSR_set/Crispr14_EVA_GRCm38_variants/EVA_downloads/processing2/p2p3p4_ExcludeSnps_merged_union_normalizedWbcftools_wChr.vcf.gz'
	eva_snps='/hpf/largeprojects/lauryl/results/bcbio_nextgen/control_VQSR_set/Crispr14_EVA_GRCm38_variants/EVA_downloads/processing2/p2p3p4_IncludeSnps_merged_union_normalizedWbcftools_wChr.vcf.gz'

	noEVA_snps=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_noEVA_2padd.snps.vcf
	noEVA_indels=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_filt_noRepeat_nodbsnp150_noEVA_2padd.indels.vcf
	
	bcftools isec -C -O v -w1 $nodb_snps.gz $eva_snps > $noEVA_snps && bgzip -cf $noEVA_snps > $noEVA_snps.gz && tabix -pvcf $noEVA_snps.gz
	bcftools isec -C -O v -w1 $nodb_indels.gz $eva_indels > $noEVA_indels && bgzip -cf $noEVA_indels > $noEVA_indels.gz && tabix -pvcf $noEVA_indels.gz




	####################################   Apply AD filters and Concatenate SNPs and INDELs VCF files ############################################

	noEVA_concat=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.vcf
        snps_newFilt=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.snps.vcf
        indels_newFilt=$dir/applied_filters5/${sample}-gatk-haplotype-annotated-decomposed_ADfilt_noRepeat_nodbsnp150_noEVA_2padd.indels.vcf


        ## Here before concatenating the SNPs and INDELs file, we apply the new AD filters to them.

        ## filtering the SNPs
        python CRISPR_filters5_hpf_2padd_newADfilt_ADdistribution.py $noEVA_snps
        bgzip -cf $snps_newFilt > $snps_newFilt.gz && tabix -pvcf $snps_newFilt.gz

        ## filtering the INDELs
        python CRISPR_filters5_hpf_2padd_newADfilt_ADdistribution.py $noEVA_indels
        bgzip -cf $indels_newFilt > $indels_newFilt.gz && tabix -pvcf $indels_newFilt.gz

        ## Concatenating the two
        bcftools concat -a $snps_newFilt.gz $indels_newFilt.gz -Ov -o $noEVA_concat
        bgzip -c $noEVA_concat > $noEVA_concat.gz
        tabix -p vcf $noEVA_concat.gz

	########################################################################################################################	

done < $inputVCF

