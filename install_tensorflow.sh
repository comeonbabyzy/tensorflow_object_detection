#!/bin/bash

sudo yum -y update
sudo yum -y install python3
sudo yum -y install python3-pip

sudo pip3 install tensorflow 
sudo pip3 install tensorflow-gpu
sudo pip3 install Cython
sudo pip3 install pillow
sudo pip3 install lxml
sudo pip3 install matplotlib
sudo pip3 install tensorboardcolab
sudo pip3 install jupyter

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
unzip protoc-3.10.0-linux-x86_64.zip 
cp bin/protoc /usr/local/bin

git clone https://github.com/tensorflow/models.git

cd models/research

export PYTHONPATH=$PYTHONPATH";`pwd`;`pwd`/slim"

echo `pwd` > /usr/lib/python3.6/site-packages/tensorflow_model.pth
echo `pwd\slim' >> /usr/lib/python3.6/site-packages/tensorflow_model.pth

python3 object_detection/builders/model_builder_test.py
