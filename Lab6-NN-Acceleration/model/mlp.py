import numpy as np
import os

from .operators import Dense, Quantization, Matmul

class MLPNumpy(object):
    def __init__(self, matmul: str):
        '''
            输入：
                matmul: np, Matmul
        '''
        self.weight_dir = os.path.join(os.getcwd(), 'checkpoint/weight_npy/mlp')
        self.w1 = np.load(os.path.join(self.weight_dir, 'mlp_1_sequential_1_dense_2_MatMul.npy'))
        self.b1 = np.load(os.path.join(self.weight_dir, 'dense_2_bias.npy'))
        self.w2 = np.load(os.path.join(self.weight_dir, 'mlp_1_sequential_1_dense_3_MatMul.npy'))
        self.b2 = np.load(os.path.join(self.weight_dir, 'dense_3_bias.npy'))

        # 量化参数定义
        self.dense1_quantization_params = Quantization(
            scale={'input': 0.003921568859368563, 'weight': 0.007232927717268467, 'output': 0.04273353889584541},
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )
        self.dense2_quantization_params = Quantization(
            scale={'input': 0.04273353889584541, 'weight': 0.007862006314098835, 'output': 0.19821195304393768},
            zero_point={'input': -128, 'weight': 0, 'output': 21}
        )

        if matmul == 'np':
            self.matmul = np.matmul  # 矩阵乘法方式定义
        elif matmul == 'Matmul':
            self.matmul = Matmul()  # 矩阵乘法方式定义
        else:
            raise Exception('matmul type does not exist')

        # [TODO] 实现网络各个层的定义
        # 例：
        self.dense = Dense(
            self.w1,
            self.b1,
            self.dense1_quantization_params,
            matmul=self.matmul
        )

    def forward(self, x):
        # [TODO] 使用定义后的网络层算子实现网络前向传播
        # 例：
        output = self.dense(x)
        return output

    def __call__(self, x):
        return self.forward(x)
