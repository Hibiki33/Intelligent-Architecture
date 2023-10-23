import numpy as np
import torch
from torchvision.datasets import mnist
from torchvision.transforms import ToTensor
from torch.utils.data import DataLoader
import torchvision.transforms as transforms


def eval(model_path, batch_size=256, test_folder='./test'):
    assert model_path is not None

    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print('using device : {}'.format(device))

    # load dataset and model
    test_dataset = mnist.MNIST(root=test_folder, train=False, transform=transforms.ToTensor())
    test_loader = DataLoader(test_dataset, batch_size=batch_size)
    model = torch.load(model_path)

    # eval
    model.eval()
    all_correct_num = 0
    all_sample_num = 0
    for idx, (test_x, test_label) in enumerate(test_loader):
        test_x = test_x.to(device)
        test_label = test_label.to(device)
        predict_y = model(test_x.float()).detach()
        predict_y =torch.argmax(predict_y, dim=-1)
        current_correct_num = predict_y == test_label
        all_correct_num += np.sum(current_correct_num.to('cpu').numpy(), axis=-1)
        all_sample_num += current_correct_num.shape[0]
    acc = all_correct_num / all_sample_num
    print('accuracy: {:.5f}'.format(acc))


if __name__ == "__main__":

    print('model start evaluating')
    eval('models/mnist_0.991.pkl')
    print("model finish evaluating")

