from torch.nn import Module
from torch import nn


class Model(Module):
    def __init__(self):						
        super(Model, self).__init__() 

        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5, stride=1, padding=2), 
            nn.BatchNorm2d(num_features=6),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2), 
            nn.Conv2d(in_channels=6, out_channels=16, kernel_size=5, stride=1),
            nn.BatchNorm2d(num_features=16),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2), 
        )

        self.fc = nn.Sequential(
            nn.Linear(16 * 5 * 5, 120),
            nn.Dropout(0.2),
            nn.ReLU(),
            nn.Linear(120, 84),
            nn.Dropout(0.2),
            nn.ReLU(),
            nn.Linear(84, 10),
        )

    def forward(self, x): 
        y = self.conv(x)
        y = y.view(-1, 16 * 5 * 5)
        y = self.fc(y)
        return y
    