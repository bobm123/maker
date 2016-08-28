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
    #polar.append(polar[0])

    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny')

    #offset = [10, 100]
    #for i in range(len(polar)-1):
    #    p0 = [sum(x) for x in zip(polar[i], offset)]
    #    p1 = [sum(x) for x in zip(polar[i+1], offset)]
    #    dwg.add(dwg.line(p0, p1, stroke=svgwrite.rgb(10, 0, 0)))

    # This nifty patter generates the basic cmds, but leaves it open
    # and not sure I like index with a bollean
    #d = ' '.join(['%s%d %d' % (['M', 'L'][i>0], x, y) for i, (x, y) in enumerate(coord_list)])

    # Initial move, add the lines, the close
    path_cmd = "M{},{}".format(polar[0][0], polar[0][1])
    path_cmd = path_cmd+''.join(["L{},{}".format(p[0], p[1]) for p in polar[1:]])
    path_cmd = path_cmd+"Z"

    # Add the path to the drawing and save
    polar_path = svgwrite.path.Path(d=path_cmd, fill='none', stroke="#FF0000");
    dwg.add(polar_path);
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    ProfilePlot(arguments)
