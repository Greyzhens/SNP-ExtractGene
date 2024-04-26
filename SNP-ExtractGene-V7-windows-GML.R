
#仅用于处理TESSAL软件生成的GWAS结果文件
#仅适用于提取 花生(Arachis hypogaea) 一、二代测序的基因数据
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
# 提示用户输入文件的完整路径
file_path <- "G:/学术/研究项目/花生荚果籽仁耐低钙相关基因定位研究/GWAS/结果/GP/GWAS结果/GP-3/CMLM/CaGP-CMLM5.txt"

# 读取用户输入的文件路径中的数据
data <- fread(file_path, header = FALSE)

# 使用dirname()函数从完整路径中提取出文件所在的目录路径（WD）
WD <- dirname(file_path)

# 显示data和WD
#print(data)
#print(WD)
# 此时，data包含了GWAS结果，WD包含了文件所在的目录路径
data2 = data[which(data$V7!=0)]
data=data2

#gff文件
gff_gnm = c("G:/学术/资源库/PeanutBaseData/GFF3/gnm1.ann1.CCJH/gnm1.ann1.CCJH.gene_models_main.gff3",
            "G:/学术/资源库/PeanutBaseData/GFF3/gnm2.ann1.4K0L/gnm2.ann1.4K0L.gene_models_main.gff3")

