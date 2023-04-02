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



# Function GWAS_ExtractGenes(WD,data,version)

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

```R

```

## 调用

```R
GWAS_ExtractGenes(WD,data,1/2)
```



# Function QTL_ExtractGenes(WD,data,version)

## 调用

```R
QTL_ExtractGenes(WD,data,1/2)
```

