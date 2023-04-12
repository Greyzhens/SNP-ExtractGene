# Input

## 1 WD

**WD** 设置输出文件的路径

## 2 data

**data** 结果文件「GWAS/QTL」

# Function Filepath(WD)

> Filepath(WD) 用来创建输出文件夹

## 脚本

```R
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
```



# Function GWAS_ExtractGenes(version)

> 仅用于处理TESSAL软件生成的GWAS结果文件
>
> 仅适用于提取 花生(Arachis hypogaea) 「可选择 一代 或 二代」
>
> 输出文件包括：单表型结果文件(包含snpID，chr，pos，p，alpha)，表型-染色体-显著性位点-基因文件，表型的曼哈顿图，表型的QQ图

## 输入

WD 在上方设置

data 在上方设置

version 1 or 2 「输入数字」

## 脚本

请查看SNP-ExtractGene-V3.0.R

## 调用

```R
GWAS_ExtractGenes(1 or 2)
```



# Function QTL_ExtractGenes(version)

## 调用

```R
QTL_ExtractGenes(1 or 2)
```

# Update

V0 该版本为分切版本，并未整合为一个文件，因此不上线此版本

V1 该版本首次将所有分析步骤合并为一个文件，但各个函数彼此独立存在。

V2 该版本将第一版所有函数整合为一个函数即GWAS_ExtractGenes()

V3 该版本升级了将所有输出语句输入output.txt中，但运行时无任何提醒

V4 该版本属于V2的升级版，修复了结果文件中 1，2，3占位的问题，现使用空值代替。升级了单染色体曼哈顿图输出

V5 该版本升级了输出文件格式，添加了基因功能注释。添加了基因分型。

# 推荐

个人pc推荐使用第四版

服务器推荐使用第四版

服务器使用时，需要将文件路径改好，打包为xx.R，上传至服务器

随后使用下方代码进入绘图环境

```shell
cd /data0/fzliu/miniconda3/bin
source activate base
```

然后下方二选一

```shell
conda activate GWAS
或
conda activate CMplot
```

在环境中，使用下方代码运行文件。（注意文件绝对路径）

```shell
 Rscript xx.R
```

