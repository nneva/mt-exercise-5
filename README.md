# MT Exercise 5: Byte Pair Encoding, Beam Search

This repo is just a collection of scripts showing how to install [JoeyNMT](https://github.com/joeynmt/joeynmt), download
data and train & evaluate models.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place:

    git clone https://github.com/nneva/mt-exercise-5

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/download_install_packages.sh

Download data:

    ./download_iwslt_2017_data.sh

The data is only minimally preprocessed, so you may want to tokenize it and apply any further preprocessing steps.

Preprocess data:

    ./scripts/preprocess.sh

This command creates directory `samples` and stores dev and test data in it. 

It also executes `subsample.py`, which subsamples originally downloaded train data based on the desired number of lines, and stores them also in `samples` directory. 

Train, dev and test data are tokenized with Moses Tokenizer. 

Train a word level model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Train BPE level models:

    ./scripts/train_bpe.sh

By running this script BPE is learned and applied, and respective vocabulary is built prior to start of the training. 

To initialize the training with different vocab size, change the `bpe_num_operations` value in this script.

This will automatically load different configuration, if such is present in configs directory, and named properly.

See configurations in configs directory for more details.

Evaluate a trained word level model with:

    ./scripts/evaluate.sh

This script will create directory `translations`, with the subdirectory named after the model.

Post-processing steps include detokenization of the test data.

Results of the evaluation will be printed out in the terminal.

Evaluate trained BPE level models with:

    ./scripts/evaluate_bpe.sh

To evaluate different BPE level models, change `model_name` in this script accordingly.

This script will create additional subdirectorie(s) named after the model(s), where translations are stored.

Post-processing steps include detokenization and removal of BPE from the test data.

Results of the evaluation will be printed out in the terminal.

If you decide to train and evaluate several BPE level models, make sure to run `train_bpe.sh` then `evaluate_bpe.sh` for the same model 

before initializing train of the next BPE level model.


