library(dplyr)
library(data.table)

df_gatk_unfiltered=fread("Feb2022_unfiltered_gatk_numbers.txt",stringsAsFactors = F)
df_gatk_filtered=fread("Feb2022_filtered_gatk_numbers.txt",stringsAsFactors = F)
df_repeat=fread("Feb2022_filtered_repeat_numbers.txt",stringsAsFactors = F)
df_repeat_tandem=fread("Feb2022_filtered_repeat_tandem_numbers.txt",stringsAsFactors = F)
df_dbsnp_snp=fread("Feb2022_filtered_dbsnp_snps.txt",stringsAsFactors = F)
df_dbsnp_indel=fread("Feb2022_filtered_dbsnp_indels.txt",stringsAsFactors = F)
df_eva_snp=fread("Feb2022_filtered_eva_snps.txt",stringsAsFactors = F)
df_eva_indel=fread("Feb2022_filtered_eva_indels.txt",stringsAsFactors = F)
df_ad_snps=fread("Feb2022_filtered_AD_snps.txt",stringsAsFactors = F)
df_ad_indel=fread("Feb2022_filtered_AD_indels.txt",stringsAsFactors = F)
df_ad_concat=fread("Feb2022_filtered_AD_concat.txt",stringsAsFactors = F)
df_callable_snp=fread("Feb2022_filtered_callable_snps.txt",stringsAsFactors = F)
df_callable_indel=fread("Feb2022_filtered_callable_indels.txt",stringsAsFactors = F)
df_callable_concat=fread("Feb2022_filtered_callable_concat.txt",stringsAsFactors = F)
df_secondary_snp=fread("Feb2022_filtered_secondary_snp.txt",stringsAsFactors = F)
df_secondary_indel=fread("Feb2022_filtered_secondary_indel.txt",stringsAsFactors = F)


df.list <- list(df_gatk_unfiltered,df_gatk_filtered,df_repeat,df_repeat_tandem,df_dbsnp_snp,df_dbsnp_indel,df_eva_snp,df_eva_indel,df_ad_snps,df_ad_indel,df_ad_concat,df_callable_snp,df_callable_indel,df_callable_concat,df_secondary_snp,df_secondary_indel)

i=1
for (i in 1:length(df.list)) {
  
  df.list[[i]]=df.list[[i]][,-c(2:6)]
  df.list[[i]]=df.list[[i]] %>% rename(Sample=V1)
}  

gatk_unfiltered_df=df.list[[1]] %>% rename(unfiltered.gatk=V7)
gatk_filtered_df=df.list[[2]] %>% rename(filtered.gatk=V7)
repeat.general_df=df.list[[3]] %>% rename(repeat.general=V7)
repeat.tandem_df=df.list[[4]] %>% rename(tandem.repeat=V7)
dbsnp.snp_df=df.list[[5]] %>% rename(dbsnp.snp=V7)
dbsnp.indel_df=df.list[[6]] %>% rename(dbsnp.indel=V7)
eva.snp_df=df.list[[7]] %>% rename(eva.snp=V7)
eva.indel_df=df.list[[8]] %>% rename(eva.indel=V7)
ad.snp_df=df.list[[9]] %>% rename(AD.snp=V7)
ad.indel_df=df.list[[10]] %>% rename(AD.indel=V7)
ad.concat_df=df.list[[11]] %>% rename(AD.concat=V7)
callable.snp_df=df.list[[12]] %>% rename(callable.snp=V7)
callable.indel_df=df.list[[13]] %>% rename(callable.indel=V7)
callable.concat_df=df.list[[14]] %>% rename(callable.concat=V7)
secondary.snp_df=df.list[[15]] %>% rename(secondary.snp=V7)
secondary.indel_df=df.list[[16]] %>% rename(secondary.indel=V7)

#combine dbsnp
dbsnp.full=left_join(dbsnp.snp_df,dbsnp.indel_df,by="Sample")
dbsnp.full=dbsnp.full %>% mutate(dbsnp=dbsnp.snp+dbsnp.indel)
dbsnp.full$dbsnp.snp=NULL
dbsnp.full$dbsnp.indel=NULL

#combine EVA
eva.full=left_join(eva.snp_df,eva.indel_df,by="Sample")
eva.full=eva.full %>% mutate(EVA=eva.snp+eva.indel)
eva.full$eva.snp=NULL
eva.full$eva.indel=NULL

#combine secondary snp and indel
secondary.full=left_join(secondary.snp_df,secondary.indel_df,by="Sample")
secondary.full=secondary.full %>% mutate(secondary=secondary.snp+secondary.indel)
secondary.full$secondary.snp=NULL
secondary.full$secondary.indel=NULL

#combine counts

full.table=left_join(gatk_unfiltered_df,gatk_filtered_df,by="Sample")
full.table=left_join(full.table,repeat.general_df,by="Sample")
full.table=left_join(full.table,repeat.tandem_df,by="Sample")
full.table=left_join(full.table,dbsnp.full,by="Sample")
full.table=left_join(full.table,eva.full,by="Sample")
full.table=left_join(full.table,ad.concat_df,by="Sample")
full.table=left_join(full.table,callable.concat_df,by="Sample")
full.table=left_join(full.table,secondary.full,by="Sample")

#remove ADKT-8417 from table
full.table<-full.table[!(full.table$Sample=="ADKT_8417"),]

write.csv(full.table,"Feb2022_VariantCounts_AfterFilters.csv",row.names = F,quote=F)
