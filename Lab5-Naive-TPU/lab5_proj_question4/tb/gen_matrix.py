import numpy as np
import random

# 注意M*N和N*P不应过大，否则BRAM_FM64和BRAM_WM128地址有可能超位宽引起出错。
# 
# 问题1：依据工程中BRAM_FM64和BRAM_WM128的位宽、地址深度，写出M、N、P取值的限制。
# 问题2：依据mlp和lenet模型，计算当前BRAM_FM32、BRAM_WM32、BRAM_FM64和BRAM_WM128大小是否足够。
#       注意，BRAM_FM32、BRAM_WM32指Block Design中例化的，不是MM_top_tb.v中的tb_ram。
#       
# 拓展训练：修改MM_top_tb.v，利用$random函数在MM_top_tb.v中产生随机的M、N、P，依据产生的M、N、P来产生随机输入矩阵。
#          之后，计算两个随机矩阵相乘的结果（三层for循环嵌套，注意不需要有时钟限制，仿真表现为立马算出结果），将结果暂存。
#          将随机矩阵送入MM_top模块，待得到运算结果，和暂存的结果进行比较，打印出是否出错等必要信息。
#          重复以上过程，不停地产生随机输入进行计算和结果比对，对MM_top模块进行充分的、随机化的验证。

M1 = 784
N1 = 25
P1 = 6

M2 = 17
N2 = 33
P2 = 25

def main(M,N,P,s):

    pa = [[random.randint(0,255) for i in range(M)] for j in range(N)]
    pb = [[random.randint(-127,127) for i in range(P)] for j in range(N)]

    a = np.transpose(np.matrix(pa)) # 转置
    b = np.matrix(pb)

    # print(pa)
    # print(a)
    # print(pb)
    # print(b)
    # print(a*b)

    with open(s+'FM.txt','w') as fw:
        for i in pa:
            for j in range((M-1)//8+1):
                fw.write(str(i[j*8])+',')
                try:
                    fw.write(str(i[j*8+1])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+2])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+3])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+4])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+5])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+6])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*8+7])+',\n')
                except:
                    fw.write('0,\n')

    with open(s+'WM.txt','w') as fw:
        for i in pb:
            for j in range((P-1)//16+1):
                fw.write(str(i[j*16])+',')
                try:
                    fw.write(str(i[j*16+1])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+2])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+3])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+4])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+5])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+6])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+7])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+8])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+9])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+10])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+11])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+12])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+13])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+14])+',')
                except:
                    fw.write('0,')
                try:
                    fw.write(str(i[j*16+15])+',\n')
                except:
                    fw.write('0,\n')

    c = a*b
    # print(c)
    with open(s+'MMout.csv','w') as fw:
        for i in c.tolist():
            fw.write(','.join(str(c) for c in i)+',\n')

    with open(s+'MMout.txt','w') as fw:
        for i in c.tolist():
            fw.write(',\n'.join(str(c) for c in i)+',\n')

    with open(s+'para.txt','w') as fw:
        fw.write(str(M)+'\n')
        fw.write(str(N)+'\n')
        fw.write(str(P)+'\n')

if __name__ == '__main__':
    main(M1,N1,P1,'test1/')
    main(M2,N2,P2,'test2/')