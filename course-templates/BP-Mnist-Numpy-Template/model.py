import numpy as np


# neural network class
class neuralNetwork:

    # initialize the neural network
    def __init__(self, input_nodes, hidden_nodes, output_nodes, learning_rate=0.1):
        """
        The network consists of three layers: input layer, hidden layer and output layer.
        Here defined these layers.
        :param input_nodes: dimension of input
        :param hidden_nodes: dimension of hidden nodes
        :param output_nodes: dimension of output
        :param learning_rate: the learning rate of neural network
        """

        pass

    def forward(self, input_feature):
        """
        Forward the neural network
        :param input_feature: single input image, flattened [784, ]
        """

        pass

    def backpropagation(self, targets_list):
        """
        Propagate backwards
        :param targets_list: output onehot code of a single image, [10, ]
        """

        pass
