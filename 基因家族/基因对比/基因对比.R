#包
library(data.table)
#基因家族文件
mainlist = fread("/Users/ningdongzhen/Desktop/test/765.fa",header  = F)
mainlist =  as.data.frame(mainlist[grep(">arahy.Tifrunner.gnm2.ann1", mainlist$V1)])
#GWAS结果文件
aimlist = fread("/Users/ningdongzhen/Desktop/test/Ca.csv",header = T)
#构建表格
Result = data.frame(matrix(0, nrow = 121, ncol = 4))
title = c("Ca11","count11","Ca18","count18")
colnames(Result) = title
#11
num11 = 1
for (x in 1:40) {
  count = grepl(aimlist$Ca11[num11],mainlist$V1)
  count = nrow(count)
  if (is.null(count)) {
    Result$Ca11[num11] = aimlist$Ca11[num11]
    num11 = num11 + 1
  }else{
    Result$count11[num11] = count
    num11 = num11 + 1
  }
}
#18
num18 = 1
for (x in 1:121) {
  count = grepl(aimlist$Ca18[num18],mainlist$V1)
  count = nrow(count)
  if (is.null(count)) {
    Result$Ca18[num18] = aimlist$Ca18[num18]
    num18 = num18 + 1
  }else{
    Result$count18[num18] = count
    num18 = num18 + 1
  }
}