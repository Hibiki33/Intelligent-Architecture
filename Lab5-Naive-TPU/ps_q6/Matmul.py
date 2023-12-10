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

        # print('~~~ recv output ~~~')
        output_arr = self.recv_output((m, p))

        return output_arr

    def send_data(self, data, block_name, offset='default'):
        '''写入input或weight至bram

            通过直接跳地址的方式传入数据
            
            Args:
                data: 要写入的数据
                block_name: input, weight
                offset: 偏移地址名称，默认为default
        '''
        if block_name == 'input':
            # data = self._zero_padding(data, axis=0).T
            m, n = data.shape
            data = data.T.copy(order='C')
            r, c = n, m if m % self.systolic_size == 0 else (m // self.systolic_size + 1) * self.systolic_size

        elif block_name == 'weight':
            # data = self._zero_padding(data, axis=1)
            n, p = data.shape
            data = data.copy(order='C')
            r, c = n, p if p % self.systolic_size == 0 else (p // self.systolic_size + 1) * self.systolic_size

        else:
            raise ValueError('block_name must be input or weight')
        
        # self.bram.write(data, block_name=block_name, offset=offset)
        for i in range(r):
            self.bram.write(data[i], block_name=block_name, offset=i * c)

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
