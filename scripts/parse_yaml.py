import argparse
from argparse import ArgumentParser
import io
import yaml


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()

    parser.add_argument("--config-file", type=str, help="Path to configuration file.", required=True)
    parser.add_argument("--beam-size", type=int, help="Desired beam size (K).", required=True)

    args = parser.parse_args()

    return args


def modify_K(args):
    """Read file, modify value for the key 'beam size', and rewrite the file."""

    with io.open(args.config_file, "r", encoding="utf8") as y:
        data = yaml.safe_load(y)

        data["testing"]["beam_size"] = args.beam_size
        try:

            del data["training"]["print_valid_sents"]

        except KeyError: pass

    with io.open(args.config_file, "w", encoding="utf8") as out:
        yaml.dump(data, out, sort_keys=False, default_flow_style=False, allow_unicode=True, line_break=True)


def main():

    args = parse_args()
    beam_size = modify_K(args)

if __name__ == "__main__":
    main() 

