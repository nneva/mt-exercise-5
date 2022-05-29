#! /bin/bash

# Script is adapted version of "preprocess.sh" from the exercise 2. Thanks to the author!

scripts=`dirname "$0"`
base=$scripts/..

models=$base/models
configs=$base/configs
logs=$base/logs
samples=$base/samples
tools=$base/tools

src=de
trg=en
lang=de-en

bpe_num_operations=12000
bpe_vocab_threshold=10
num_threads=32

model_name=transformer_bpe_$bpe_num_operations

mkdir -p $logs/$model_name

mkdir -p $base/shared_models


echo "learning joint BPE & vocab..."
subword-nmt learn-joint-bpe-and-vocab -i $samples/train.$lang.tokenized.$src $samples/train.$lang.tokenized.$trg \
	--write-vocabulary $base/shared_models/vocab.$src $base/shared_models/vocab.$trg \
	-s $bpe_num_operations --total-symbols -o $base/shared_models/$src$trg.bpe

echo "applying BPE..."
for s in train.$lang dev.$lang test.$lang; do
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$src --vocabulary-threshold $bpe_vocab_threshold < $samples/$s.tokenized.$src > $samples/$s.bpe.$src
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$trg --vocabulary-threshold $bpe_vocab_threshold < $samples/$s.tokenized.$trg > $samples/$s.bpe.$trg
done

echo "building vocab..."
python $tools/joeynmt/scripts/build_vocab.py $samples/train.$lang.bpe.$src $samples/train.$lang.bpe.$trg --output_path $base/shared_models/vocab.txt

echo "train..."
OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/$model_name.yaml > $logs/$model_name/out 2> $logs/$model_name/err

echo "time taken:"
echo "$SECONDS seconds"