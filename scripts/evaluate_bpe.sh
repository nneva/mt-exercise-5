#! /bin/bash

# Script is adapted version of "postprocess.sh" from solutions of the exercise 2. Thanks to the author!

scripts=`dirname "$0"`
base=$scripts/..

samples=$base/samples
configs=$base/configs
translations=$base/translations

src=de
trg=en
lang=de-en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$base/tools/moses-scripts/scripts

num_threads=32
device=0

SECONDS=0

model_name=transformer_bpe_2000

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $samples/test.$lang.bpe.$src > $translations_sub/test.$lang.bpe.$model_name.$trg

# undo BPE

cat $translations_sub/test.$lang.bpe.$model_name.$trg | sed 's/\@\@ //g' > $translations_sub/test.$lang.tokenized.$model_name.$trg
cat $samples/test.$lang.bpe.$trg | sed 's/\@\@ //g' > $samples/test.$lang.tokenized.$trg


# undo tokenization

cat $translations_sub/test.$lang.tokenized.$model_name.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations_sub/test.$lang.$model_name.$trg
cat $samples/test.$lang.tokenized.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $samples/test.$lang.$trg

# compute case-sensitive BLEU on detokenized data

cat $translations_sub/test.$lang.$model_name.$trg | sacrebleu $samples/test.$lang.$trg


echo "time taken:"
echo "$SECONDS seconds"
