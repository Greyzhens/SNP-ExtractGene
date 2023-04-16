library(data.table)
data = fread("/Volumes/Cornucopia/Project/主线任务/表型/Catrait.txt",header = T)
data = as.data.frame(data)

length = nrow(data)

#K均值聚类（k-means）
#层次聚类（hierarchical clustering）
#混合聚类（mixture models）

out = data.frame(matrix(nrow=272, ncol=8))
title = colnames(data)

titleplus = c(1:8)
num = 2
for (x in 1:8) {
  titleplus[num-1] = paste0(title[num],"_HC")
  num =num + 1
}

colnames(out) = titleplus

#层析聚类
count = 2
for (y in 1:8) {

  gray = data[,count]
  gray = sub("na", "", gray)
  gray = as.numeric(gray)
  
  if(sum(is.na(gray)) > 0){
    print(paste0(title[count],"列存在空值"))
    mean_value = mean(gray, na.rm = TRUE)
    gray = ifelse(is.na(gray), mean_value, gray)
  } else {
    print(paste0(title[count],"列不存在空值"))
  }
  
  distance = dist(gray,method = "euclidean")
  
  hc = hclust(distance, method = "ward.D2")
  
  groups = cutree(hc, k = 5)
  
  out[,count-1] = groups
  
  print(paste0(title[count],"列已完成层次聚类"))
  
  count = count + 1 
}

out = cbind(data,out)
fwrite(out,"/Volumes/Cornucopia/Project/主线任务/表型/层次聚类.csv")