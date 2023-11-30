
from bram import BRAM, BramConfig
from enum import Enum
import logging
import numpy as np

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

def main(logger):

    class FlagAddr(Enum):
        #BM = 0x00
        #IR = 0x04
        #RRE = 0x08
        #WRE = 0x0c
        FLAG = 0x00
        INSTR = 0x10
    
    class FLAG: 

        flag_00 = b"\x00\x00\x00\x00"
        flag_01 = b"\x01\x00\x00\x00"
        #flag_10 = b"\x10\x00\x00\x00"

        flagaddr = FlagAddr

        def __init__(self):
            
            self.bram = BRAM()
            self.clean_flag()
        
        def clean_flag(self):
            self.bram.write( FLAG.flag_00 , block_name = "ir" , offset = 'flag' ) 
        
        def read_flag(self)->int:
            flag = self.bram.read( 1 , block_name = "ir" , offset = 'flag' )[0]
            return flag
        
        def wait_flag(self):
            value = -1
            while( value != 1):
                value = self.read_flag()

    flag = FLAG()
    bram = BRAM()

    # 补零的依据，脉动阵列大小
    systolic_size = 4 # 脉动阵列大小

    while(True):
        
        # input( "wait for next cycle")

        logger.info("<<<<<<<<< new iteration >>>>>>>>>>")

        #等待指令

        flag.wait_flag()

        instr = bram.read(8, block_name='ir', offset='instr', dtype=np.uint16)
        instr_input_M = int(instr[0])
        instr_weight_P = int(instr[1])
        instr_input_N = int(instr[2])
        instr_null = int(instr[3])

        # 数据补过零，因此这里读取也要相应改变
        instr_input_M_zero = instr_input_M
        instr_weight_P_zero = instr_weight_P
        if instr_input_M % systolic_size != 0:
            instr_input_M_zero = (instr_input_M // systolic_size + 1) * systolic_size
        if instr_weight_P % systolic_size != 0:
            instr_weight_P_zero = (instr_weight_P // systolic_size + 1) * systolic_size

        logger.debug( "instr M,P,N:{},{},{}".format(  instr_input_M , instr_weight_P , instr_input_N ) ) 

        #读地址
        logger.debug( "read input" )
        input_0 = bram.read( instr_input_M_zero * instr_input_N  , block_name = "input" , dtype = np.uint8 )
        input_0 = input_0.reshape( instr_input_N  , instr_input_M_zero ).T
        input_0 = input_0[:instr_input_M, :]

        logger.debug( "read weight" )
        weight_0 = bram.read( instr_weight_P_zero * instr_input_N  , block_name = "weight" , dtype = np.int8 )
        weight_0 = weight_0.reshape( instr_input_N , instr_weight_P_zero )
        weight_0 = weight_0[:, :instr_weight_P] 

        output = np.matmul( input_0.astype(np.uint32) , weight_0.astype(np.int32) )

        #执行
        logger.debug("inputs: {}".format(input_0))
        logger.debug("weights: {}".format(weight_0))
        logger.debug("output: {}".format(output))

        #output = output.reshape(-1)
        output = output.astype( np.int32 )
        logger.debug("output dtype: {}, shape: {}".format( output.dtype, output.shape ))
        # output.dtype = np.uint8

        output  = output.copy()
        bram.write( output , block_name = "output" )

        flag.clean_flag()



if __name__ == "__main__":
    Logger('DEBUG')
    # Logger('INFO')
    logger = Logger.get_logger()
    main(logger)
