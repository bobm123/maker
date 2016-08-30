#! /usr/bin/python
"""Profile Plot
Usage:
  ProfilePlot.py <infile>
  ProfilePlot.py <infile> <outfile>

"""
import sys
import svgwrite
from docopt import docopt


def read_polars(infile, chord):

    #Skips (and prints) airoil name
    print(infile.readline())
    polars = [[chord*float(c) for c in line.split()] for line in infile]
    polars = [(p[0], p[1]) for p in polars if len(p) == 2]

    return polars



def profile_plot(arguments, chord=100, offset=(10,100)):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    polars = read_polars(infile, chord)

    # Calculate size of a bounding box
    polar_min = [a for a in map(min, zip(*polars))]
    polar_max = [a for a in map(max, zip(*polars))]
    polar_size = [polar_max[0]-polar_min[0], polar_max[1]-polar_min[1]]
    #print(polar_min)
    #print(polar_size)

    svg_extras = {'fill': 'none', 'stroke_width': .25}
    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny', size=('170mm', '130mm'), viewBox=('0 0 170 130'))
    grp = svgwrite.container.Group(transform='translate({},{}) scale(1, -1)'.format(*offset))
    dwg.add(grp)

    # Initial move, add the lines, the close
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in polars])+'Z'

    # Add the path to the drawing and save
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#FF0000", **svg_extras);
    grp.add(polar_path);

    # Add a bounding box
    bounds_rect = svgwrite.shapes.Rect(insert=polar_min, size=polar_size, stroke="#0000FF", **svg_extras)
    grp.add(bounds_rect)

    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    profile_plot(arguments)
