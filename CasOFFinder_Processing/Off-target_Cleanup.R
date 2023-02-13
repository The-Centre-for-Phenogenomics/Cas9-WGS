#!/usr/bin/env Rscript

args=commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.txt"
}

library(dplyr)
library(data.table)
library(stringr)
df=fread(args[1],stringsAsFactors=F,fill=T,sep="\t")

#remove unwanted columns
df$V7=NULL
df$V8=NULL
df$V9=NULL
df$V10=NULL
df$V11=NULL

df=as.data.frame(df)
#move over SV rows 2 columns to the right
i=1

for (i in 1:nrow(df)){
  if (grepl('chr',df[i,'V14'])==TRUE){
    df[i,7:14]<-df[i,9:16]
    df[i,15:16]="NA"
  }
  else{
    df[i,9:16]<-df[i,9:16]
  }
}

df$V19=NULL
df$V20=NULL
df$V21=NULL

#remove off-target padding
df$V13=as.numeric(df$V13)+1
df$V14=as.numeric(df$V14)-1

#format first column better
df$V1=str_remove(df$V1,".vcf_overlaps_appliedFilt5.txt")

df= df %>% mutate(GeneTargeted="")

i=1
for (i in 1:nrow(df)){
 df[i,'GeneTargeted'] <- strsplit(df$V1,"[.]")[[i]][2] 
}

#rename columns 
df = df %>% rename(Sample=V1,Variant.Chrom=V2,Variant.Start=V3,Variant.Stop=V4,Variant.Ref=V5,Variant.Alt=V6,Offtarget.Chrom=V12,Offtarget.Start=V13,Offtarget.End=V14,Offtarget.Strand=V15,Number.Mismatches=V16,On.Target.Sequence=V17,Off.Target.Sequence=V18)
#reorder the columns
df <- df[,c("Sample","GeneTargeted","Variant.Chrom","Variant.Start","Variant.Stop","Variant.Ref","Variant.Alt","Offtarget.Chrom","Offtarget.Start","Offtarget.End","Offtarget.Strand","Number.Mismatches","On.Target.Sequence","Off.Target.Sequence")]

#remove rows with 0 mismatches and keep only rows for specified number of mismatches (or less)
df = df %>% filter(Number.Mismatches>0 & Number.Mismatches<=args[3])

write.csv(df,file=args[2],row.names=F,quote=F)
