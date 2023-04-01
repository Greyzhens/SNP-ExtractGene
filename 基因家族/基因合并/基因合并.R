library(data.table)

##Blast
Blast=fread("/Users/name/Desktop/EFhand基因筛选/BLAST-at-ah/sequenceserver-943_hits.fa",header = F)
class(Blast)
#Blast=as.data.frame(Blast)
#Blast=list(Blast)
name = "arahy.Tifrunner.gnm2.ann1"
Blastname=grep(name,Blast$V1,value = T)
class(Blastname)
#head(Blastname)
Blastname = gsub(".Tifrunner.gnm2.ann1","",Blastname)
  
##keyword
#Calmodulin
Calmodulin=fread("/Users/name/Desktop/EFhand基因筛选/keyword/Calmodulin.fa",header = F)
name = "arahy"
Calmodulinname=grep(name,Calmodulin$V1,value = T)
#Calcium-binding
Calciumbinding=fread("/Users/name/Desktop/EFhand基因筛选/keyword/calcium-binding.fa",header = F)
name = "arahy"
Calciumbindingname=grep(name,Calciumbinding$V1,value = T)
#EFhand
EFhand=fread("/Users/name/Desktop/EFhand基因筛选/keyword/EF-hand.fa",header = F)
name = "arahy"
EFhandname=grep(name,EFhand$V1,value = T)
#IPR002048
IPR002048=fread("/Users/name/Desktop/EFhand基因筛选/keyword/IPR002048.fa",header = F)
name = "arahy"
IPR002048name=grep(name,IPR002048$V1,value = T)
#IPR011992
IPR011992=fread("/Users/name/Desktop/EFhand基因筛选/keyword/IPR011992.fa",header = F)
name = "arahy"
IPR011992name=grep(name,IPR011992$V1,value = T)
#PF13499
PF13499=fread("/Users/name/Desktop/EFhand基因筛选/keyword/PF13499.fa",header = F)
name = "arahy"
PF13499name=grep(name,PF13499$V1,value = T)

#构建数据框
Blastname = as.vector(Blastname)
Calmodulinname = as.vector(Calmodulinname)
Calciumbindingname = as.vector(Calciumbindingname)
EFhandname = as.vector(EFhandname)
IPR002048name = as.vector(IPR002048name)
IPR011992name = as.vector(IPR011992name)
PF13499name = as.vector(PF13499name)
#查找最大值
BlastnameCount=length(Blastname)
CalmodulinnameCount=length(Calmodulinname)
CalciumbindingnameCount=length(Calciumbindingname)
EFhandnameCount=length(EFhandname)
IPR002048nameCount=length(IPR002048name)
IPR011992nameCount=length(IPR011992name)
PF13499nameCount=length(PF13499name)
Colnames=c("Blast",
       "Calmodulin",
       "Calciumbinding",
       "EFhand",
       "IPR002048",
       "IPR011992",
       "PF13499")
Nrow=c(BlastnameCount,
       CalmodulinnameCount,
       CalciumbindingnameCount,
       EFhandnameCount,
       IPR002048nameCount,
       IPR011992nameCount,
       PF13499nameCount)
Max=max(Nrow)
#构建一个数据框
CandidateGenes=data.frame(matrix(nrow=Max, ncol=NNcol))
Blastname = c(Blastname,rep(NA, Max - BlastnameCount))
CandidateGenes[,1]= Blastname
Calmodulinname = c(Calmodulinname,rep(NA, Max - CalmodulinnameCount))
CandidateGenes[,2]= Calmodulinname
Calciumbindingname = c(Calciumbindingname,rep(NA, Max - CalciumbindingnameCount))
CandidateGenes[,3]= Calciumbindingname
EFhandname = c(EFhandname,rep(NA, Max - EFhandnameCount))
CandidateGenes[,4]= EFhandname
IPR002048name = c(IPR002048name,rep(NA, Max - IPR002048nameCount))
CandidateGenes[,5]= IPR002048name
IPR011992name = c(IPR011992name,rep(NA, Max - IPR011992nameCount))
CandidateGenes[,6]= IPR011992name
PF13499name = c(PF13499name,rep(NA, Max - PF13499nameCount))
CandidateGenes[,7]= PF13499name
colnames(CandidateGenes)=Colnames
#输出
write.csv(CandidateGenes,"/Users/name/Desktop/EFhand基因筛选/All.csv")
#整合
data=c(Blastname,
       Calmodulinname,
       Calciumbindingname,
       EFhandname,
       IPR002048name,
       IPR011992name,
       PF13499name)
dataunique =unique(data)
blastunique = unique(Blastname)
print(Blastname)
dataunique = gsub("arahy.","arahy.Tifrunner.gnm2.ann1.",dataunique)
write.csv(dataunique,"/Users/name/Desktop/EFhand基因筛选/All766.txt")


#protein=fread("/Volumes/GrayzhensWork/源文件/Arachis.hypogaea/arahy.Tifrunner.gnm2.ann1.4K0L.protein.faa",header = F)
#protein = gsub(".Tifrunner.gnm2.ann1","",protein)
#protein=as.data.frame(protein)