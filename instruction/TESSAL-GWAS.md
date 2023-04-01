# TESSAL-GWAS

# 一、工具

> 工欲善其事，必先利其器

## 1 服务器连接工具

### 1.1 Termius

官网：https://termius.com
优点：shell ftp 二合一
缺点：全英文界面

### 1.2 Xshell + Xftp

官网：https://www.xshell.com/zh/free-for-home-school/（学生版本）
优点：免费，中文界面
缺点：学生版本有限制，曾经被爆出后门窃取数据

### 1.3 PuTTY + FileZilla

PuTTY官网：https://putty.org
 FileZilla官网：https://www.filezilla.cn
优点：免费
缺点；不太好用

### 1.4 FinalShell

官网：http://www.hostbuf.com/t/988.html
优点：免费，国产，二合一
缺点：~~总感觉不正规！~~ 这么多buff，我还能说啥

## 2 代码编写工具

### 2.1 vscode

官网：https://code.visualstudio.com
优点：免费，大厂出品，插件应有尽有，能加载ChatGPT，能轻松打开各种格式大文件。~~OMG，用它！~~
缺点：下载是真的慢！虽然能编辑大部分语言，但是你需要去下载插件，包括中文！

### 2.2 Typora

官网：https://typoraio.cn
优点：一句话，最好用的Markdown编辑器（本文使用此软件编写）
缺点：要钱

### 2.3 Rstudio

官网：https://www.rstudio.com/categories/rstudio-ide/
优点：R语言最好用的编辑器，没有之一
缺点：下载较慢，学习成本高

### 2.4 EmEditor

官网：https://zh-cn.emeditor.com
优点：这玩意能用列表形式打开txt文本
缺点：只有Windows版本

### 2.5 记事本(Windows)、备忘录(Macos)、Word(通用)

仅作为临时编辑用

## 3 TASSEL

官网 https://www.maizegenetics.net/tassel
教程 https://zhuanlan.zhihu.com/p/97144898 Linux
教程 https://blog.sciencenet.cn/blog-2577109-962946.html Windows

# 二、说明

> **1.登陆服务器需要获得老师的许可，账号密码从老师那里获取（或者有批准，也可以找我要）**
>
> **2.本文档全部使用Termius软件进行演示，其他软件使用方法请自行学习**
>
> **3.本文默认你已经拥有GWAS的基础知识，并不会讲解具体原理，仅展示操作步骤**

# 三、操作流程

## 0 视频教程

全基因组关联分析（GWAS）基本内容及实战：https://www.bilibili.com/video/BV1f44y1t7Jk

## 1 进入服务器

### 1.1 Shell

> 使用命令行控制服务器

#### 1.1.1 登录信息输入

