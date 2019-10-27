#!/bin/bash

PROJECT_HOME="/home/opc/content/traffic_police"
RESEARCH_HOME="/home/opc/content/models/research"

export PYTHONPATH=$PYTHONPATH":"$RESEARCH_HOME":"$RESEARCH_HOME"/slim"

# From the tensorflow/models/research/ directory
cd $RESEARCH_HOME
MODEL_DIR=$PROJECT_HOME
PIPELINE_CONFIG_PATH=$PROJECT_HOME"/ssd_mobilenet_v1_coco.config"
NUM_TRAIN_STEPS=200000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1
python object_detection/model_main.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
    --alsologtostderr &
    
#tensorboard --logdir $PROJECT_HOME --host 0.0.0.0 --port 6006 &