hapmap = fread("G:/学术/资源库/自然群体/1781835-SNP/all.snp.1781835.W272.hmp.txt" , header = T)


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
  
  #构建gff文件
  gff3 = fread(gff_gnm[version],header = F)
  
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
    #phenotype_out 输出文件 包含R方 1-20全部
    phenotype_out=phenotype[,c(2,3,4,6,7)]
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
      
      #提取单染色体全部位点
      Yann2 = paste("S", chrnum,"_", sep = "")
      chr = trait_chr[grepl(Yann2, trait_chr$Marker), ]
      chr = as.data.frame(chr)
      #单染色体CMplot输入文件
      dataCM = chr[,1:4]
      #提取单染色体高显著性位点
      alpha = -log10(as.numeric(chr$p))
      alpha = format(alpha, scientific = FALSE)
      alpha = as.numeric(alpha)
      chr = cbind(chr, alpha)
      #只提取(5,12)区间内的值
      chr = subset(chr, alpha >= 5 & alpha <= 12)
      chr$Pos=as.numeric(chr$Pos)
      chr = na.omit(chr)

      #构建gff文件
      if (chrnum < 10) {
        Yannnn = paste("arahy.Tifrunner.gnm",version,".Arahy.0", chrnum, sep = "")
      }else{
        Yannnn = paste("arahy.Tifrunner.gnm",version,".Arahy.", chrnum, sep = "")
      }
      
      gffchr = gff3[grepl(Yannnn,gff3$V1),]
      
      #纯基因文件
      gffgene = gffchr[grepl("gene",gffchr$V3),]
      gfftitle = c("chr","maker","type","startpos","endpos","1","2","3","message")
      colnames(gffgene) = gfftitle
      
      #外显子判断
      gffexon = gffchr[grepl("exon",gffchr$V3),]
      colnames(gffexon) = gfftitle
      
      #基因名称
      gffname = gffgene$message
      GeneName = sub(paste0('.*ann1.(.*);Name=.*'), '\\1', gffgene$message)
      chr_gff = cbind(gffgene, GeneName)
      
      #基因注释
      gffnote = gffgene$message
      GeneNote = sub(".*Note=", "", gffgene$message)
      chr_gff = cbind(chr_gff, GeneNote)
      gffcount = nrow(chr_gff)
      
      #判断是否有显著性位点
      if (nrow(chr) != 0) {#有显著性位点则输出提示
        grayzhens = paste0(trait_name,"'s ","highly significant loci on " ,"Chr ",chrnum," have been extracted.")
        print(grayzhens)
        grayzhens = paste0(trait_name," chr process ",chrnum," /20")
        print(grayzhens)
        greyzhens = greyzhens + 1
        chr_snp = chr
        fwrite(chr_snp,"chr_snp.csv")
        snpcount = nrow(chr_snp) 
        
        filename = paste0(trait_name,"-Chr",chrnum)
        
        ##单染色体绘图##
        CMplot(dataCM, 
               plot.type=c("m","q"),#同时输出曼哈顿图和QQ图
               LOG10=TRUE, 
               ylim=c(0,12),#这里限制y轴上限
               threshold=c(1e-5,2.806096e-8),#设置标准线 6 和 8
               threshold.lty=c(1,2),
               threshold.lwd=c(1,1), 
               threshold.col=c("black","grey"), 
               amplify=F,bin.size=1e6,
               chr.den.col=c("darkgreen", "yellow","red"),
               signal.col=c("red","green"),
               signal.cex=c(1,1),
               signal.pch=c(19,19),
               file="jpg",#输出图片的格式
               file.name=filename,
               dpi=2000,#输出图片的大小
               file.output=TRUE,
               verbose=TRUE)
        
        snpnum = 1
        #构建输出的三列基因
        SNPID = c(1:snpcount)
        
        Phenotype = c(1:snpcount)
        Phenotype[] = trait_name
        
        In_gene = c(1:snpcount)
        In_exon = c(1:snpcount)
        In_note = c(1:snpcount)
        
        #
        In_exon[] = ""
        
        Pre_gene = c(1:snpcount)
        Pre_note = c(1:snpcount)
        Pre_count = c(1:snpcount)
        
        promoter = c(1:snpcount)
        
        #
        promoter[] = ""
        
        Post_gene = c(1:snpcount)
        Post_note = c(1:snpcount)
        Post_count = c(1:snpcount)
        
        genetic_typing_out = data.frame(matrix(nrow = snpcount, ncol = 282))
        gtitle = colnames(hapmap)
        colnames(genetic_typing_out) = gtitle
        
        for (snpnum in 1:snpcount) {
          
          gffnum = 1
          for (gffnum in 1:gffcount) {
            if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum]) {
              #在最前端 只有Post_gene
              
              Pre_gene[snpnum] = ""
              Pre_note[snpnum] = ""
              Pre_count[snpnum] = ""
              
              In_gene[snpnum] = ""
              In_note[snpnum] = ""
              
              Post_gene[snpnum] = chr_gff$GeneName[gffnum]
              Post_note[snpnum] = chr_gff$GeneNote[gffnum]
              
              ChaZhi = chr_gff$startpos[gffnum+1] - chr_snp$Pos[snpnum]
              Post_count[snpnum] = ChaZhi
              
              if (ChaZhi >= 0 & ChaZhi <= 2000) {
                promoter[snpnum] = "In the promoter region"
                }else{
                  promoter[snpnum] = "Not in the promoter region"
                  }  
              
              
              
              SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
              
              break
            }else{
              if (chr_snp$Pos[snpnum] <= chr_gff$endpos[gffnum]) {
                #基因内
                
                Pre_gene[snpnum] = ""
                Pre_note[snpnum] = ""
                Pre_count[snpnum] = ""
                
                In_gene[snpnum] = chr_gff$GeneName[gffnum]
                In_note[snpnum] = chr_gff$GeneNote[gffnum]
                
                geneexon = gffexon[grepl(chr_gff$GeneName[gffnum],gffexon$message),]
                geneexoncount = nrow(geneexon)
                exonnum = 1
                
                for (e in 1:geneexoncount) {
                  if (chr_snp$Pos[snpnum] >= geneexon$startpos[exonnum] & chr_snp$Pos[snpnum] <= geneexon$endpos[exonnum]) {
                    grayzhens = paste0(chr_gff$GeneName[gffnum],"在外显子中")
                    print(grayzhens)
                    exon = 1
                  }else{
                    exon = 0
                    exonnum = exonnum + 1
                  }
                }
                
                if (exon == 1) {
                  In_exon[snpnum] = "Exon"
                }else{
                  In_exon[snpnum] = "Intron"
                }
                
                exon = 0

                
                Post_gene[snpnum] = ""
                Post_note[snpnum] = ""
                Post_count[snpnum] = ""
                
                SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                
                break
              }else{
                if (gffnum != gffcount) {
                  if (chr_snp$Pos[snpnum] < chr_gff$startpos[gffnum+1]) {#1
                    #基因间
                    
                    Pre_gene[snpnum] = chr_gff$GeneName[gffnum]
                    Pre_note[snpnum] = chr_gff$GeneNote[gffnum]
                    Pre_count[snpnum] =  chr_snp$Pos[snpnum] - chr_gff$startpos[gffnum]
                    
                    In_gene[snpnum] = ""
                    In_note[snpnum] = ""
                    
                    
                    Post_gene[snpnum] = chr_gff$GeneName[gffnum+1]
                    Post_note[snpnum] = chr_gff$GeneNote[gffnum+1]
                    
                    ChaZhi = chr_gff$startpos[gffnum+1] - chr_snp$Pos[snpnum]
                    Post_count[snpnum] = ChaZhi
                    
                    if (ChaZhi >= 0 & ChaZhi <= 2000) {
                      promoter[snpnum] = "In the promoter region"
                    }else{
                      promoter[snpnum] = "Not in the promoter region"
                    }
                    
                    SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                    
                    break
                  }else{#1
                    gffnum = gffnum + 1
                  }
                }else{
                  #在最后端 只有Pre_gene
                  
                  Pre_gene[snpnum] = chr_gff$GeneName[gffnum]
                  Pre_note[snpnum] = chr_gff$GeneNote[gffnum]
                  Pre_count[snpnum] =  chr_snp$Pos[snpnum] - chr_gff$startpos[gffnum]
                  
                  In_gene[snpnum] = ""
                  In_note[snpnum] = ""
                  
                  Post_gene[snpnum] = ""
                  Post_note[snpnum] = ""
                  Post_count[snpnum] = ""
                  
                  SNPID[snpnum] = paste0(trait_name,"-Chr",chrnum,"-",chr_snp$Pos[snpnum])
                  
                  break
                }
              }
            }
          }
          Yann3 = paste(trait_name," Chr",chrnum," SNP process ",snpnum ,"/",snpcount , sep = "")
          print(Yann3)
          
          #基因分型
          Gray = paste0("S",chrnum,"_",chr_snp$Pos[snpnum])
          lengthhapmap = nrow(hapmap)
          genetic_typing = hapmap[grepl(Gray,hapmap$`rs#`),]
          hapmapnum = 1
          colhapmap = ncol(hapmap)
          for (x in 1:lengthhapmap) {
            if (Gray == hapmap$`rs#`[hapmapnum]) {
              genetic_typing = hapmap[hapmapnum,1:colhapmap]
              break
            }else{
              hapmapnum = hapmapnum + 1
            }
          }
          
          genetic_typing_out[snpnum,1:colhapmap] = genetic_typing
          
        }
        
        #文件
        gene = data.frame(matrix(nrow = snpcount, ncol = 17))
        #构建输出文件表头
        genetitle = c("Trait",
                      "SNPID",
                      "Chr",
                      "pos",
                      "p",
                      "MarkerR2",
                      "alpha",
                      "PreGeneName",
                      "PreGeneNote",
                      "PreGeneCount",
                      "InGeneName",
                      "InGeneExon",
                      "InGeneNote",
                      "Promoter-PostGene",
                      "PostGeneName",
                      "PostGeneNote",
                      "PostGeneCount")
        #设置输出文件表头
        colnames(gene) = genetitle
        gene[,1]=Phenotype
        
        gene[,2]=SNPID
        gene[,3:7]=chr_snp[,2:6]
        
        gene[,8]=Pre_gene
        gene[,9]=Pre_note
        gene[,10]=Pre_count
        
        gene[,11]=In_gene
        gene[,12]=In_exon
        gene[,13]=In_note
        
        gene[,14]=promoter
        gene[,15]=Post_gene
        gene[,16]=Post_note
        gene[,17]=Post_count
        
        
        gene = cbind(gene,genetic_typing_out)
        
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
      filename = trait_name
      
      ##表型曼哈顿图
      CMplot(dataCM, 
             plot.type=c("m","q"),#同时输出曼哈顿图和QQ图
             LOG10=TRUE, 
             ylim=c(0,12),#这里限制y轴上限
             threshold=c(1e-5,2.806096e-8),#设置标准线 6 和 8
             threshold.lty=c(1,2),
             threshold.lwd=c(1,1), 
             threshold.col=c("black","grey"), 
             amplify=F,bin.size=1e6,
             chr.den.col=c("darkgreen", "yellow","red"),
             signal.col=c("red","green"),
             signal.cex=c(1,1),
             signal.pch=c(19,19),
             file="jpg",#输出图片的格式
             file.name=filename,
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

#函数 ALL_SNP合并所有SNP结果文件
ALL_SNP = function(){
  
  traitname = data$V1
  traitname = unique(traitname)[-1]
  traitcount = length(traitname)
  
  
  FilePath()
  
  files = list.files()
  
  # 定义结果数据框
  result <- data.frame()
  
  # 循环处理每个文件
  for (file in files) {
    # 判断文件名是否包含 SNP 字符
    if (grepl("SNP", file)) {
      # 读取文件内容
      content <- read.csv(file, header = TRUE)
      
      # 将文件内容合并到结果数据框中
      result <- rbind(result, content)
    }
  }
  
  # 输出结果数据框
  allsnpnum = nrow(result)
  yann = paste0("SNP结果文件已合并并输出为ALL_SNP_gene.csv。",traitcount,"个表型共检索出",allsnpnum ,"个SNP")
  yannn = paste0(traitcount,"traits_",allsnpnum ,"SNP_gene.csv")
  fwrite(result , yannn)
  print(yann)
}

#GWAS结果提取工具
GWAS_ExtractGenes(2)
#合并所有SNP
ALL_SNP()
