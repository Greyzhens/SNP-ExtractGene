wd=("/Users/ningdongzhen/Desktop/Github/SNP-ExtractGene/GFF/gnm2.ann1.4K0L/")
filename=("4K0L.gff3.gz")
#例：arahy.Tifrunner.gnm1.Arahy.x，chr1为"arahy.Tifrunner.gnm1.Arahy."。chr2为"x"
chr1=("arahy.Tifrunner.gnm2.Arahy.")
chr2=c("01","02","03","04","05",
          "06","07","08","09","10",
          "11","12","13","14","15",
          "16","17","18","19","20")

GFF3_Split_Chr = function() {
  #包
  library(data.table)
  #设置路径
  setwd(wd)
  #读取gff文件
  gz_file = gzfile(filename)
  gz_file = readLines(gz_file)
  gz_file = as.data.frame(gz_file)
  gz_file = gz_file[-(1:3),]
  gz_file = as.data.frame(gz_file)
  head(gz_file)
  grayzhens = sub("\\.[^.]*$", "", filename)
  fwrite(gz_file,grayzhens)
  data=suppressWarnings(fread(grayzhens))
  file.remove(grayzhens)
  #循环部分
  count = 1
  for (x in 1:20) {
    name = paste0(chr1,chr2[count])
    chr = data
    chr = chr[grep(name,chr$gz_file), ]
    wname = paste0(name,".txt")
    fwrite(chr,wname,col.names= FALSE)
    print(paste0(wname," has been completed. Process ",count,"/20"))
    count = count + 1
  }
}

GFF3_Split_Chr()