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
  --output_directory=$PROJECT_HOME"/tflite" \
  --add_postprocessing_op=true
  
bazel run -c opt tensorflow/contrib/lite/toco:toco -- \
  --input_file=$PROJECT_HOME/tflite/tflite_graph.pb \
  --output_file=$PROJECT_HOME/tflite/detect.tflite \
  --input_shapes=1,300,300,3 \
  --input_arrays=normalized_input_image_tensor \
  --output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3'  \
  --inference_type=QUANTIZED_UINT8 \
  --mean_values=128 \
  --std_values=128 \
  --change_concat_input_ranges=false \
  --allow_custom_ops
  
  bazel run -c opt tensorflow/lite/toco:toco -- \
  --input_file=$PROJECT_HOME/tflite/tflite_graph.pb \
  --output_file=$PROJECT_HOME/tflite/detect.tflite \
  --input_shapes=1,300,300,3 \
  --input_arrays=normalized_input_image_tensor \
  --output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3'  \
  --inference_type=QUANTIZED_UINT8 \
  --mean_values=128 \
  --std_values=128 \
  --change_concat_input_ranges=false \
  --allow_custom_ops

%%bash
OUTPUT_DIR="/content"
cd /usr/local/lib/python3.6/dist-packages/
#bazel run --config=opt tensorflow_core/lite/toco:toco -- \
toco \
--graph_def_file=$PROJECT_HOME/tflite/tflite_graph.pb \
--output_file=$PROJECT_HOME/tflite/detect.tflite \
--input_shapes=1,300,300,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3' \
--inference_type=QUANTIZED_UINT8 \
--mean_values=128 \
--std_dev_values=128 \
--change_concat_input_ranges=false \
--allow_custom_ops \
--default_ranges_min=0 \
--default_ranges_max=6
