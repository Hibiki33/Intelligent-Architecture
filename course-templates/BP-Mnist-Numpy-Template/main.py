import numpy as np
import time

from model import neuralNetwork
from utils import load_mnist


def evaluate(net, features, labels):
    """
    Evaluate the trained model
    During training, the accuracy is the result of testing using the training set.
    During testing, the accuracy is the result of testing using the testing set.
    :param net: neuralNetwork
    :param features: images or features, [xxx, 784]
    :param labels: labels, [xxx, 10]
    :return: None
    """
    # record the correct times of classification
    cnt = 0
    for i, feat in enumerate(features):
        # then scale data to range from 0.01 to 1.0
        feat = (feat / 255.0 * 0.99) + 0.01

        # forward the network
        net.forward(feat)
        outputs = net.final_outputs

        # the index of the highest value corresponds to the label
        res = np.argmax(outputs)
        if res == labels[i]:
            cnt += 1

    print("Accuracy: {:.2f}".format(cnt / len(features)))


def train(net, features, labels):
    """
    Train the neural network
    :param net: neuralNetwork
    :param features: images or features, [xxx, 784]
    :param labels: labels, [xxx, 10]
    :return: None
    """
    # epochs is the number of times the training data set is used for training
    epochs = 2

    for e in range(epochs):
        # go through all records in the training data set
        loss = 0

        for i, feat in enumerate(features):
            # scale the inputs
            feat = (feat / 255.0 * 0.99) + 0.01

            # create the target output values (all 0.01, except the desired label which is 0.99)
            targets = np.zeros(net.output_nodes) + 0.01

            # all_values[0] is the target label for this record
            targets[labels[i]] = 0.99

            # Forward network and propagate backward
            net.forward(feat)
            loss += net.backpropagation(targets)

            # print loss
            if (i + 1) % 5000 == 0:
                print("Epoch {:05d} | Loss {:.4f}".format(e, loss / 1000))
                loss = 0

        # evaluate the model using training set
        print("Training ", end='')
        evaluate(net, features, labels)


if __name__ == '__main__':

    # get training and testing data
    path = './dataset/'
    train_images, train_labels = load_mnist(path, kind='train')
    test_images, test_labels = load_mnist(path, kind='t10k')

    # number of input, hidden and output nodes
    input_nodes = 784
    hidden_nodes = 200
    output_nodes = 10

    # learning rate
    learning_rate = 0.1

    # create instance of neural network
    model = neuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate)

    # record start training time
    start_training_time = time.time()

    # start training
    train(model, train_images, train_labels)
    print("Training time: {:.3f}s".format(time.time() - start_training_time))

    # Use the test set to test the final recognition accuracy
    print("Testing ", end='')
    evaluate(model, test_images, test_labels)

    # Save weight parameters
    np.save('./weights/who.npy', model.who)
    np.save('./weights/whi.npy', model.wih)

    print("Done.")