该内容请移步(https://zhuanlan.zhihu.com/p/105025848)学习

#### 1.1.2 登录成功界面

```shell
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-186-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


Last login: Mon Mar 27 08:57:59 2023 from 10.110.122.113
fzliu@NX-1:~$ 
```

### 1.2 Ftp

> 能够从服务器上传或下载文件

#### 1.2.1 进入ftp后台

该内容请移步(https://zhuanlan.zhihu.com/p/105025848)学习

#### 1.2.2 文件传输

该内容请移步(https://zhuanlan.zhihu.com/p/105025848)学习

## 2 表型文件

### 2.1 制作表型文件

> 本文使用TESSAL软件跑模型，格式为TESSAL软件要求格式

其格式如下所示

| <Trait> | NAME1 | NAME2 | NAME3 | NAME4 |
| ------- | ----- | ----- | ----- | ----- |
| W001    | 0.83  | 0.67  | 0.76  | 0.85  |
| W002    | 0.93  | 0.73  | 0.51  | 0.68  |
| W003    | 0.94  | 0.79  | 0.73  | 0.96  |
| W004    | 0.80  | 0.63  | 0.50  | 0.88  |
| W005    | 0.83  | 0.51  | 0.57  | 0.94  |

------

| W270 | 0.32 | 0.85 | 0.57 | 0.81 |
| :--- | :--- | :--- | :--- | :--- |
| W271 | 0.46 | 0.79 | 0.60 | 0.88 |
| W272 | 0.84 | 0.84 | 0.87 | 1.00 |

> 注意
> 1.A1单元格必须为<Trait>
> 2.NAMEx为你的表型名称，<u>**不能有中文**</u>，<u>**不能以数字开头**</u>，可以有多个
> 3.课题组的自然群体W020号品种在SNP文件中是缺失的，上表**W020**这一行可删除也可以不删除
> 4.如果有空缺，使用**NN**字符代替
> 5.建议使用数字作为统计值，字符型建议转为数字型(例：发芽——1，未发芽——0)，病情指数用数值（0，1，2，3，4...）
> 6.建议预先进行归一化处理
> 7.表型值变化幅度应较大，过小的表型值变化可能无法完成GWAS分析。（例如只有0或1，极大可能无法完成分析）、
> 8.表型文件使用EXCEL制作，导出选择为**<u>制表符分隔的文本(.txt)</u>**格式

### 2.2 上传表型文件

在 <u>**三 1.2.2**</u> 这一步的基础上，建立一个你自己命名的文件夹**<u>(不要和其他文件夹重名)</u>**，进入文件夹，并将txt文件拖入，等进度条完成**<u>(文件可能过小，瞬间完成，此时只要确认本机文件与服务器上传后文件大小是否一致即可)</u>**，即为上传完成。

## 3 激活conda的GWAS环境

### 3.1 测试是否能运行conda环境

```shell
conda activate GWAS
```

```shell
fzliu@NX-1:~$ conda activate GWAS
Traceback (most recent call last):
  File "/usr/lib/command-not-found", line 27, in <module>
    from CommandNotFound.util import crash_guard
ModuleNotFoundError: No module named 'CommandNotFound'
fzliu@NX-1:~$ 
```

> 如果未出现报错，请移步**<u>3.3</u>**

### 3.2 激活conda环境

```shell
cd /data0/fzliu/miniconda3/bin
source activate base
```

```shell
fzliu@NX-1:~$ cd /data0/fzliu/miniconda3/bin
fzliu@NX-1:~/miniconda3/bin$ source activate base
(base) fzliu@NX-1:~/miniconda3/bin$ 
```

最前面出现**<u>（base）</u>**表示成功进入conda环境

### 3.3 进入GWAS子环境

```shell
conda activate GWAS
```

```shell
(base) fzliu@NX-1:~/miniconda3/bin$ conda activate GWAS
(GWAS) fzliu@NX-1:~/miniconda3/bin$ 
```

## 4 创建一个虚拟tty

### 4.0 何为tty

自己看：https://zhuanlan.zhihu.com/p/447014333
说白了就是为了关闭远程连接软件之后，程序可以保持继续运行

### 4.1 使用screen软件创建tty

```shell
#screen说明书：https://www.jianshu.com/p/420569381e74｜https://www.51cto.com/article/533238.html
screen -S name 
```

> name可变，为你自己定义的名字，纯英文，不能用数字开头，不建议添加符号，本文以**<u>example</u>**作为演示

```shell
(GWAS) fzliu@NX-1:~/miniconda3/bin$ screen -S example
(base) fzliu@NX-1:~/miniconda3/bin$ 
```

> 屏幕清空，并且出现第二行时，tty创建成功

### 4.2 重新进入创建完成的tty

> 这一步多用于查询运行进度，进入后不需要重新进入，关闭远程连接即可

```shell
cd /data0/fzliu/miniconda3/bin
source activate base
conda activate GWAS
screen -r
```

```shell
(GWAS) fzliu@NX-1:~/miniconda3/bin$ screen -r
There is a screen on:
        95606.example   (Attached)
There is no screen to be resumed.
```

> 可以看到***<u>example</u>***的pid为**<u>95606</u>**，这两个都可以作为输入，重新进入环境

```shell
screen -r 95606
#或
screen -r example
```

```shell
(GWAS) fzliu@NX-1:~/miniconda3/bin$ screen -r example
(base) fzliu@NX-1:~/miniconda3/bin$ 
```

> 1.建议使用名称进入
> 2.只有已经关闭所有连接，才可以重新进入

## 5 修改并运行GWAS

```shell
conda activate GWAS
cd /data0/fzliu/NDZ
```

> cd <u>**空格**</u> 绝对路径｜进入你自己创建的文件夹

```shell
(base) fzliu@NX-1:~/miniconda3/bin$ conda activate GWAS
(GWAS) fzliu@NX-1:~/miniconda3/bin$
```

### 5.1 GLM

代码示例：

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf snp.vcf -fork2 -r trait.txt -fork3 -q x.Q -excludeLastTrait -combine4 -input1 -input2 -input3 -intersect -glm -export /data0/fzliu/Temp -runfork1 -runfork2 -runfork3
```

> -fork1 -vcf snp.vcf | 基因型文件，一般为xx.vcf
> -fork2 -r trait.txt | 表型文件，一般为xx.txt
> -fork3 -q x.Q ｜ 群体结构矩阵，一般为xx.Q
> -export ./result/GLM/out ｜输出文件夹
> 下方代码仅需要更改带绝对路径的**<u>表型文件(trait.txt)</u>**和**<u>输出文件夹位置(/data0/fzliu/Temp)</u>**即可

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r trait.txt -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -combine4 -input1 -input2 -input3 -intersect -glm -export /data0/fzliu/Temp -runfork1 -runfork2 -runfork3
```

```shell
(GWAS) fzliu@NX-1:~/Temp$ perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r trait.txt -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -combine4 -input1 -input2 -input3 -intersect -glm -export /data0/fzliu/Temp/GML -runfork1 -runfork2 -runfork3

#运行时部分代码如下，不用仔细看，就是展示一下
[pool-1-thread-1] INFO net.maizegenetics.plugindef.AbstractPlugin - Starting net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4
[pool-1-thread-3] INFO net.maizegenetics.plugindef.AbstractPlugin - Starting net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4
[pool-1-thread-2] INFO net.maizegenetics.plugindef.AbstractPlugin - Starting net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4
[pool-1-thread-3] INFO net.maizegenetics.plugindef.AbstractPlugin -
FileLoadPlugin Parameters
format: Phenotype
sortPositions: false

[pool-1-thread-2] INFO net.maizegenetics.plugindef.AbstractPlugin -
FileLoadPlugin Parameters
format: Phenotype
sortPositions: false

[pool-1-thread-1] INFO net.maizegenetics.plugindef.AbstractPlugin -
FileLoadPlugin Parameters
format: VCF
sortPositions: false

[pool-1-thread-3] INFO net.maizegenetics.analysis.data.FileLoadPlugin - Start Loading File: /data0/fzliu/NDZ/1781835.272.16.Q time: Mar 26, 2023 16:37:4
[pool-1-thread-1] INFO net.maizegenetics.analysis.data.FileLoadPlugin - Start Loading File: /data0/fzliu/NDZ/1781835.272.snp.vcf time: Mar 26, 2023 16:37:4
[pool-1-thread-2] INFO net.maizegenetics.analysis.data.FileLoadPlugin - Start Loading File: /data0/fzliu/NDZ/Ca-4.txt time: Mar 26, 2023 16:37:4
[pool-1-thread-3] INFO net.maizegenetics.analysis.data.FileLoadPlugin - Finished Loading File: /data0/fzliu/NDZ/1781835.272.16.Q time: Mar 26, 2023 16:37:4
[pool-1-thread-2] INFO net.maizegenetics.analysis.data.FileLoadPlugin - Finished Loading File: /data0/fzliu/NDZ/Ca-4.txt time: Mar 26, 2023 16:37:4
[pool-1-thread-3] INFO net.maizegenetics.plugindef.AbstractPlugin - Finished net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4
[pool-1-thread-2] INFO net.maizegenetics.plugindef.AbstractPlugin - Finished net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4
[Thread-4] INFO net.maizegenetics.plugindef.AbstractPlugin - net.maizegenetics.analysis.data.CombineDataSetsPlugin  Citation: Bradbury PJ, Zhang Z, Kroon DE, Casstevens TM, Ramdoss Y, Buckler ES. (2007) TASSEL: Software for association mapping of complex traits in diverse samples. Bioinformatics 23:2633-2635.
[pool-1-thread-2] INFO net.maizegenetics.pipeline.TasselPipeline - net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4: progress: 100%
[pool-1-thread-3] INFO net.maizegenetics.pipeline.TasselPipeline - net.maizegenetics.analysis.data.FileLoadPlugin: time: Mar 26, 2023 16:37:4: progress: 100%
```

> 如有其他报错，请自行翻译报错信息，别因为少个空格不能运行！！！

### 5.2 MLM

代码示例

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf snp.vcf -fork2 -r trait.txt -fork3 -q x.Q -excludeLastTrait -fork4 -k kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel None -export /data0/fzliu/Temp -runfork1 -runfork2 -runfork3 -runfork4
```

> -fork1 -vcf snp.vcf | 基因型文件，一般为xx.vcf
> -fork2 -r trait.txt | 表型文件，一般为xx.txt
> -fork3 -q x.Q ｜ 群体结构矩阵，一般为xx.Q 
> -fork4 -k kinship.txt ｜ 亲缘关系文件，一般为xx.txt
> -export ./result/GLM/out ｜输出文件夹
> 下方代码仅需要更改带绝对路径的**<u>表型文件(trait.txt)</u>**和**<u>输出文件夹位置(/data0/fzliu/Temp)</u>**即可

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r trait.txt -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -fork4 -k /data0/fzliu/DB/1781835.272.snp.kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel None -export /data0/fzliu/Temp/MLM -runfork1 -runfork2 -runfork3 -runfork4
```

### 5.3 CMLM

代码示例

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf snp.vcf -fork2 -r trait.txt -fork3 -q x.Q -excludeLastTrait -fork4 -k kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export /data0/fzliu/Temp -runfork1 -runfork2 -runfork3 -runfork4
```

> -fork1 -vcf snp.vcf | 基因型文件，一般为xx.vcf
> -fork2 -r trait.txt | 表型文件，一般为xx.txt
> -fork3 -q x.Q ｜ 群体结构矩阵，一般为xx.Q 
> -fork4 -k kinship.txt ｜ 亲缘关系文件，一般为xx.txt
> -export ./result/GLM/out ｜输出文件夹
> 下方代码仅需要更改带绝对路径的**<u>表型文件(trait.txt)</u>**和**<u>输出文件夹位置(/data0/fzliu/Temp)</u>**即可

```shell
perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r trait.txt -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -fork4 -k /data0/fzliu/DB/1781835.272.snp.kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export /data0/fzliu/Temp/CMLM -runfork1 -runfork2 -runfork3 -runfork4
```

### 5.4 Tips

> ctrl+c 组合键能终止程序运行

## 6 检查与提取数据

> 本文仅以MLM模型，多表型数据演示

### 6.1 确定结果文件

代码如下

```shell
cd /data0/fzliu/NDZ/result/MLM
ls -lhtra
```

```shell
(GWAS) fzliu@NX-1:~/NDZ/result/MLM$ cd /data0/fzliu/NDZ/result/MLM
(GWAS) fzliu@NX-1:~/NDZ/result/MLM$ ls -lhtra
-rw-rw-r-- 1 fzliu fzliu 4.5K Mar  5 03:05 1.txt
-rw-rw-r-- 1 fzliu fzliu 4.6K Mar  5 03:05 2.txt
-rw-rw-r-- 1 fzliu fzliu 4.6K Mar  5 03:05 4.txt
-rw-rw-r-- 1 fzliu fzliu 4.6K Mar  5 03:05 3.txt
-rw-rw-r-- 1 fzliu fzliu 773M Mar  5 03:06 5.txt
-rw-rw-r-- 1 fzliu fzliu 587M Mar  5 03:07 6.txt
```

通过观察文件大小，最大文件为**<u>5.txt</u>**，其为结果文件

使用下列代码确定

```
head -3 5.txt
```

```shell
(GWAS) fzliu@NX-1:~/NDZ/result/MLM$ head -3 5.txt
Trait   Marker  Chr     Pos     df      F       p       add_effect      add_F   add_p   dom_effect      dom_F   dom_p   errordf MarkerR2        Genetic Var     Residual Var    -2LnLikelihood
CaHK1   None                    0       NaN     NaN     NaN     NaN     NaN     NaN     NaN     NaN     256     NaN     0.01023 0.01606 -2.6326E2
CaHK1   S1_87344        1       87344   1       0.11348 0.73656 NaN     NaN     NaN     NaN     NaN     NaN     222     5.0667E-4       0.01023 0.01606-2.6326E2
```

> 说明
>
> 1. 第一列<Trait>为表型名称
> 2. 第二列<Marker>为SNP名称
> 3. 第三列<Chr>为染色体名称
> 4. 第四列<Pos>为染色体位置名称
> 5. 第七列<p>为p值
> 6. 第十五列<MarkerR2>为R^2^

