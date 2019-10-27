#!/bin/bash

<<'COMMENT'
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

COMMENT

wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh

conda install -y tensorflow==1.14.0
conda install -y tensorflow-gpu==1.14.0
conda install -y Cython
conda install -y pillow
conda install -y lxml
conda install -y matplotlib
conda install -c conda-forge pycocotools

#conda install -y tensorboardcolab
#conda install -y jupyter
#conda install -y pandas

cd ~/
rm -rf content
mkdir content
cd content

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
unzip protoc-3.10.0-linux-x86_64.zip -d protoc/ 
sudo cp protoc/bin/protoc /usr/local/bin

git clone https://github.com/tensorflow/models.git


cd models/research

export PYTHONPATH=$PYTHONPATH":`pwd`:`pwd`/slim"

protoc object_detection/protos/*.proto --python_out=.

python object_detection/builders/model_builder_test.py
