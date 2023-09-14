#!/bin/bash

# cd ..

# custom config
DATA=/data/llc2/dataset
TRAINER=SharpCoOp
RHO=$2
DATASET=$1
LOWBOUND=0.5
UPBOUND=0.8
#CFG=rn50_ep100  # config file\
CFG=vit_b16_ctxv1
CTP=end  # class token position (end or middle)
NCTX=4  # number of context tokens
SHOTS=16  # number of shots (1, 2, 4, 8, 16)
CSC=False  # class-specific context (False or True)

for SEED in 1 2 3
do
    DIR=output/base2new/train_base/${DATASET}/shots_${SHOTS}_${RHO}/${TRAINER}/${CFG}/seed${SEED}
    if [ -d "$DIR" ]; then
        echo "Results are available in ${DIR}. Skip this job"
    else
        echo "Run this job and save the output to ${DIR}"
        CUDA_VISIBLE_DEVICES=0 python train.py \
        --root ${DATA} \
        --seed ${SEED} \
        --trainer ${TRAINER} \
        --dataset-config-file configs/datasets/${DATASET}.yaml \
        --config-file configs/trainers/${TRAINER}/${CFG}.yaml \
        --output-dir ${DIR} \
        TRAINER.COOP.N_CTX ${NCTX} \
        TRAINER.COOP.CSC ${CSC} \
        OPTIM.RHO ${RHO} \
        OPTIM.LOWBOUND ${LOWBOUND} \
        OPTIM.UPBOUND ${UPBOUND} \
        TRAINER.COOP.CLASS_TOKEN_POSITION ${CTP} \
        DATASET.NUM_SHOTS ${SHOTS} \
        DATASET.SUBSAMPLE_CLASSES base
    fi
done
