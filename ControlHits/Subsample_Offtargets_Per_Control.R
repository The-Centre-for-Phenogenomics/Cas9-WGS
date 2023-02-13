library(dplyr)
library(data.table)

args=commandArgs(trailingOnly = T)

df = fread(args[1],stringsAsFactors = F)

controls=c("C7242_282_01", "C7242_572_01", "C7242_572_10", "C7268_237_01", "C7268_237_04", "C7268_523_02", "C7268_523_06", "B6NC_218_01", "B6NC_218_05", "B6NC_256_04", "B6NC_256_06", "B6NC_282_10", "B6NJ_170103", "B6NJ_170606", "B6NJ_GET", "B6NJ_AX9", "B6NJ_KAP", "MBP52", "MBP55", "MBP56", "MBP58", "MBP60", "NJAX_1644_2c", "NJAX_1644_2d", "NJAX_1714_6d", "NJAX_1714_6h", "NJAX_1726_1a", "NJAX_1726_1b")

for (i in 1:length(controls)){
  table_name = noquote(paste(controls[i],"randomly_selected_offtargets_6mismatches.bed",sep="_"))
  print(i)
  print(table_name)
  set.seed(i)
  table=sample_n(df, 78192)
  write.table(table,file=table_name,sep="\t",quote=F,row.names=F,col.names=F)
}
