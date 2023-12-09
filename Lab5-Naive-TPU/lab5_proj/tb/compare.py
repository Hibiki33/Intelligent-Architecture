flag = 0
with open('./test1/MMout.txt','r') as fpy1, open('./test2/MMout.txt','r') as fpy2, open('tb_MMout.txt','r') as ftb:
    lpy1 = fpy1.readlines()
    lpy2 = fpy2.readlines()
    count = 0
    for lipy in lpy1:
        litb = ftb.readline()
        if lipy.replace(',\n','') != litb.strip():
            flag = 1
            print('test1:',count,lipy.replace(',\n',''),litb.strip())
        count += 1
    print('-'*20)
    count = 0
    for lipy in lpy2:
        litb = ftb.readline()
        if lipy.replace(',\n','') != litb.strip():
            flag = 1
            print('test2:',count,lipy.replace(',\n',''),litb.strip())
        count += 1

if not flag:
    print('data right')