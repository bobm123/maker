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
    polar.append(polar[0])
    #print(polar)

    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny')
    offset = [10, 100]
    for i in range(len(polar)-1):
        p0 = [sum(x) for x in zip(polar[i], offset)]
        p1 = [sum(x) for x in zip(polar[i+1], offset)]
        dwg.add(dwg.line(p0, p1, stroke=svgwrite.rgb(10, 0, 0)))
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    ProfilePlot(arguments)
