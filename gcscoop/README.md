# How to Run

## GPU memory needed

All the experiments is able to run on a single graphic card. However, **if you want to get results on ImageNet, the memory on any single graphic card should be larger than 24 GB.** Around 12 GB is enough for other datasets. 


## How to Install
This code is built on top of the toolbox [Dassl.gcscoop.pytorch]. You can prepare the environment as follows:

```
cd Dassl.gcscoop.pytorch/
# Create a conda environment
conda create -n dassl python=3.7

# Activate the environment
conda activate dassl

# Install dependencies
pip install -r requirements.txt

# Install torch (version >= 1.7.1) and torchvision
# Please make sure you have installed the gpu version due to the speed.
# For example:
conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

# Install this library (no need to re-build if the source code is modified)
python setup.py develop
```

After that, run `pip install -r requirements.txt` under `gcscoop/` to install a few more packages required by [CLIP](https://github.com/openai/CLIP) (this should be done when `dassl` is activated). Then, you are ready to go.

Follow [DATASETS.md](DATASETS.md) to install the datasets.


## Generalization From Seen to Unseen Classes
```bash
cd gcscoop/
```
You will need `base2new_train_main.sh`, `base2new_test_main.sh`. The scripts with the prefix `base2new_train` train a model on base (seen) classes while the ones with the prefix `base2new_test` evaluate the trained model on new (unseen) classes. Both kinds of scripts have only two input arguments, i.e., `DATASET` and 'rho'. `DATASET` takes as input a dataset name, like `imagenet` or `caltech101`. 'rho' indicates the perturbation radius for optimizition. The valid names are the files' names in `gcscoop/configs/datasets/`.

Below we provide an example on how to evaluate the model on Caltech101.

```bash
bash scripts/base2new_train.sh caltech101 0.1
bash scripts/base2new_test.sh caltech101 0.1
```

When the evaluation is done, you can use `parse_test_res.py` to automatically calculate the average results. For instance, after you finish the evaluation using the aforementioned commands, you would get

```
output
|–– base2new/
|   |–– test_new/
|   |   |–– caltech101/
|   |   |   |–– shots_16_0.1/
|   |   |   |   |–– SharpCoOp/
|   |   |   |   |   |–– vit_b16_ctxv1/
|   |   |   |   |   |   |–– seed1/
|   |   |   |   |   |   |–– seed2/
|   |   |   |   |   |   |–– seed3/
|   |–– train_base/
|   |   |–– caltech101/
|   |   |   |–– shots_16_0.1/
|   |   |   |   |–– SharpCoOp/
|   |   |   |   |   |–– vit_b16_ctxv1/
|   |   |   |   |   |   |–– seed1/
|   |   |   |   |   |   |–– seed2/
|   |   |   |   |   |   |–– seed3/
```

Then, to get the average performance on the base classes, run

```bash
python parse_test_res.py output/base2new/train_base/caltech101/shots_16_0.1/SharpCoOp/vit_b16_ctxv1
```

To get the average performance on the new classes, run

```bash
python parse_test_res.py output/base2new/test_new/caltech101/shots_16_0.1/SharpCoOp/vit_b16_ctxv1 --test-log
```

## Cross-domain Generalization
Below we provide an example on how to train the model on Imagenet and evaluate on Imagenet-v2.

```bash
bash scripts/main_train.sh imagenet 0.1
bash scripts/eval_domain.sh imagenetv2 0.1
```

