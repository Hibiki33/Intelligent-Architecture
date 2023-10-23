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


def sigmoid(z):
    """
    Sigmoid function
    :param z: input
    :return: output
    """
    # if z.any() >= 0:
    #     return 1.0 / (1 + np.exp(-z))
    # else:
    #     return np.exp(z) / (1 + np.exp(z))
    return 1.0 / (1.0 + np.exp(-z))


def sigmoid_prime(z):
    """
    Derivative of sigmoid function
    :param z: input
    :return: output
    """
    return sigmoid(z) * (1 - sigmoid(z))


def tanh(z):
    """
    Tanh function
    :param z: input
    :return: output
    """
    return np.tanh(z)


def tanh_prime(z):
    """
    Derivative of tanh function
    :param z: input
    :return: output
    """
    return 1 - tanh(z) ** 2


def relu(z):
    """
    ReLU function
    :param z: input
    :return: output
    """
    return np.maximum(z, 0)


def relu_prime(z):
    """
    Derivative of ReLU function
    :param z: input
    :return: output
    """
    return np.where(z > 0, 1, 0)
