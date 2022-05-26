#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..
data=$base/data
tools=$base/tools

src=de
trg=en

TOKENIZER=$tools/moses-scripts/scripts/tokenizer/tokenizer.perl

mkdir -p $base/samples

samples=$base/samples 

mv data/dev.de-en.de data/dev.de-en.en data/test.de-en.de data/test.de-en.en samples

python scripts/subsample.py --src-file data/train.de-en.de --trg-file data/train.de-en.en --num-lines 100000 --src-sample samples/train.de-en.de --trg-sample samples/train.de-en.en

for s in dev.de-en test.de-en train.de-en; do
    for l in ${src} ${trg}; do
        cat $samples/$s.$l | $TOKENIZER -threads 4 -l $l  > $samples/$s.tokenized.$l
    done
done