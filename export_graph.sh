#!/bin/bash

cd $RESEARCH_HOME

CHECKPOINT_PATH=$PROJECT_HOME"/model.ckpt-184602" 


#python object_detection/export_inference_graph.py \
#  --input_type=image_tensor \
#  --pipeline_config_path=$PIPELINE_CONFIG_PATH \
#  --trained_checkpoint_prefix=$CHECKPOINT_PATH \
#  --output_directory=$PROJECT_HOME

python object_detection/export_tflite_ssd_graph.py \
--pipeline_config_path=$PIPELINE_CONFIG_PATH \
--trained_checkpoint_prefix=$CHECKPOINT_PATH \
--output_directory=$PROJECT_HOME"/tflite \
--add_postprocessing_op=true
