library(dplyr)
library(data.table)
library(stringr)


args=commandArgs(trailingOnly = T)

df=fread(args[1],stringsAsFactors = F)
input.file=args[1]
sample.name=str_remove(input.file,".casoffinder.output.txt")
sample.name=str_remove(sample.name,"../")

df=df %>% filter(V6!=0 & V6<=args[2]) #remove "off-targets" with 0 mismatches, they are true targets and should not be counted, and also count only off-targets with the desired number of mismatches or less

#remove off-targets that are not on canonical chromosomes:
chr=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
#df=df[(df[,2] %in% chr),]

df=df %>% filter(V2 %in% chr)

counts=as.data.frame(table(df$V1))

counts=counts %>% rename(Guides=Var1,Num.Offtargets=Freq)

counts=counts %>% mutate(Sample=sample.name)
counts <- counts[, c("Sample", "Guides", "Num.Offtargets")]

OutFile <- paste0(sample.name,'_off-target_counts_table_April2023.tsv',sep="")

write.table(counts,OutFile,sep="\t",quote=F,row.names = F)
