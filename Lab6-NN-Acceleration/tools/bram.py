import numpy as np
import mmap
import os, sys
try:
    from .utils import Logger
except:
    from utils import Logger

class BramConfig(object):
    '''BRAM信息配置'''

    def _construct_block_info(address, size, **offset) -> dict:
        '''构造block信息

            Args:
                name: 块名称
                address: 块起始地址
                size: 块大小
                offset: 偏移量，字典

            Return:
                返回字典，包含address, size, offset字段。
                其中offset是一个字典，表示各块内偏移的用途
        '''
        info = {
            'address': address,
            'size': size,
            'offset': offset
        }
        return info


    block_info = {}
    # 构建新逻辑块参考以下写法
    # 若块内偏移量无特殊含义，则约定key为default，值为0，可根据实际需求修改
    block_info['input'] = _construct_block_info(
        address=0x40000000, size=32*1024,
        **{'default': 0x0}
    )
    block_info['weight'] = _construct_block_info(
        address=0x40020000, size=128*1024,
        **{'default': 0x0}
    )
    block_info['output'] = _construct_block_info(
        address=0x40040000, size=32*1024,
        **{'default': 0x0}
    )
    block_info['ir'] = _construct_block_info(
        address=0x40060000, size=4*1024,
        **{'flag': 0x0, 'instr': 0x10}
    )

class BRAM(object):
    '''实现对Bram读写的类，需要先配置BramConfig类'''
    def __init__(self):
        self.block_info = BramConfig.block_info
        self.block_map = self._mapping('/dev/mem')

    def __del__(self):
        os.close(self.file)
        for block_name, block_map in self.block_map.items():
            block_map.close()

    def _mapping(self, path):
        self.file = os.open(path, os.O_RDWR | os.O_SYNC)

        block_map = {}
        for name, info in self.block_info.items():
            # 构建块内存映射
            block_map[name] = mmap.mmap(
                self.file, 
                info['size'],
                flags=mmap.MAP_SHARED,
                prot=mmap.PROT_READ | mmap.PROT_WRITE,
                offset=info['address']
            )
        return block_map
    
    def write(self, data, block_name: str, offset='default'):
        '''写入数据
            由于数据位宽32bit，因此最好以4的倍数Byte写入

            Args：
                data: 输入的数据
                block_name: BramConfig中配置的block_info的key值
                offset: 支持两种输入模式  
                        1. str: BramConfig中配置的offset字典key值
                        2. int: 在block上的偏移量
        '''
        map_ = self.block_map[block_name]

        if isinstance(offset, str):
            offset_ = self.block_info[block_name]['offset'][offset]
        else:
            offset_ = offset
        map_.seek(offset_)

        if isinstance(data, np.ndarray):
            data = data.reshape(-1)
        map_.write(data)

    def read(self, len, block_name, offset='default', dtype=np.uint8) -> np.ndarray:
        '''按字节依次从低字节读取

            Args：
                len: 读取数据长度，单位字节
                block_name: BramConfig中配置的block_info的key值
                offset: 支持两种输入模式  
                        1. str: BramConfig中配置的offset字典key值
                        2. int: 在block上的偏移量
                dtype: 要求数据按相应的格式输出，
                        np.int8, np.int16, np.int32, np.int64,
                        np.uint8, np.uint16, np.uint32, np.uint64
            
            Return:
                np.adarray
        '''

        map_ = self.block_map[block_name]

        if isinstance(offset, str):
            offset_ = self.block_info[block_name]['offset'][offset]
        else:
            offset_ = offset
        map_.seek(offset_)

        # read bytes，运行pl_simulate的时候用这段代码，直接使用read和pl_simulte.py读出来的结果是不正确的
        # data = []
        # for i in range(len):
        #    data.append(map_.read_byte())
        # data = np.array(data, dtype=np.uint8)
        # data.dtype=dtype   # 按dtype整理数据

        # read，和pl侧联调的时候用这段代码
        data = map_.read(len)
        data = np.frombuffer(data, dtype = dtype).copy()

        return data


if __name__ == '__main__':
    Logger('INFO')
    logger = Logger.get_logger()

    # logger.debug("This is a debug log.")
    # logger.info("This is a info log.")
    # logger.warning("This is a warning log.")
    # logger.error("This is a error log.")
    # logger.critical("This is a critical log.")

    bram = BRAM()       # 创建BRAM类实例

    # 向input块中写入int8类型的ndarray
    data_wirte = np.random.randint(-1, 2, (8,4), dtype=np.int8)
    bram.write(data_wirte, 'input')
    data_read = bram.read(data_wirte.size, 'input', dtype=np.int8).reshape(8,4)

    print('write data')
    print(data_wirte)
    print()
    print('read data')
    print(data_read)
    print()

    # 向ir块中写入flag信息
    flag_00 = b"\x00\x00\x00\x00"
    flag_01 = b"\x01\x00\x00\x00"   # 最左侧字节存储在低地址处，往右依次存储在更高地址

    bram.write(flag_00, 'ir', offset='flag')
    # bram.write(flag_00, 'ir', offset=0x0)
    flag_00_read = bram.read(1, 'ir', offset='flag', dtype=np.int8)

    bram.write(flag_01, 'ir', offset='flag')
    # bram.write(flag_01, 'ir', offset=0x0)
    flag_01_read = bram.read(1, 'ir', offset='flag', dtype=np.int8)
    
    print('write flag_00:', flag_00)
    print('read flag_00:', flag_00_read)
    print()
    print('write flag_01:', flag_01)
    print('read flag_01:', flag_01_read)