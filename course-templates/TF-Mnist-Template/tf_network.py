import tensorflow as tf
from tensorflow.contrib.layers import flatten


class LeNet:

    def __init__(self):
        """
        Define some basic parameters here
        """

        pass

    def net(self, feats):
        """
        Define network.
        You can use init_weight() and init_bias() function to init weight matrix,
        for example:
            conv1_W = self.init_weight((3, 3, 1, 6))
            conv1_b = self.init_bias(6)
        :param feats: input features
        :return: logits
        """
        # layer 1
        # TODO: construct the conv1
        # layer 2
        # TODO: construct the pool1
        # layer 3
        # TODO: construct the conv2
        # layer 4
        # TODO: construct the pool2
        # layer 5
        # TODO: construct the fc1
        # layer 2
        # TODO: construct the fc2

        pass
        

    def forward(self, feats):
        """
        Forward the network
        """
        return self.net(feats)

    @staticmethod
    def init_weight(shape):
        """
        Init weight parameter.
        """
        w = tf.truncated_normal(shape=shape, mean=0, stddev=0.1)
        return tf.Variable(w)

    @staticmethod
    def init_bias(shape):
        """
        Init bias parameter.
        """
        b = tf.zeros(shape)
        return tf.Variable(b)
