# GFF3_Split_Chr

> 文件：==GFF3_Split_Chr.R==
> 作用：这个小工具是用来将gff3文件中的内容按照20条染色体拆开，以获得更小体积的文件。
> 特性：支持直接导入gz格式文件

## 使用方法

### 1 更改部分

```R
wd=("/Users/ningdongzhen/Desktop/Github/SNP-ExtractGene/GFF/gnm2.ann1.4K0L/")
filename=("4K0L.gff3.gz")
#例：arahy.Tifrunner.gnm1.Arahy.x，chr1为"arahy.Tifrunner.gnm1.Arahy."。chr2为"x"
chr1=("arahy.Tifrunner.gnm2.Arahy.")
chr2=c("01","02","03","04","05",
          "06","07","08","09","10",
          "11","12","13","14","15",
          "16","17","18","19","20")
```

> wd：文件路径
> filename：文件名
> Chr1/2:提取字符串

### 2 运行部分

> 打开==GFF3_Split_Chr.R==
>
> 按照步骤1更改，完成后全选运行
>
> 主函数：==GFF3_Split_Chr()==

## 尾巴

> 提供花生基因组文件

## 作者

Grayzhens
Yann



