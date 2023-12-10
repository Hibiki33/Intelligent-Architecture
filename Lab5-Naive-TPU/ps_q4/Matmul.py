# -*-coding: utf-8-*-

import numpy as np
from bram import BRAM, BramConfig


class Matmul(object):
    '''矩阵乘法
        Args: uint8, (m, n)
        Args: int8, (n, p)
    '''

    def __init__(self):
        self.systolic_size_i = 8
        self.systolic_size_w = 16
        self.bram = BRAM()

    def __call__(self, input: np.uint8, weight: np.int8):
        # print('~~~ send data ~~~')
        self.send_data(input, 'input')
        self.send_data(weight, 'weight')

        m, n = input.shape
        n, p = weight.shape
        # print('~~~ send instr ~~~')
        self.send_instr(m, p, n)
        self.send_flag()
        self.wait_flag()

        # rint('~~~ recv output ~~~')
        output_arr = self.recv_output((m, p))

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
        if block_name == 'input':
            data = self._zero_padding(data, axis=0).T
            # print('input data: \n', data)
        elif block_name == 'weight':
            data = self._zero_padding(data, axis=1)
            # print('weight data: \n', data)
        else:
            raise ValueError('block_name must be input or weight')
        
        self.bram.write(data, block_name=block_name, offset=offset)

    def send_instr(self, m, p, n):
        '''构建并发送指令

            两个矩阵shape分别为(m,n) x (n,p)
        '''
        # 63:48  47:32  31:16  15:0
        #  null      N      P     M
        # little end, unsigned
        ir = 0
        ir <<= 16
        ir += n
        ir <<= 16
        ir += p
        ir <<= 16
        ir += m
        instr = ir.to_bytes(8, byteorder='little', signed=False)
        # print('instr: \n', instr)
        self.bram.write(instr, block_name='ir', offset='instr')

    def send_flag(self):
        '''发送flag=1信号'''
        flag = b"\x01\x00\x00\x00"
        self.bram.write(flag, 'ir', offset='flag')
        
    def recv_output(self, output_shape: tuple):
        '''接收结果

            Args:
                output_shape: 输出的shape，类型tuple

            Return:
                output_arr: shape为output_shape的np.ndarray
        '''
        row, col = output_shape
        output_arr = self.bram.read(row * col * 4, block_name='output', dtype=np.int32).reshape(row, col)
        # print('output data: \n', output_arr)

        return output_arr
    
    def _zero_padding(self, data, axis=0):
        '''补零函数

            Args:
                data: 要补零的数据
                axis: 补零的方向，0为行方向，1为列方向

            Return:
                补零后的数据
        '''
        if axis == 0:
            if data.shape[0] % self.systolic_size_i != 0:
                data = np.vstack((data, np.zeros((self.systolic_size_i - data.shape[0] % self.systolic_size_i, data.shape[1]), dtype=data.dtype)))
        elif axis == 1:
            if data.shape[1] % self.systolic_size_w != 0:
                data = np.hstack((data, np.zeros((data.shape[0], self.systolic_size_w - data.shape[1] % self.systolic_size_w), dtype=data.dtype)))
        else:
            raise ValueError('axis must be 0 or 1')
        
        return data
        
    def read_flag(self):
        '''读取flag信号'''
        flag = self.bram.read(1, block_name='ir', offset='flag')
        return flag
    
    def wait_flag(self):
        '''等待flag=1信号'''
        value = 1
        while value != 0:
            value = self.read_flag()[0]


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
