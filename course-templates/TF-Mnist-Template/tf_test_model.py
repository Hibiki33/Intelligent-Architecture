import tensorflow as tf
from tensorflow.python.platform import gfile
import input_data
from data_object import provide_data


def test_model(dataset):
    """
    Test model function.
    Return: accuracy and loss of the dataset.
    """
    num_samples = dataset.num_samples   # the number of sample in dataset
    # print(num_samples)
    data_images = dataset.images        # get images data
    data_labels = dataset.labels        # get labels data

    total_accuracy = 0
    total_loss = 0
    for offset in range(0, num_samples, batch_size):
        # "offset" is the start position of the index, "end" is the end position of the index.
        end = offset + batch_size
        # get images and labels according to the batch number
        batch_images, batch_labels = data_images[offset:end], data_labels[offset:end]
        total_accuracy += sess.run(accuracy_operation,
                                   feed_dict={input_images: batch_images, images_labels: batch_labels})
        total_loss += sess.run(loss_operation, feed_dict={input_images: batch_images, images_labels: batch_labels})
    
    return total_accuracy * batch_size / num_samples, total_loss * batch_size / num_samples


if __name__ == "__main__":
    
    batch_size = 1000   # batch size, you can change the value of it

    # create session
    with tf.Session() as sess:
        # open the model and get graph
        with gfile.FastGFile('./model/model.pb', 'rb') as f:
            graph_def = tf.GraphDef()
            graph_def.ParseFromString(f.read())
            sess.graph.as_default()
            tf.import_graph_def(graph_def, name='')  # import graph
        
        # prepare training dataset and test dataset
        # train: 55000, test: 10000, validation: 5000
        mnist = input_data.read_data_sets('mnist_data/') # load minist dataset
        data = provide_data(mnist)

        # init session
        sess.run(tf.global_variables_initializer())
        
        # get input tensor
        input_images = sess.graph.get_tensor_by_name('images:0')            # input parameter: images
        images_labels = sess.graph.get_tensor_by_name('labels:0')           # input parameter: labels
        accuracy_operation = sess.graph.get_tensor_by_name('accuracy:0')    # output parameter: accuracy
        loss_operation = sess.graph.get_tensor_by_name('loss:0')            # output parameter: loss
        
        # get accuracy and loss
        test_accuracy, loss = test_model(data.test)

        print("Test Loss = {:.5f}, Validation Accuracy = {:.5f}\n".format(loss, test_accuracy))
