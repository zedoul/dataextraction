#!/bin/bash

echo "Starting script"
if [[ $# -eq 0 ]] ; then # if called with no arguments
    echo "Usage: bash $0 <DATASET NAME>"
    exit 1
fi

DATASET=$1
CODE=main.py

echo "Loading modules"
source /etc/profile.d/modules.sh
module load anaconda3

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
# For Purchase-100 and 'nn' model, set --target_l2_ratio=1e-8
python $CODE $DATASET --target_model='softmax' --target_l2_ratio=1e-5
python $CODE $DATASET --target_model='nn' --target_l2_ratio=1e-4
for RUN in 1 2 3 4 5
do
    for EPSILON in 0.1 0.5 1.0 5.0 10.0 50.0 100.0 500.0 1000.0
    do
        for DP in 'dp' 'adv_cmp' 'rdp' 'zcdp'
        do
            python $CODE $DATASET --target_model='softmax' --target_l2_ratio=1e-5 --target_privacy='grad_pert' --target_dp=$DP --target_epsilon=$EPSILON --run=$RUN
            python $CODE $DATASET --target_model='nn' --target_l2_ratio=1e-4 --target_privacy='grad_pert' --target_dp=$DP --target_epsilon=$EPSILON --run=$RUN
        done
    done
done
echo done
