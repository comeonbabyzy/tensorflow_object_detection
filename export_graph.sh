#!/bin/bash

cd /content/models/research/object_detection
python export_inference_graph.py \
  --input_type=image_tensor \
  --pipeline_config_path=$PIPELINE_CONFIG_PATH
  --trained_checkpoint_prefix=$PROJECT_HOME"/model.ckpt-184602"
  --output_directory=$PROJECT_HOME
