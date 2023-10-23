
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import gzip
import os

import numpy
import tensorflow as tf
from six.moves import urllib
from six.moves import xrange  # pylint: disable=redefined-builtin

SOURCE_URL = 'http://yann.lecun.com/exdb/mnist/'


def maybe_download(filename, work_directory):
    if not os.path.exists(work_directory):
        os.mkdir(work_directory)
    filepath = os.path.join(work_directory, filename)

    if not os.path.exists(filepath):
        filepath, _ = urllib.request.urlretrieve(SOURCE_URL + filename, filepath)
        statinfo = os.stat(filepath)
        print('Successfully downloaded', filename, statinfo.st_size, 'bytes.')
    return filepath


def _read32(bytestream):
    dt = numpy.dtype(numpy.uint32).newbyteorder('>')
    return numpy.frombuffer(bytestream.read(4), dtype=dt)[0]


def extract_images(filename):
    print('Extracting', filename)
    with gzip.open(filename) as bytestream:
        magic = _read32(bytestream)
        if magic != 2051:
            raise ValueError('Invalid magic number %d in MNIST image file: %s' % (magic, filename))
        num_images = _read32(bytestream)
        rows = _read32(bytestream)
        cols = _read32(bytestream)
        buf = bytestream.read(rows * cols * num_images)
        data = numpy.frombuffer(buf, dtype=numpy.uint8)
        data = data.reshape(num_images, rows, cols, 1)
        return data


def dense_to_one_hot(labels_dense, num_classes=10):
    num_labels = labels_dense.shape[0]
    index_offset = numpy.arange(num_labels) * num_classes
    labels_one_hot = numpy.zeros((num_labels, num_classes))
    labels_one_hot.flat[index_offset + labels_dense.ravel()] = 1
    return labels_one_hot


def extract_labels(filename, one_hot=False):
    print('Extracting', filename)
    with gzip.open(filename) as bytestream:
        magic = _read32(bytestream)
        if magic != 2049:
            raise ValueError('Invalid magic number %d in MNIST label file: %s' % (magic, filename))
        num_items = _read32(bytestream)
        buf = bytestream.read(num_items)
        labels = numpy.frombuffer(buf, dtype=numpy.uint8)
        if one_hot:
            return dense_to_one_hot(labels)
        return labels


# Construct DataSet class
class DataSet(object):
    def __init__(self, images, labels, fake_data=False, one_hot=False, dtype=tf.float32):
        dtype = tf.as_dtype(dtype).base_dtype
        if dtype not in (tf.uint8, tf.float32):
            raise TypeError('Invalid image dtype %r, expected uint8 or float32' % dtype)
        if fake_data:
            self._num_examples = 10000
            self.one_hot = one_hot
        else:
            assert images.shape[0] == labels.shape[0], (
                        'images.shape: %s labels.shape: %s' % (images.shape, labels.shape))
            self._num_examples = images.shape[0]

            # reshape
            assert images.shape[3] == 1
            images = images.reshape(images.shape[0], images.shape[1] * images.shape[2])
            if dtype == tf.float32:
                # normalize
                images = images.astype(numpy.float32)
                images = numpy.multiply(images, 1.0 / 255.0)
        self._images = images
        self._labels = labels
        self._epochs_completed = 0
        self._index_in_epoch = 0

    @property
    def images(self):
        return self._images

    @property
    def labels(self):
        return self._labels

    @property
    def num_examples(self):
        return self._num_examples

    @property
    def epochs_completed(self):
        return self._epochs_completed

    # return next 'batch_size'
    def next_batch(self, batch_size, fake_data=False):
        if fake_data:
            fake_image = [1] * 784
            if self.one_hot:
                fake_label = [1] + [0] * 9
            else:
                fake_label = 0
            return [fake_image for _ in xrange(batch_size)], [fake_label for _ in xrange(batch_size)]
        start = self._index_in_epoch
        self._index_in_epoch += batch_size

        # finish an epoch
        if self._index_in_epoch > self._num_examples:
            # random get data
            self._epochs_completed += 1
            perm = numpy.arange(self._num_examples)
            numpy.random.shuffle(perm)
            self._images = self._images[perm]
            self._labels = self._labels[perm]
            # begin next epoch
            start = 0
            self._index_in_epoch = batch_size
            assert batch_size <= self._num_examples
        end = self._index_in_epoch
        return self._images[start:end], self._labels[start:end]


# read train dataset
def read_data_sets(train_dir, fake_data=False, one_hot=False, dtype=tf.float32):
    class DataSets(object):
        pass

    data_sets = DataSets()
    # return void if fake_data is true
    if fake_data:
        def fake():
            return DataSet([], [], fake_data=True, one_hot=one_hot, dtype=dtype)

        data_sets.train = fake()
        data_sets.validation = fake()
        data_sets.test = fake()
        return data_sets

    # path of train and test files
    train_images = 'train-images-idx3-ubyte.gz'
    train_labels = 'train-labels-idx1-ubyte.gz'
    test_images = 't10k-images-idx3-ubyte.gz'
    test_labels = 't10k-labels-idx1-ubyte.gz'
    validation_size = 5000

    # read train and test data
    local_file = maybe_download(train_images, train_dir)
    train_images = extract_images(local_file)
    local_file = maybe_download(train_labels, train_dir)
    train_labels = extract_labels(local_file, one_hot=one_hot)
    local_file = maybe_download(test_images, train_dir)
    test_images = extract_images(local_file)
    local_file = maybe_download(test_labels, train_dir)
    test_labels = extract_labels(local_file, one_hot=one_hot)

    # get the first 5000 images as train dataset
    validation_images = train_images[:validation_size]
    validation_labels = train_labels[:validation_size]

    # get the remained images as train dataset
    train_images = train_images[validation_size:]
    train_labels = train_labels[validation_size:]

    # define train set, valid set and test set
    data_sets.train = DataSet(train_images, train_labels, dtype=dtype)
    data_sets.validation = DataSet(validation_images, validation_labels, dtype=dtype)
    data_sets.test = DataSet(test_images, test_labels, dtype=dtype)

    return data_sets
