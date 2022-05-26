import argparse
from argparse import ArgumentParser
import random


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--src-file", type=str, help="Path to source text file.", required=True)
    parser.add_argument("--trg-file", type=str, help="Path to target text file.", required=True)
    parser.add_argument("--num-lines", type=int, help="Desired number of lines.", required=True)
    parser.add_argument("--src-sample", type=str, help="Path to source sample file.", required=True)
    parser.add_argument("--trg-sample", type=str, help="Path to target sample file.", required=True)

    args = parser.parse_args()

    return args


def subsample_sents(args):
    """Randomly sub-sample train files in source and target language to the desired number of lines each."""
    
    with open(args.src_file, "r") as src, open(args.trg_file, "r") as trg:
        src, trg = src.readlines(), trg.readlines()

        assert len(src) == len(trg), "Both files must contain same number of lines."

        with open(args.src_sample, "w") as src_out, open(args.trg_sample, "w") as trg_out:
            random_nums = set(random.sample(range(len(src)), args.num_lines))

            for (idx_src, sent_src), (idx_trg, sent_trg) in zip(enumerate(src, start=1), enumerate(trg, start=1)):
                if idx_src and idx_trg in random_nums:
                    src_out.writelines(sent_src)
                    trg_out.writelines(sent_trg)


def main():

    args = parse_args()
    subsample_sents(args)

    
if __name__ == "__main__":
    main()