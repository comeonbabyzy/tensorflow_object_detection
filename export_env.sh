$!/bin/bash

export PROJECT_HOME="/home/opc/content/traffic_police"
export RESEARCH_HOME="/home/opc/content/models/research"
export PIPELINE_CONFIG_PATH=$PROJECT_HOME"/ssd_mobilenet_v1_coco.config"

export PYTHONPATH=$PYTHONPATH":"$RESEARCH_HOME":"$RESEARCH_HOME"/slim"
