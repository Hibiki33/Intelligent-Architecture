import numpy as np
import os, sys

from .operators import Dense, Conv2D, Pooling, Flatten, Quantization, Matmul

class LeNetNumpy(object):
    def __init__(self, matmul: str):
        '''
            输入：
                matmul: np, Matmul
        '''
        self.weight_dir = os.path.join(os.getcwd(), 'checkpoint/weight_npy/lenet')
        self.w1 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_conv2d_Conv2D.npy'))
        self.b1 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_conv2d_BiasAdd;le_net_sequential_conv2d_Conv2D;conv2d_bias.npy'))
        self.w2 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_conv2d_1_Conv2D.npy'))
        self.b2 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_conv2d_1_BiasAdd;le_net_sequential_conv2d_1_Conv2D;conv2d_1_bias.npy'))
        self.w3 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_dense_MatMul.npy'))
        self.b3 = np.load(os.path.join(self.weight_dir, 'dense_bias.npy'))
        self.w4 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_dense_1_MatMul.npy'))
        self.b4 = np.load(os.path.join(self.weight_dir, 'dense_1_bias.npy'))
        self.w5 = np.load(os.path.join(self.weight_dir, 'le_net_sequential_dense_2_MatMul.npy'))
        self.b5 = np.load(os.path.join(self.weight_dir, 'dense_2_bias.npy'))

        # 量化参数定义
        self.conv1_quantization_params = Quantization(
            scale={
                'input': 0.003921568859368563,
                'weight': [0.0024505917, 0.001674911, 0.0031223092, 0.004236928, 0.003395076, 0.004709337],
                'output': 0.00864633172750473
            },
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )
        self.conv2_quantization_params = Quantization(
            scale={
                'input': 0.00864633172750473,
                'weight': [0.00398848, 0.00266276, 0.00303036, 0.00328249, 0.00310459, 0.0035684 , 0.00336372, 0.00307162, 0.00303125, 0.0031391, 0.00287065, 0.00323345, 0.00294385, 0.00381165, 0.00339038, 0.00300488],
                'output': 0.01551073044538498
            },
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )
        self.dense3_quantization_params = Quantization(
            scale={'input': 0.01551073044538498, 'weight': 0.004484474193304777, 'output': 0.03765033185482025},
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )
        self.dense4_quantization_params = Quantization(
            scale={'input': 0.03765033185482025, 'weight': 0.0036943780723959208, 'output': 0.05187484994530678},
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )
        self.dense5_quantization_params = Quantization(
            scale={'input': 0.05187484994530678, 'weight': 0.004274450708180666, 'output': 0.16504107415676117},
            zero_point={'input': -128, 'weight': 0, 'output': -128}
        )

        if matmul == 'np':
            self.matmul = np.matmul  # 矩阵乘法方式定义
        elif matmul == 'Matmul':
            self.matmul = Matmul()  # 矩阵乘法方式定义
        else:
            raise Exception('matmul type does not exist')

        # [TODO] 实现网络各个层的定义
        # 例：
        self.maxpooling = Pooling(ksize=(2,2), method='max')

    def forward(self, x):
        # [TODO] 使用定义后的网络层算子实现网络前向传播
        # 例：
        output = self.maxpooling(x)
        return output

    def __call__(self, x):
        return self.forward(x)