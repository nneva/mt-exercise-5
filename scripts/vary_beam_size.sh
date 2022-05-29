#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

num_threads=32
device=0

SECONDS=0

for k in 1 2 3 4 8 12 16 20 28 36; do
    echo "add beam size: $k"
    python scripts/parse_yaml.py --config-file configs/transformer_bpe_12000.yaml --beam-size $k
    echo "calculating BLEU..."
    sh scripts/evaluate_bpe.sh
    echo "time taken:"
    echo "$SECONDS seconds"
    echo "###############################################################################"
done