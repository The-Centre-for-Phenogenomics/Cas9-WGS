library(data.table)
library(dplyr)

circle=fread("z.all_circleseq_results.txt",stringsAsFactors = F,sep = "\t")
casoff=fread("z.casoffinder_off_target_table_6mismatches_CLEAN.txt",stringsAsFactors = F)

#some data cleaning
circle=circle[circle$Chromosome != "Chromosome",]
circle=circle %>% rename(Sample=ADKK_8044.Aimp1.txt)
circle$Sample=gsub(".txt","",circle$Sample)

circle=circle %>% rename(Offtarget.Chrom=Chromosome,Offtarget.Start=Start,Offtarget.End=End)

circle$Offtarget.Start=as.numeric(circle$Offtarget.Start)
circle$Offtarget.End=as.numeric(circle$Offtarget.End)

join_by=c("Sample","Offtarget.Chrom","Offtarget.Start","Offtarget.End")
df=left_join(circle,casoff,by=join_by)

nrow(df %>% filter(!is.na(Variant.Chrom)))

write.table((df %>% filter(!is.na(Variant.Chrom))),"matching_offtargets.tsv",quote = F,sep = "\t")
