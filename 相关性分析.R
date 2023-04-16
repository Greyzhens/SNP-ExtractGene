library(data.table)
hc = fread("/Volumes/Cornucopia/Project/主线任务/GWAS/MLM/层次聚类.csv",header = F)
hc = as.data.frame(hc)
snp = fread("/Volumes/Cornucopia/Project/主线任务/GWAS/MLM/8traits_3980SNP_gene.csv",header = T)
snp = as.data.frame(snp)

#number SNP的个数
number = nrow(snp)
#相关系数
correlation = c(1:number)
nucleobase = c(1:number)

numberpro = 1
for (z in 1:number) {
  Yann = sub("-Chr.*", "", snp[numberpro,1])
  Yann = paste0(Yann,"_HC")
  col_idx = which(hc[1, ] == Yann)
  Yann = hc[,col_idx]
  Yann = Yann[-1]
  Yann = as.numeric(Yann)
  Yann = Yann[-20]
  
  colnames(snp)
  snpcolnum = ncol(snp)
  Gray = snp[numberpro,26:snpcolnum]
  Gray = unlist(Gray)

  nucleobase[numberpro] = names(table(Gray))[which.max(table(Gray))]
  
  Grayzhens = unique(Gray)
  snplength = length(Grayzhens)
  snpaimlength = length(Gray)
  
  num = 1
  for (x in 1:snplength) {
    numplus = 1
    for (y in 1:snpaimlength) {
      if (Grayzhens[num] == Gray[numplus]) {
        Gray[numplus] = num
        numplus = numplus + 1
      }else{
        numplus = numplus + 1
      }
    }
    num =num + 1
  }
  Gray = as.numeric(Gray)
  cor_coef = cor(Yann, Gray)
  
  correlation[numberpro] = cor_coef
  
  print(paste0("已完成 ",numberpro,"/",number))
  
  numberpro = numberpro + 1
}
out = cbind(snp,nucleobase)
out = cbind(out,correlation)

fwrite(out,"/Volumes/Cornucopia/Project/主线任务/GWAS/MLM/8traits_3980SNP_gene_correlation.csv")
