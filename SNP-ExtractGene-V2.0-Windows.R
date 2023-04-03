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
WD = ("E:\\SEG")  ##此处需要更改
#GWAS结果文件
data = fread("F:\\5.txt",#此处为结果文件，需使用绝对路径 ##此处需要更改
             header = F)
chra = c("F:\\gnm1.ann1.CCJH\\arahy.Tifrunner.gnm1.Arahy.",
         "F:\\gnm2.ann1.4K0L\\arahy.Tifrunner.gnm2.Arahy.")

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


#函数 GWAS_ExtractGenes GWAS结果文件提取
GWAS_ExtractGenes = function(version){
  
  FilePath()
  
  #traitname
  traitname = data$V1
  traitname = unique(traitname)[-1]
  #traitcount
  traitcount = length(traitname)
  traitnum = 1
  for (traitnum in 1:traitcount) {
    #提取表头
    datahead = data[1,]
    datahead = unlist(datahead)
    #按ID提取
    phenotype = data[grep(traitname[traitnum], data$V1),]
    #MLM模型第一行为空，因此需要删除
    phenotype = phenotype[-1,]
    #更改列名
    colnames(phenotype)=datahead
    
    #输出文件 phenotype
    #输出提示
    Yann = paste0("Successfully extracted ",traitname[traitnum], ". Progress ", traitnum, "/", traitcount)
    print(Yann)
    #构建输出文件
    #phenotype_out 输出文件 包含R方
    phenotype_out=phenotype[,c(2,3,4,7,15)]
    fwrite(phenotype_out,file=paste0(traitname[traitnum],".csv"), sep = ",")
    grayzhens = paste0(traitname[traitnum],".csv has been completed.")
    print(grayzhens)
    #CMplot输入文件
    trait_chr = phenotype_out
    trait_chr$p = as.numeric(trait_chr$p)
    trait_chr$Pos = as.numeric(trait_chr$Pos)
    trait_chr = trait_chr[!grepl("NaN", trait_chr$p), ]
    
    trait_name = traitname[traitnum]
    traitnum = traitnum + 1
      
    chrnum = 1
    greyzhens = 1
    for (chrnum in 1:20) {#20
      Yann2 = paste("S", chrnum,"_", sep = "")
      chr = trait_chr[grepl(Yann2, trait_chr$Marker), ]
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
        greyzhens = greyzhens + 1
        chr_snp = chr
        snpcount = nrow(chr_snp) 
        snpnum = 1
        #构建输出的三列基因
        SNPID = c(1:snpcount)
        In_gene = c(1:snpcount)
        Pre_gene = c(1:snpcount)
        Pre_count = c(1:snpcount)
        Post_gene = c(1:snpcount)
        Post_count = c(1:snpcount)
        
        for (snpnum in 1:snpcount) {
          #chr_gff
          chrb=c("01","02","03","04","05",
                 "06","07","08","09","10",
                 "11","12","13","14","15",
                 "16","17","18","19","20")
          chrb = chrb[chrnum]
          chrc = (".txt")
          chrname = paste0(chra[version],chrb,chrc)
          
          
          chr_gff = fread(chrname)
          gfftitle = c("chr","maker","type","startpos","endpos","1","2","3","genename")
          colnames(chr_gff) = gfftitle
          
          
          
          gffcount = nrow(chr_gff)
          gffnum = 1
          for (gffnum in 1:gffcount) {
            if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum]) {
              #在最前端 只有Post_gene
              Post_gene[snpnum] = chr_gff$genename[gffnum]
              Post_count[snpnum] = chr_gff$startpos[gffnum] - chr_snp$Pos[snpnum]
              SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
              
              break
            }else{
              if (chr_snp$Pos[snpnum] <= chr_gff$endpos[gffnum]) {
                #基因内
                In_gene[snpnum] = chr_gff$genename[gffnum]
                SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                
                break
              }else{
                if (gffnum != gffcount) {
                  if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum+1]) {#1
                    #基因间
                    Pre_gene[snpnum] = chr_gff$genename[gffnum]
                    Pre_count[snpnum] =  chr_snp$Pos[snpnum] - chr_gff$startpos[gffnum]
                    Post_gene[snpnum] = chr_gff$genename[gffnum+1]
                    Post_count[snpnum] = chr_gff$startpos[gffnum+1] - chr_snp$Pos[snpnum]
                    SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                    
                    break
                  }else{#1
                    gffnum = gffnum + 1
                  }
                }else{
                  #在最后端 只有Pre_gene
                  Pre_gene[snpnum] = chr_gff$genename[gffnum]
                  Pre_count[snpnum] =  chr_snp$Pos[snpnum] - chr_gff$startpos[gffnum]
                  SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                  
                  break
                }
              }
            }
          }
          Yann3 = paste(trait_name," Chr",chrnum," SNP process ",snpnum ,"/",snpcount , sep = "")
          print(Yann3)
          snpnum = snpnum + 1
        }
        
        #文件
        gene = data.frame(matrix(nrow = snpcount, ncol = 11))
        #构建输出文件表头
        genetitle = c("SNPID",
                      "Chr",
                      "pos",
                      "p",
                      "MarkerR2",
                      "alpha",
                      "PreGene",
                      "PreCount",
                      "InGene",
                      "PostGene",
                      "PostCount")
        #设置输出文件表头
        colnames(gene) = genetitle
        gene[,1]=SNPID
        gene[,2:6]=chr_snp[,2:6]
        gene[,7]=Pre_gene
        gene[,8]=Pre_count
        gene[,9]=In_gene
        gene[,10]=Post_gene
        gene[,11]=Post_count
        yann4 = chrnum
        grayzhens=paste(trait_name, "_Chr", yann4 , sep = "")
        fwrite(gene, file = paste0(grayzhens, "_SNP_gene.csv"), sep = ",")
        Yann5 = paste(grayzhens , "_SNP_gene.csv has been completed. Summary ",snpcount , sep = "")
        print(Yann5)
        chrnum = chrnum + 1
      }else{
        grayzhens = paste0(trait_name,"_Chr",chrnum," has no significant loci and has been skipped. ",chrnum,"/20")
        print(grayzhens)
        chrnum = chrnum + 1
      }
    }
    if (greyzhens != 1) {
      ####CMplot
      #输入
      dataCM = trait_chr[,1:4]
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
      Yann6 = paste(trait_name,"'s plot has been completed.",sep = "")
      print(Yann6)
    }else{
      yann = paste0(trait_name," has no significant loci. ","Skipped. ")
      print(yann)
    }
  }
}

GWAS_ExtractGenes(2)