import numpy as np
import struct
import os


def load_mnist(path, kind='train'):
    """
    Loading Mnist dataset from files
    :param path: the pwd where you save the dataset files
    :param kind: 'train' or 't10k'
    :return: images and labels read from files
    """
    # set path
    labels_path = os.path.join(path, '%s-labels.idx1-ubyte' % kind)
    images_path = os.path.join(path, '%s-images.idx3-ubyte' % kind)

    with open(labels_path, 'rb') as l_path:
        # read label file
        magic, n = struct.unpack('>II', l_path.read(8))
        labels = np.fromfile(l_path, dtype=np.uint8)

    with open(images_path, 'rb') as i_path:
        # read image file
        magic, num, rows, cols = struct.unpack('>IIII', i_path.read(16))
        images = np.fromfile(i_path, dtype=np.uint8).reshape(len(labels), 784)

    return images, labels
