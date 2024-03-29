#!/bin/bash


export PROJECT_HOME="/home/opc/content/traffic_police"
export RESEARCH_HOME="/home/opc/content/models/research"
export PYTHONPATH=$PYTHONPATH":"$RESEARCH_HOME":"$RESEARCH_HOME"/slim"

TRAIN_IMAGE=$PROJECT_HOME"/train/images"
EVAL_IMAGE=$PROJECT_HOME"/validation/images"
TRAIN_XML=$PROJECT_HOME"/train/annotations"
EVAL_XML=$PROJECT_HOME"/validation/annotations"

PRETRAINED_MODEL_URL="http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_2018_01_28.tar.gz"
PRETRAINED_MODEL="faster_rcnn_resnet101_coco_2018_01_28"
PRETRAINED_MODEL_FILE=$PRETRAINED_MODEL".tar.gz"
PIPELINE_CONFIG_URL="https://raw.githubusercontent.com/tensorflow/models/master/research/object_detection/samples/configs/faster_rcnn_resnet101_coco.config"
PIPELINE_CONFIG_PATH=$PROJECT_HOME"/faster_rcnn_resnet101_coco.config"
PIPELINE_CONFIG=$PROJECT_HOME"/pipeline.config"

TRAIN_INPUT_PATH=$PROJECT_HOME"/train.record"
EVAL_INPUT_PATH=$PROJECT_HOME"/validation.record"
LABEL_MAP_PATH=$PROJECT_HOME"/traffic_police.pbtxt"
FINE_TUNE_CHECKPOINT=$PROJECT_HOME"/"$PRETRAINED_MODEL"/model.ckpt" #"\/content\/ssd_mobilenet_v1_coco_2018_01_28\/model.ckpt"

rm -rf $PROJECT_HOME
unzip /home/opc/traffic_police.zip -d /home/opc/content

NUM_EXAMPLES=$(ls -l $EVAL_IMAGE | grep "^-" | wc -l)

echo $PROJECT_HOME
echo $TRAIN_IMAGE
echo $EVAL_IMAGE
echo $TRAIN_XML
echo $EVAL_XML
echo $TRAIN_INPUT_PATH
echo $EVAL_INPUT_PATH
echo $LABEL_MAP_PATH
echo $FINE_TUNE_CHECKPOINT
echo $NUM_EXAMPLES

#cd $PROJECT_HOME

python3 xml_to_csv.py --xml_path=$TRAIN_XML --csv_output=$PROJECT_HOME"/train.csv"
python3 xml_to_csv.py --xml_path=$EVAL_XML --csv_output=$PROJECT_HOME"/validation.csv"

python3 generate_TFR.py --image_path=$TRAIN_IMAGE --csv_input=$PROJECT_HOME"/train.csv" --output_path=$TRAIN_INPUT_PATH
python3 generate_TFR.py --image_path=$EVAL_IMAGE --csv_input=$PROJECT_HOME"/validation.csv" --output_path=$EVAL_INPUT_PATH

cp "traffic_police.pbtxt" $PROJECT_HOME

cd $PROJECT_HOME
ls -l
wget $PRETRAINED_MODEL_URL
tar zxvf $PRETRAINED_MODEL_FILE

wget $PIPELINE_CONFIG_URL
cp $PIPELINE_CONFIG_PATH $PIPELINE_CONFIG

#sed -i 's/input_path: "PATH_TO_BE_CONFIGURED\/mscoco_train.record.*"/input_path: "\/content\/train.record"/g' $PIPELINE_CONFIG
#sed -i 's/input_path: "PATH_TO_BE_CONFIGURED\/mscoco_val.record.*"/input_path: "\/content\/validation.record"/g' $PIPELINE_CONFIG
#sed -i 's/label_map_path: "PATH_TO_BE_CONFIGURED\/mscoco_label_map.pbtxt"/label_map_path: "\/content\/traffic_police.pbtxt"/g' $PIPELINE_CONFIG

sed -i 's/input_path: "PATH_TO_BE_CONFIGURED.*train.*"/input_path: "'${TRAIN_INPUT_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG
sed -i 's/input_path: "PATH_TO_BE_CONFIGURED.*val.*"/input_path: "'${EVAL_INPUT_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG
sed -i 's/label_map_path.*"/label_map_path: "'${LABEL_MAP_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG

sed -i 's/num_classes.*/num_classes: 1/g' $PIPELINE_CONFIG
sed -i 's/num_examples.*/num_examples: '$NUM_EXAMPLES'/g' $PIPELINE_CONFIG
#sed -i 's/batch_size.*/batch_size: 1/g' $PIPELINE_CONFIG

sed -i 's/fine_tune_checkpoint:.*/fine_tune_checkpoint: "'${FINE_TUNE_CHECKPOINT//\//\\\/}'"/g' $PIPELINE_CONFIG
