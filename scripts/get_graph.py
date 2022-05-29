from typing import List
import matplotlib.pyplot as plt
import numpy as np
import re


def create_graph(bleu_score: List[float], beam_size: List[int]):
    """Create graph with beam size values on the x-axis and BLEU scores on the y-axis."""

    COLORS = ["#486090", "#D7BFA6", "#4682B4", "#9CCCCC", "#7890A8","#DA70D6", "#20B2AA", "#90A8C0", "#A8A890"]

    # make plot
    plt.plot(beam_size, bleu_score, '-', color = COLORS[3], marker="o")
    plt.gca().get_xaxis().get_major_formatter().set_useOffset(False)
    plt.axis([0, 30, 21.0, 25.0])
    
    # color axis points
    plt.tick_params(axis='x', colors=COLORS[5])
    plt.tick_params(axis='y', colors=COLORS[2])
    
    # add values to points
    for beam, bleu in np.nditer([beam_size, bleu_score]):
        label = "{:.1f}".format(bleu)
        plt.annotate(label, (beam, bleu), textcoords="offset points", xytext=(0, 10), ha="center", color=COLORS[6])

    # customize labels
    plt.xlabel("Beam Size", fontname="Andale Mono", fontsize=14, color=COLORS[5])
    plt.ylabel("BLEU", fontname="Andale Mono", fontsize=14, color = COLORS[2])
    
    plt.grid(True, color=COLORS[1])
    plt.savefig("bleu_beam_graph.png")
    

def main():
    beam_size = [1, 2, 3, 4, 8, 12, 16, 20, 28, 36]

    with open("bleu_output.txt", "r") as f:
        pattern_bleu = r'"score": (\d\d.\d),'
        # extract BLEU - scores
        bleu_score = re.findall(pattern_bleu, f.read())
        # convert BLEU - scores to floats
        bleu_score = [float(score) for score in bleu_score]

    create_graph(bleu_score, beam_size)


if __name__ == "__main__":
    main()