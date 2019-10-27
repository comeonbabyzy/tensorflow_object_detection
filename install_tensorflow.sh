#!/bin/bash

sudo yum -y update
sudo yum -y install python3
sudo yum -y install python3-pip

pip3 install tensorflow 
pip3 install tensorflow-gpu
pip3 install Cython
pip3 install pillow
pip3 install lxml
pip3 install matplotlib
pip3 install tensorboardcolab
pip3 install jupyter
pip3 install pytz
pip3 install pandas

cd ~/
rm -rf content
mkdir content
cd content

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
unzip protoc-3.10.0-linux-x86_64.zip -d protoc/ 
sudo cp protoc/bin/protoc /usr/local/bin

git clone https://github.com/tensorflow/models.git

cd models/research

export PYTHONPATH=$PYTHONPATH";`pwd`;`pwd`/slim"

echo `pwd` > /tmp/tensorflow_model.pth
echo `pwd`"/slim" >> /tmp/tensorflow_model.pth
sudo cp /tmp/tensorflow_model.pth /usr/lib/python3.6/site-packages/tensorflow_model.pth

protoc object_detection/protos/*.proto --python_out=.

python3 object_detection/builders/model_builder_test.py
