library(dplyr)
library(data.table)
library(stringr)

args=commandArgs(trailingOnly=TRUE)

df=fread(args[1],stringsAsFactors = F)
input.file=args[1]
sample.name=str_remove(input.file,"_concat_Feb2022_callers.txt")
sample.name=str_remove(sample.name,"intermediate_files/")

#file has 2 columns, where V1 contains the sample names and V2 is blank. 

controls=c("C7242_282_01", "C7242_572_01", "C7242_572_10", "C7242_237_01", "C7268_237_04", "C7268_523_02", "C7628_523_06", "B6NC_218_01", "B6NC_218_05", "B6NC_218_04", "B6NC_256_06", "B6NC_282_10", "B6NJ_170103", "B6NJ_170606", "B6NJ_GET", "B6NJ_AX9", "B6NJ_KAP", "MBP52", "MBP55", "MBP56", "MBP58", "MBP60", "NJAX_1644_2c", "NJAX_1644_2d", "NJAX_1714_6d", "NJAX_1714_6h", "NJAX_1726_1a", "NJAX_1726_1b")

df$V1=gsub("CALLERS=","",df$V1)
#df$V1=strsplit(df$V1,",")
df$number.of.controls <- str_count(as.character(df$V1), c("C7242_282_01|C7242_572_01|C7242_572_10|C7268_237_01|C7268_237_04|C7268_523_02|C7268_523_06|B6NC_218_01|B6NC_218_05|B6NC_256_04|B6NC_256_06|B6NC_282_10|B6NJ_170103|B6NJ_170606|B6NJ_GET|B6NJ_AX9|B6NJ_KAP|MBP52|MBP55|MBP56|MBP58|MBP60|NJAX_1644_2c|NJAX_1644_2d|NJAX_1714_6d|NJAX_1714_6h|NJAX_1726_1a|NJAX_1726_1b"))

counts=as.data.frame(table(df$number.of.controls),stringsAsFactors=F)
counts=counts %>% rename(seen.in.num.controls=Var1)
names(counts)[names(counts) == "Freq"] <- paste(sample.name,'.num.variants',sep='')

counts[30,2]=sum(counts[,2])
counts[30,1]="Total"

OutFile <- paste0('intermediate_files/',sample.name,'_counts_table_Feb2022.tsv',sep="")
write.table(counts,OutFile,row.names = F,quote = F,sep="\t")
