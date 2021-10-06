#!/bin/bash

DATASET="mg"
CODE=main.py

# Make sure conda environment has dependencies
echo "Creating conda environment"
conda create -n tf-gpu cudatoolkit cudnn python=3.8
source activate tf-gpu

pip install tensorflow==2.6.0
pip install dm-tree
pip install matplotlib
pip install sklearn
pip install git+git://github.com/tensorflow/privacy@master

export LD_LIBRARY_PATH="/root/anaconda3/envs/tf-gpu/lib"

echo "Filling data/ directory"
python $CODE $DATASET --save_data=1

echo "Beginning experiment"
python $CODE $DATASET --target_model='nn' --target_l2_ratio=1e-8

