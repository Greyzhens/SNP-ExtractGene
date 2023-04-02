#包
library(data.table)
#基因家族文件
mainlist = fread("/Users/ningdongzhen/Desktop/Github/SNP-ExtractGene/基因家族/基因对比/765.fa",header  = F)
mainlist =  as.data.frame(mainlist[grep(">arahy.Tifrunner.gnm2.ann1", mainlist$V1)])
#GWAS结果文件
aimlist = fread("/Users/ningdongzhen/Desktop/Github/SNP-ExtractGene/基因家族/基因对比/Ca.csv",header = T)
#构建表格
Result = data.frame(matrix(0, nrow = 121, ncol = 10))
title = c("Ca11","count11",
          "Ca18","count18",
          "Ca411","count411",
          "Ca413","count413",
          "Ca418","count418")
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

#Ca411
num411 = 1
for (x in 1:66) {
  count = grepl(aimlist$Ca4_11[num411],mainlist$V1)
  count = nrow(count)
  if (is.null(count)) {
    Result$Ca411[num411] = aimlist$Ca4_11[num411]
    num411 = num411 + 1
  }else{
    Result$count411[num411] = count
    num411 = num411 + 1
  }
}

#Ca413
num413 = 1
for (x in 1:65) {
  count = grepl(aimlist$Ca4_13[num413],mainlist$V1)
  count = nrow(count)
  if (is.null(count)) {
    Result$Ca413[num413] = aimlist$Ca4_13[num413]
    num413 = num413 + 1
  }else{
    Result$count413[num413] = count
    num413 = num413 + 1
  }
}

num418 = 1
for (x in 1:31) {
  count = grepl(aimlist$Ca4_18[num418],mainlist$V1)
  count = nrow(count)
  if (is.null(count)) {
    Result$Ca418[num418] = aimlist$Ca4_18[num418]
    num418 = num418 + 1
  }else{
    Result$count418[num418] = count
    num418 = num418 + 1
  }
}