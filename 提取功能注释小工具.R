#包
library(data.table)
#gff3 文件 此处为2代结果
data = fread("/Volumes/Cornucopia/DataBase/GFF3/gnm2.ann1.4K0L/gnm2.ann1.4K0L.gene_models_main.gff3",header = F)
#仅保留gene结果
gene = data[grepl("gene",data$V3),]
#统计基因个数
length = nrow(gene)
#设置输出文件夹
out = data.frame(matrix(nrow=length, ncol=5))
title = c("Chr","Name","Startpos","Endpos","Note")
colnames(out) = title
#完成程序
num = 1
for (x in 1:length) {
  out$Chr[num] = gene$V1[num]
  #此处需要更改
  out$Name[num] = sub('.*ID=arahy.Tifrunner.gnm2.ann1.(.*);Name=.*', '\\1', gene[num,9])
  out$Startpos[num] = gene$V4[num]
  out$Endpos[num] = gene$V5[num]
  out$Note[num] = sub(".*Note=", "", gene[num,9])
  num = num + 1 
}
#输出结果文件
fwrite(out,"/Volumes/Cornucopia/DataBase/GFF3/gnm2.ann1.4K0L/gnm2.Note.txt")
