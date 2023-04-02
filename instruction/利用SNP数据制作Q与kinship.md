# 利用SNP数据制作Q与kinship

## 0 GWAS分析需要四种文件

> snp.vcf——公司给的
>
> kinship——使用plink软件用snp.vcf跑出来的
>
> Q——使用admixture软件用snp.ped跑出来
>
> trait——实际调查统计的数据

## 1 kinship 亲缘关系文件

```shell
#对vcf文件进行排序
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx10g -Xms512m -SortGenotypeFilePlugin -inputFile snp.vcf -outputFile Troot.snp.yh -fileType VCF
#排序后文件计算IBS亲缘关系矩阵
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx10g -Xms512m -importGuess Troot.snp.vcf -KinshipPlugin -method Centered_IBS -endPlugin -export kinship.txt -exportType SqrMatrix
```

## 2 Q 群体结构矩阵

### 2.1 shell脚本

```shell
#Q
#vcf→ped
plink --vcf snp.vcf --allow-extra-chr --recode12 --out snp --autosome-num 27
#CV error值
admixture --cv snp.ped 1 >>log1.txt
admixture --cv snp.ped 2 >>log2.txt
admixture --cv snp.ped 3 >>log3.txt
admixture --cv snp.ped 4 >>log4.txt
admixture --cv snp.ped 5 >>log5.txt
admixture --cv snp.ped 6 >>log6.txt
admixture --cv snp.ped 7 >>log7.txt
admixture --cv snp.ped 8 >>log8.txt
admixture --cv snp.ped 9 >>log9.txt
admixture --cv snp.ped 10 >>log10.txt
admixture --cv snp.ped 11 >>log11.txt
admixture --cv snp.ped 12 >>log12.txt
admixture --cv snp.ped 13 >>log13.txt
admixture --cv snp.ped 14 >>log14.txt
admixture --cv snp.ped 15 >>log15.txt
admixture --cv snp.ped 16 >>log16.txt
admixture --cv snp.ped 17 >>log17.txt
admixture --cv snp.ped 18 >>log18.txt
admixture --cv snp.ped 19 >>log19.txt
admixture --cv snp.ped 20 >>log20.txt
#提取
cat log*.txt | grep CV
#选取最小值，下载Q文件，使用excel构建出Q矩阵
```

### 2.2 Q矩阵文件格式

| "<"Covariate">" |          |          |          |          |          |          |          |          |          |          |          |         |          |          |          |         |
| --------------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | ------- | -------- | -------- | -------- | ------- |
| "<"Trait">"     | Q1       | Q2       | Q3       | Q4       | Q5       | Q6       | Q7       | Q8       | Q9       | Q10      | Q11      | Q12     | Q13      | Q14      | Q15      | Q16     |
| W001            | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 0.00001 | 1.00E-05 | 0.99985  | 0.00001  | 0.00001 |
| W002            | 1.10E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.00E-05 | 1.20E-05 | 6.97E-02 | 1.21E-01 | 1.00E-05 | 1.00E-05 | 0.00001 | 1.00E-05 | 0.809279 | 0.000011 | 0.00001 |

> 第一行只能有A1一个单元格，且必须是"<"Covariate">"
>
> 第二行A2单元格必须是"<"Trait">"，后面为Q(1:x)，其中x值为上方cv值最小的文件名



