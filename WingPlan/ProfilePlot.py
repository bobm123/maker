#! /usr/bin/python
"""Profile Plot
Usage:
  ProfilePlot.py <infile>
  ProfilePlot.py <infile> <outfile>

"""
import sys
import svgwrite
from docopt import docopt


def ProfilePlot(arguments, chord=100):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    print(infile.readline())
    polar = [[chord*float(c) for c in line.split()] for line in infile]

    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny')

    #offset = [10, 100]

    # Initial move, add the lines, the close
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in polar])+'Z'

    # Add the path to the drawing and save
    polar_path = svgwrite.path.Path(d=path_cmd, fill='none', stroke="#FF0000");
    dwg.add(polar_path);
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    ProfilePlot(arguments)
