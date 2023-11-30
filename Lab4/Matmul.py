# -*-coding: utf-8-*-
import numpy as np
from bram import BRAM, BramConfig

class Matmul(object):
    '''矩阵乘法
        Args: uint8, (m, n)
        Args: int8, (n, p)
    '''

    def __init__(self):
        self.systolic_size = 4 # 脉动阵列大小
        pass

    def __call__(self, input: np.uint8, weight: np.int8):
        self.send_data(input, 'input')
        self.send_data(weight, 'weight')
        output_arr = self.recv_output((None, None))
        return output_arr

    def send_data(self, data, block_name, offset='default'):
        '''写入input或weight至bram

            假设两个矩阵分别是(m,n) x (n,p), m和p的维度需要补全至self.systolic_size的倍数，
            并且写入时需要按照补零的方向写入，例如：  
                1. 矩阵(m, n)是m补零，则m个m个写入BRAM中。（行方向补零，列方向写入）  
                2. 矩阵(n, p)是p补零，则p个p个写入BRAM中。（列方向补零，行方向写入）
            
            Args:
                data: 要写入的数据
                block_name: input, weight
                offset: 偏移地址名称，默认为default
        '''
        pass

    def send_instr(self, m, p, n):
        '''构建并发送指令

            两个矩阵shape分别为(m,n) x (n,p)
        '''
        pass

    def send_flag(self):
        '''发送flag=1信号'''
        pass
        
    def recv_output(self, output_shape: tuple):
        '''接收结果

            Args:
                output_shape: 输出的shape，类型tuple

            Return:
                output_arr: shape为output_shape的np.ndarray
        '''
        output_arr = None
        return output_arr


if __name__ == '__main__':
    matmul = Matmul()

    ############ matrix 1
    x = np.random.randint(0, 2, (4,8), dtype=np.uint8)
    w = np.random.randint(-1, 2, (8,4), dtype=np.int8)

    std_output = np.matmul(x, w)
    output = matmul(x, w)

    # err = output - std_output
    assert (output == std_output).all(), 'error'
    print('~~~ demo1 pass ~~~')

    ############ matrix 2
    x = np.random.randint(0, 5, (15,20), dtype=np.uint8)
    w = np.random.randint(-5, 5, (20,10), dtype=np.int8)

    std_output = np.matmul( x , w )
    output = matmul(x, w)

    # err = output - std_output
    assert (output == std_output).all(), 'error'
    print('~~~ demo2 pass ~~~')