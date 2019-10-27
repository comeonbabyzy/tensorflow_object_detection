#!/bin/bash

PROJECT_HOME="~/content/traffic_police"
RESEARCH_HOME="~/content/models/research"
TRAIN_IMAGE=$PROJECT_HOME"/train/images"
EVAL_IMAGE=$PROJECT_HOME"/validation/images"
TRAIN_XML=$PROJECT_HOME"/train/annotations"
EVAL_XML=$PROJECT_HOME"/validation/annotations"


PRETRAINED_MODEL="ssd_mobilenet_v1_coco_2018_01_28"
PRETRAINED_MODEL_FILE=$PRETRAINED_MODEL".tar.gz"
PRETRAINED_MODEL_URL="http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_coco_2018_01_28.tar.gz"
PIPELINE_CONFIG_URL="https://raw.githubusercontent.com/tensorflow/models/master/research/object_detection/samples/configs/ssd_mobilenet_v1_coco.config"
PIPELINE_CONFIG_PATH=$PROJECT_HOME"/ssd_mobilenet_v1_coco.config"

TRAIN_INPUT_PATH=$PROJECT_HOME"/train.record"
EVAL_INPUT_PATH=$PROJECT_HOME"/validation.record"
LABEL_MAP_PATH=$PROJECT_HOME"/traffic_police.pbtxt"
FINE_TUNE_CHECKPOINT=$PROJECT_HOME"/"$PRETRAINED_MODEL"/model.ckpt" #"\/content\/ssd_mobilenet_v1_coco_2018_01_28\/model.ckpt"
NUM_EXAMPLES=$(ls -l $TRAIN_IMAGE | grep "^-" | wc -l)

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

rm -rf $PROJECT_HOME
unzip ~/traffic_police.zip -d ~/content

python3 xml_to_csv.py --xml_path=$TRAIN_XML --csv_output=$PROJECT_HOME"/train.csv"
python3 xml_to_csv.py --xml_path=$EVAL_XML --csv_output=$PROJECT_HOME"/validation.csv"

python3 generate_TFR.py --image_path=$TRAIN_IMAGE --csv_input=$PROJECT_HOME"/train.csv" --output_path=$TRAIN_INPUT_PATH
python3 generate_TFR.py --image_path=$EVAL_IMAGE --csv_input=$PROJECT_HOME"/validation.csv" --output_path=$EVAL_INPUT_PATH

cp "traffic_police.pbtxt" $PROJECT_HOME

cd $PROJECT_HOME

wget $PRETRAINED_MODEL_URL
tar zxvf $PRETRAINED_MODEL_FILE

wget $PIPELINE_CONFIG_URL

#sed -i 's/input_path: "PATH_TO_BE_CONFIGURED\/mscoco_train.record.*"/input_path: "\/content\/train.record"/g' $PIPELINE_CONFIG_PATH
#sed -i 's/input_path: "PATH_TO_BE_CONFIGURED\/mscoco_val.record.*"/input_path: "\/content\/validation.record"/g' $PIPELINE_CONFIG_PATH
#sed -i 's/label_map_path: "PATH_TO_BE_CONFIGURED\/mscoco_label_map.pbtxt"/label_map_path: "\/content\/traffic_police.pbtxt"/g' $PIPELINE_CONFIG_PATH

sed -i 's/input_path: "PATH_TO_BE_CONFIGURED.*train.*"/input_path: "'${TRAIN_INPUT_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG_PATH
sed -i 's/input_path: "PATH_TO_BE_CONFIGURED.*val.*"/input_path: "'${EVAL_INPUT_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG_PATH
sed -i 's/label_map_path.*"/label_map_path: "'${LABEL_MAP_PATH//\//\\\/}'"/g' $PIPELINE_CONFIG_PATH

sed -i 's/num_classes.*/num_classes: 1/g' $PIPELINE_CONFIG_PATH
sed -i 's/num_examples.*/num_examples: '$NUM_EXAMPLES'/g' $PIPELINE_CONFIG_PATH
#sed -i 's/batch_size.*/batch_size: 1/g' $PIPELINE_CONFIG_PATH

sed -i 's/fine_tune_checkpoint:.*/fine_tune_checkpoint: "'$FINE_TUNE_CHECKPOINT'"/g' $PIPELINE_CONFIG_PATH

exit

# From the tensorflow/models/research/ directory
cd $RESEARCH_HOME
#PIPELINE_CONFIG_PATH=/content/faster_rcnn_inception_v2_pets.config
MODEL_DIR=$PROJECT_HOME
NUM_TRAIN_STEPS=200000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1
python object_detection/model_main.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
    --alsologtostderr
