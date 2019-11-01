#!/bin/bash

export PROJECT_HOME="/data/traffic_police"
export RESEARCH_HOME="/home/opc/content/models/research"
export PYTHONPATH=$PYTHONPATH":"$RESEARCH_HOME":"$RESEARCH_HOME"/slim"
PIPELINE_CONFIG=$PROJECT_HOME"/pipeline.config"

cd $RESEARCH_HOME
python object_detection/export_inference_graph.py \
  --input_type=image_tensor \
  --pipeline_config_path=$PIPELINE_CONFIG \
  --trained_checkpoint_prefix=$PROJECT_HOME"/model.ckpt-190120" \
  --output_directory=$PROJECT_HOME"/traffic_police_inference_graph"
