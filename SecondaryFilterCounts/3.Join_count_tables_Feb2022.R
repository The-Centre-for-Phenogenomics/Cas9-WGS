library(plyr)
library(data.table)

files=list.files(path="intermediate_files/",pattern='_counts_table_Feb2022.tsv',full.names=T)

all_files <- lapply(files,function(x) {
   fread(file = x, 
              sep = '\t', 
              stringsAsFactors = F)
})

df=join_all(all_files, by='seen.in.num.controls', type='left')

write.csv(df,"secondary_counts_by_control_Feb2022_FINAL.csv",row.names=F,quote=F)
