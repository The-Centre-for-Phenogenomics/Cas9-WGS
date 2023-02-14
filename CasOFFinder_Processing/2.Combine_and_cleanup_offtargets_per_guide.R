library(data.table)

files=list.files(pattern='_off-target_counts_table_June2022.tsv',full.names=T)

all_files <- lapply(files,function(x) {
   fread(file = x, 
              sep = '\t', 
              stringsAsFactors = F)
})

df=rbindlist(all_files)

df=as.data.frame(df,stringsAsFactor=F)
df[164,3]=sum(as.numeric(df[,3]))
df[164,1]="Total"

write.csv(df,"z.num_offtargets_per_guide_6mismatches_June2022_FINAL.csv",row.names=F,quote=F)
