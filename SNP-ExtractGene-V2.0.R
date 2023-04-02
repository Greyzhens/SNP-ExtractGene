#仅用于处理TESSAL软件生成的GWAS结果文件
#仅适用于提取 花生(Arachis hypogaea) 二代测序的基因数据
#输出文件包括：单表型结果文件(包含snpID，chr，pos，p，alpha)，表型-染色体-显著性位点-基因文件，表型的曼哈顿图，表型的QQ图
#作者：Grayzhens CandyYanns

#包
#####
##下载包，仅需一次
#install.packages("data.table")
#install.packages("CMplot")
#加载包
library(data.table)
library(CMplot)

#输入变量
#####
#文件路径
WD = ("/Users/ningdongzhen/Desktop/test/ZJJ/out/")  ##此处需要更改
#GWAS结果文件
data = fread("/Volumes/GrayData/LHD/MLM/out10.txt",#此处为结果文件，需使用绝对路径 ##此处需要更改
             header = F)

#读取gff文件，已设置为默认值，如有必要请自行修改
####输入文件合集
version

chrb=c("01","02","03","04","05",
       "06","07","08","09","10",
       "11","12","13","14","15",
       "16","17","18","19","20")

chra = ("/Users/ningdongzhen/Desktop/Github/SNP-ExtractGene/GFF/gnm1.ann1.CCJH/arahy.Tifrunner.gnm1.Arahy.")
chrb = chrb[1]
chrc = (".txt")
chrname = paste0(chra,chrb,chrc)

#封装函数

#####
#函数 FilePath 创建文件夹
FilePath = function(){
  #判断路径是否存在，如果不存在则创建
  judgedir=dir.exists(WD)
  if (judgedir == FALSE) {
    dir.create(WD)
    print("The directory creation completed.")
  }else{
    print("The directory already exists")
  }
  #设置目录
  setwd(WD)
}





Trait = function(){
  #提取表型性状ID
  phenotype_name=head(trait, n = 1)[, -1]
  phenotype_name = unlist(phenotype_name)
  #提取表头
  datahead = data[1,]
  datahead = unlist(datahead)
  #按ID提取
  phenotype = data[grep(phenotype_name[traitnum], data$V1),]
  phenotype = phenotype[-1,]
  #更改列名
  colnames(phenotype)=datahead
  #输出文件 phenotype
  Yann = paste0("Successfully extracted ",phenotype_name[traitnum], ". Progress ", traitnum, "/", traitcount)
  print(Yann)
  #构建输出文件
  phenotype_out=phenotype[,c(2,3,4,7,15)]
  fwrite(phenotype_out,file=paste0(phenotype_name[traitnum],".csv"), sep = ",")
  grayzhens = paste0(phenotype_name[traitnum],".csv has been completed.")
  print(grayzhens)
  #返回全局
  trait_chr = phenotype[,c(2,3,4,7)]
  trait_chr$p = as.numeric(trait_chr$p)
  trait_chr$Pos = as.numeric(trait_chr$Pos)
  trait_chr = trait_chr[!grepl("NaN", trait_chr$p), ]
  trait_chr <<- trait_chr
  trait_name <<- phenotype_name[traitnum]
  traitnum = traitnum + 1
  traitnum <<- traitnum
  }

#绘图函数
cmplot = function(){
  ##绘图部分
  dataCM = trait_chr
  #绘图
  CMplot(dataCM, 
         plot.type=c("m","q"),#同时输出曼哈顿图和QQ图
         LOG10=TRUE, 
         ylim=c(0,12),#这里限制y轴上限
         threshold=c(1e-6,1e-8),#设置标准线 6 和 8
         threshold.lty=c(1,2),
         threshold.lwd=c(1,1), 
         threshold.col=c("black","grey"), 
         amplify=F,bin.size=1e6,
         chr.den.col=c("darkgreen", "yellow","red"),
         signal.col=c("red","green"),
         signal.cex=c(1,1),
         signal.pch=c(19,19),
         file="jpg",#输出图片的格式
         memo=trait_name,
         dpi=2000,#输出图片的大小
         file.output=TRUE,
         verbose=TRUE)
  Yann = paste(trait_name,"'s plot has been completed.",sep = "")
  print(Yann)
}

#函数 Chr 利用trait_chr 提取高显著性位点 chr_snp
Chr = function(){
  Yann = paste("S", chrnum,"_", sep = "")
  chr = trait_chr[grepl(Yann, trait_chr$Marker), ]
  chr = as.data.frame(chr)
  alpha = -log10(as.numeric(chr$p))
  alpha = format(alpha, scientific = FALSE)
  alpha = as.numeric(alpha)
  chr = cbind(chr, alpha)
  #只提取(6,12)
  chr = subset(chr, alpha >= 6 & alpha <= 12)
  chr$Pos=as.numeric(chr$Pos)
  
  if (nrow(chr) != 0) {#有显著性位点则输出提示
    grayzhens = paste0(trait_name,"'s ","highly significant loci on " ,"Chr ",chrnum," have been extracted.")
    print(grayzhens)
    grayzhens = paste0(trait_name," chr process ",chrnum," /20")
    print(grayzhens)
    greyzhens <<- greyzhens + 1
    chr_snp <<- chr
    snpcount <<- nrow(chr_snp) 
    snpnum <<- 1
    #构建输出的三列基因
    In_gene <<- c(1:snpcount)
    Pre_gene <<- c(1:snpcount)
    Post_gene <<- c(1:snpcount)
    for (snpnum in 1:snpcount) {
      Snp()
    }
    
    #文件
    gene = data.frame(matrix(nrow = snpcount, ncol = 8))
    #构建输出文件表头
    genetitle = c("SNPID",
                  "Chr",
                  "pos",
                  "p",
                  "alpha",
                  "PrevGene",
                  "InGene",
                  "NextGene")
    #设置输出文件表头
    colnames(gene) = genetitle
    gene[,1:5]=chr_snp
    gene[,6]=Pre_gene
    gene[,7]=In_gene
    gene[,8]=Post_gene
    yann = chrnum
    grayzhens=paste(trait_name, "_Chr", yann , sep = "")
    fwrite(gene, file = paste0(grayzhens, "_SNP_gene.csv"), sep = ",")
    Yann = paste(grayzhens , "_SNP_gene.csv has been completed. Summary ",snpcount , sep = "")
    print(Yann)
    chrnum = chrnum + 1
    chrnum <<- chrnum
  }else{
    grayzhens = paste0(trait_name,"_Chr",chrnum," has no significant loci and has been skipped.")
    print(grayzhens)
    chrnum = chrnum + 1
    chrnum <<- chrnum
  }
}

