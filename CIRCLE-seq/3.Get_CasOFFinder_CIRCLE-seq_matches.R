library(dplyr)
library(data.table)

df.casoff=fread("combined_casoffinder_output.bed",stringsAsFactors=F)
df.circle=fread("combined_circleseq.bed",stringsAsFactors=F)

df.casoff$V1=gsub("_6mismatches.casoffinder.output.bed","",df.casoff$V1)
df.circle$V1=gsub("_identified_matched.bed","",df.circle$V1)

join_by=c("V1","V2","V3","V4")
df=inner_join(df.circle,df.casoff,by=join_by)

df=df %>% filter(V6!=0)

table(df$V1)

df.outer.cicle=anti_join(df.circle,df.casoff,by=join_by)
df.outer.casoff=anti_join(df.casoff,df.circle,by=join_by)

write.csv(df,"matching_casoff_circleseq_sites.csv",quote = F,row.names = F)
write.csv(df.outer.cicle,"non-matching_circleseq_sites.csv",quote = F,row.names = F)
write.csv(df.outer.casoff,"non-matching_casoff_sites.csv",quote = F,row.names = F)
