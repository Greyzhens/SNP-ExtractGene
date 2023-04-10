def conda():
    conda1 = "cd /data0/fzliu/miniconda3/bin"
    print(conda1)
    conda2 = "source activate base"
    print(conda2)
    conda3 = ttyname
    conda4 = "screen -S " + conda3
    print(conda4)
    conda5 = "conda activate GWAS"
    print(conda5)

def GML():
    GLM1 = "perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r "
    GLM2 = traitname
    GLM3 = " -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -combine4 -input1 -input2 -input3 -intersect -glm -export "
    GLM4 = filename
    GLM5 = " -runfork1 -runfork2 -runfork3"
    GLM = GLM1 + GLM2 + GLM3 + GLM4 + GLM5
    print(GLM)

def MLM():
    MLM1 = "perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r "
    MLM2 = traitname
    MLM3 = " -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -fork4 -k /data0/fzliu/DB/1781835.272.snp.kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel None -export "
    MLM4 = filename
    MLM5 = " -runfork1 -runfork2 -runfork3 -runfork4"
    MLM = MLM1 + MLM2 + MLM3 + MLM4 + MLM5
    print(MLM)

def CMLM():
    CMLM1 = "perl /data0/fzliu/miniconda3/envs/GWAS/bin/run_pipeline.pl -Xmx64g -Xms4g -fork1 -vcf /data0/fzliu/DB/1781835.272.snp.vcf -fork2 -r "
    CMLM2 = traitname
    CMLM3 = " -fork3 -q /data0/fzliu/DB/1781835.272.16.Q -excludeLastTrait -fork4 -k /data0/fzliu/DB/1781835.272.snp.kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export "
    CMLM4 = filename
    CMLM5 = " -runfork1 -runfork2 -runfork3 -runfork4"
    CMLM = CMLM1 + CMLM2 + CMLM3 + CMLM4 + CMLM5
    print(CMLM)

def tessal():
    print("（1 - GML，2 - MLM，3 - CMLM）")
    type = int(input("请输入1/2/3:"))
    print("************************************")
    print("请将下方内容复制粘贴至ssh中")
    print("************************************")
    conda()
    if type == 1:
        GML()
    else:
        if type == 2:
            MLM()
        else:
            if type == 3:
                CMLM()
            else:
                print("请输入正确的序号")

ttyname = input("请输入虚拟tty名称:")
traitname = input("请输入表型文件路径:")
filename = input("请输入结果文件路径:")
tessal()