#函数 Snp 寻找候选基因
Snp <- function() {
  #chr_gff
  chr_gff = fread(chrall[chrnum])
  gfftitle = c("chr","maker","type","startpos","endpos","1","2","3","genename")
  colnames(chr_gff) = gfftitle
  
  gffcount = nrow(chr_gff)
  gffnum = 1
  for (gffnum in 1:gffcount) {
    if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum]) {
      #在最前端 只有Post_gene
      Post_gene[snpnum] <<- chr_gff$genename[gffnum]
      break
    }else{
      if (chr_snp$Pos[snpnum] <= chr_gff$endpos[gffnum]) {
        #基因内
        In_gene[snpnum] <<- chr_gff$genename[gffnum]
        break
      }else{
        if (gffnum != gffcount) {
          if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum+1]) {#1
            #基因间
            Pre_gene[snpnum] <<- chr_gff$genename[gffnum]
            Post_gene[snpnum] <<- chr_gff$genename[gffnum+1]
            break
          }else{#1
            gffnum = gffnum + 1
          }
        }else{
          #在最后端 只有Pre_gene
          Pre_gene[snpnum] <<- chr_gff$genename[gffnum]
          break
        }
      }
    }
  }
  Yann = paste(trait_name," Chr",chrnum," SNP process ",snpnum ,"/",snpcount , sep = "")
  print(Yann)
  snpnum <<- snpnum + 1
}

#####

#主程序
main = function(x){
  
  FilePath()
  
  #traitname
  traitname = data$V1
  traitname = unique(traitname)[-1]
  #traitcount
  traitcount = length(traitname)
  traitnum = 1
  for (traitnum in 1:traitcount) {
    phenotype_name=head(trait, n = 1)[, -1]
    phenotype_name = unlist(phenotype_name)
    #提取表头
    datahead = data[1,]
    datahead = unlist(datahead)
    #按ID提取
    phenotype = data[grep(phenotype_name[traitnum], data$V1),]
    phenotype = phenotype[-1,]
    #更改列名
    colnames(phenotype)=datahead
    #输出文件 phenotype
    Yann = paste0("Successfully extracted ",phenotype_name[traitnum], ". Progress ", traitnum, "/", traitcount)
    print(Yann)
    #构建输出文件
    phenotype_out=phenotype[,c(2,3,4,7,15)]
    fwrite(phenotype_out,file=paste0(phenotype_name[traitnum],".csv"), sep = ",")
    grayzhens = paste0(phenotype_name[traitnum],".csv has been completed.")
    print(grayzhens)
    #返回全局
    trait_chr = phenotype[,c(2,3,4,7)]
    trait_chr$p = as.numeric(trait_chr$p)
    trait_chr$Pos = as.numeric(trait_chr$Pos)
    trait_chr = trait_chr[!grepl("NaN", trait_chr$p), ]
    trait_chr <<- trait_chr
    trait_name <<- phenotype_name[traitnum]
    traitnum = traitnum + 1
    traitnum <<- traitnum
    
    
    ####CMplot
    #输入
    dataCM = trait_chr
    #绘图
    CMplot(dataCM, 
           plot.type=c("m","q"),#同时输出曼哈顿图和QQ图
           LOG10=TRUE, 
           ylim=c(0,12),#这里限制y轴上限
           threshold=c(1e-6,1e-8),#设置标准线 6 和 8
           threshold.lty=c(1,2),
           threshold.lwd=c(1,1), 
           threshold.col=c("black","grey"), 
           amplify=F,bin.size=1e6,
           chr.den.col=c("darkgreen", "yellow","red"),
           signal.col=c("red","green"),
           signal.cex=c(1,1),
           signal.pch=c(19,19),
           file="jpg",#输出图片的格式
           memo=trait_name,
           dpi=2000,#输出图片的大小
           file.output=TRUE,
           verbose=TRUE)
    Yann = paste(trait_name,"'s plot has been completed.",sep = "")
    print(Yann)
      
    chrnum <<- 1
    greyzhens <<- 1
    for (chrnum in 1:20) {#20
      Chr()
    }
    if (greyzhens != 1) {
      cmplot()
    }else{
      yann = paste0(trait_name," has no significant loci. ","Skipped. ")
      print(yann)
    }
  }
}

#####
main(1)