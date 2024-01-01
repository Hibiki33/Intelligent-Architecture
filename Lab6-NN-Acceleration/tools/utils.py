# -*-coding: utf-8-*-
import numpy as np
import logging
import time

class FLAG(object): 
    '''标记位00、01控制'''

    def flag_00(is_int=False):
        flag_00 = b"\x00\x00\x00\x00"
        if is_int:
            flag_00 = FLAG._int(flag_00)
        return flag_00

    def flag_01(is_int=False):
        flag_01 = b"\x01\x00\x00\x00"
        if is_int:
            flag_01 = FLAG._int(flag_01)
        return flag_01

    def _int(flag):
        return int.from_bytes(flag, 'little')

class Logger(object):
    '''输出日志模块，用于控制台控制日志输出等级'''

    logger = logging.getLogger(__file__)
    logger.setLevel(logging.DEBUG)

    def __init__(self, level='DEBUG'):
        '''设置日志输出等级

            输入：
                level: DEBUG, INFO, WARN, ERROR, CRITICAL
        '''

        # handler设置
        console_handler = logging.StreamHandler()
        console_handler.setLevel(self._get_level(level))
        formatter = logging.Formatter('[%(levelname)s] %(filename)s:%(lineno)d - %(message)s')
        console_handler.setFormatter(formatter)

        Logger.logger.addHandler(console_handler)

    def _get_level(self, level: str):
        log_level = {
            'DEBUG': logging.DEBUG,
            'INFO': logging.INFO,
            'WARNING': logging.WARNING,
            'ERROR': logging.ERROR,
            'CRITICAL': logging.CRITICAL
        }
        return log_level[level.upper()]

    def get_logger() -> logging:
        return Logger.logger

class Timer(object):
    def __init__(self):
        self.total_time = 0.
        self.count = 0

    def start(self):
        self.start_time = time.time()

    def end(self):
        self.end_time = time.time()

        self.count += 1
        self.total_time += self.current_time()

    def current_time(self):
        return self.end_time - self.start_time

    def avg_time(self):
        return self.total_time / self.count


def load_mnist(path):
    '''加载mnist数据
        输入:
            path: mnist.npz的路径
    '''

    with np.load(path, allow_pickle=True) as f:
        x_train, y_train = f['x_train'], f['y_train']
        x_test, y_test = f['x_test'], f['y_test']

        return (x_train, y_train), (x_test, y_test)

