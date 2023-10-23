from model import Model
import numpy as np
import os
import torch
from torchvision.datasets import mnist
from torch.nn import CrossEntropyLoss
from torch.optim import SGD, Adam
from torch.utils.data import DataLoader
from torch.utils.tensorboard import SummaryWriter
from torchvision.transforms import ToTensor


def train(batch_size=256, lr=1e-3, all_epoch=30, optimizer='SGD', train_folder='./train', test_folder='./test', writer=None):
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print('using device : {}'.format(device))

    # load dataset and model
    train_dataset = mnist.MNIST(root=train_folder, train=True, transform=ToTensor())
    test_dataset = mnist.MNIST(root=test_folder, train=False, transform=ToTensor())
    train_loader = DataLoader(train_dataset, batch_size=batch_size)
    test_loader = DataLoader(test_dataset, batch_size=batch_size)
    model = Model().to(device)

    # optimizer = SGD(model.parameters(), lr=1e-2)
    opt = SGD(model.parameters(), lr=lr) if optimizer=='SGD' else Adam(model.parameters(), lr=lr, weight_decay=1e-3)
    loss_fn = CrossEntropyLoss()

    # train
    prev_acc = 0
    for current_epoch in range(all_epoch):
        print('epoch : {}'.format(current_epoch))
        model.train()
        for idx, (train_x, train_label) in enumerate(train_loader):
            train_x = train_x.to(device)
            train_label = train_label.to(device)
            opt.zero_grad()
            predict_y = model(train_x.float())
            loss = loss_fn(predict_y, train_label.long())
            loss.backward()
            opt.step()

        all_correct_num = 0
        all_sample_num = 0
        model.eval()
        
        for idx, (test_x, test_label) in enumerate(test_loader):
            test_x = test_x.to(device)
            test_label = test_label.to(device)
            predict_y = model(test_x.float()).detach()
            predict_y =torch.argmax(predict_y, dim=-1)
            current_correct_num = predict_y == test_label
            all_correct_num += np.sum(current_correct_num.to('cpu').numpy(), axis=-1)
            all_sample_num += current_correct_num.shape[0]
        acc = all_correct_num / all_sample_num
        print('accuracy: {:.3f}'.format(acc), flush=True)

        if writer is not None:
            writer.add_scalar('Loss', loss, current_epoch)
            writer.add_scalar('Accurancy', acc, current_epoch)

        if np.abs(acc - prev_acc) < 1e-8:
            break
        prev_acc = acc

    # save trained model
    os.makedirs("models", exist_ok=True)
    torch.save(model, 'models/mnist_{:.3f}.pkl'.format(acc))


if __name__ == '__main__':
    writer = SummaryWriter('./tensorboard')

    print('model start training')
    train(batch_size=256,
          lr=1e-4, 
          all_epoch=100, 
          optimizer='Adam', 
          train_folder='./train', 
          test_folder='./test', 
          writer=writer)
    print("model finish training")
