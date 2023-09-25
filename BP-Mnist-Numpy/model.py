import numpy as np

from utils import sigmoid, sigmoid_prime, tanh, tanh_prime, relu, relu_prime


# neural network class
class NeuralNetwork:

    # initialize the neural network
    def __init__(self, input_nodes, hidden_nodes1, hidden_nodes2, hidden_nodes3, output_nodes, learning_rate=0.1, activation_function="sigmoid"):
        """
        The network consists of three layers: input layer, hidden layer and output layer.
        Here defined these layers.
        :param input_nodes: dimension of input
        :param hidden_nodes*: dimension of hidden nodes
        :param output_nodes: dimension of output
        :param learning_rate: the learning rate of neural network
        """
        # set number of nodes in each input, hidden, output layer
        self.input_nodes = input_nodes
        self.hidden_nodes1 = hidden_nodes1
        self.hidden_nodes2 = hidden_nodes2
        self.hidden_nodes3 = hidden_nodes3
        self.output_nodes = output_nodes
        
        # Some parameters that will be used next
        self.inputs = None          # input data
        self.hidden1_inputs = None  # the input of hidden layer 1
        self.hidden1_outputs = None # the output of hidden layer 1
        self.hidden2_inputs = None  # the input of hidden layer 2
        self.hidden2_outputs = None # the output of hidden layer 2
        self.hidden3_inputs = None  # the input of hidden layer 3
        self.hidden3_outputs = None # the output of hidden layer 3
        self.final_inputs = None    # the input of output layer
        self.lr = learning_rate     # learning rate

        # link weight matrices
        # weights inside the arrays are w_i_j, where link is from node i to node j in the next layer
        self.weight_in_h1 = np.random.normal(0.0, pow(self.input_nodes, -0.5), (self.hidden_nodes1, self.input_nodes))
        self.weight_h1_h2 = np.random.normal(0.0, pow(self.hidden_nodes1, -0.5), (self.hidden_nodes2, self.hidden_nodes1))
        self.weight_h2_h3 = np.random.normal(0.0, pow(self.hidden_nodes2, -0.5), (self.hidden_nodes3, self.hidden_nodes2))
        self.weight_h3_ou = np.random.normal(0.0, pow(self.hidden_nodes3, -0.5), (self.output_nodes, self.hidden_nodes3))

        # activation function settings
        match activation_function:
            case "sigmoid":
                self.activation_function = sigmoid
                self.activation_function_prime = sigmoid_prime
            case "tanh":
                self.activation_function = tanh
                self.activation_function_prime = tanh_prime
            case "relu":
                self.activation_function = relu
                self.activation_function_prime = relu_prime

    def forward(self, input_feature):
        """
        Forward the neural network
        :param input_feature: single input image, flattened [784, ]
        """
        # convert inputs list to 2d array
        self.inputs = np.array(input_feature, ndmin=2).T

        # calculate signals into hidden layer 1
        self.hidden1_inputs = np.dot(self.weight_in_h1, self.inputs)
        # calculate the signals emerging from hidden layer 1
        self.hidden1_outputs = self.activation_function(self.hidden1_inputs)

        # calculate signals into hidden layer 2
        self.hidden2_inputs = np.dot(self.weight_h1_h2, self.hidden1_outputs)
        # calculate the signals emerging from hidden layer 2
        self.hidden2_outputs = self.activation_function(self.hidden2_inputs)

        # calculate signals into hidden layer 3
        self.hidden3_inputs = np.dot(self.weight_h2_h3, self.hidden2_outputs)
        # calculate the signals emerging from hidden layer 3
        self.hidden3_outputs = self.activation_function(self.hidden3_inputs)

        # calculate signals into final output layer
        self.final_inputs = np.dot(self.weight_h3_ou, self.hidden3_outputs)
        # calculate the signals emerging from final output layer
        self.final_outputs = self.activation_function(self.final_inputs)

    def backpropagation(self, targets_list):
        """
        Propagate backwards
        :param targets_list: output onehot code of a single image, [10, ]
        """
        targets = np.array(targets_list, ndmin=2).T

        # loss
        loss = np.sum(np.square(self.final_outputs - targets)) / 2

        # output layer error is the (final_outputs - target)
        output_loss = self.final_outputs - targets

        # hidden layer error, split by weights, recombined at hidden nodes
        hidden3_loss = np.dot(self.weight_h3_ou.T, output_loss)
        hidden2_loss = np.dot(self.weight_h2_h3.T, hidden3_loss)
        hidden1_loss = np.dot(self.weight_h1_h2.T, hidden2_loss)

        # update the weights for the links
        self.weight_h3_ou -= self.lr * np.dot((output_loss * self.final_outputs * (1.0 - self.final_outputs)), np.transpose(self.hidden3_outputs))
        self.weight_h2_h3 -= self.lr * np.dot((hidden3_loss * self.hidden3_outputs * (1.0 - self.hidden3_outputs)), np.transpose(self.hidden2_outputs))
        self.weight_h1_h2 -= self.lr * np.dot((hidden2_loss * self.hidden2_outputs * (1.0 - self.hidden2_outputs)), np.transpose(self.hidden1_outputs))
        
        # update the weights for the links between the input and hidden layers
        self.weight_in_h1 -= self.lr * np.dot((hidden1_loss * self.hidden1_outputs * (1.0 - self.hidden1_outputs)), np.transpose(self.inputs))
        
        return loss
