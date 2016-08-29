#! /usr/bin/python
"""Profile Plot
Usage:
  ProfilePlot.py <infile>
  ProfilePlot.py <infile> <outfile>

"""
import sys
import svgwrite
from docopt import docopt


def ProfilePlot(arguments, chord=100, offset=(10,100)):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    print(infile.readline())
    polar = [[chord*float(c) for c in line.split()] for line in infile]
    polar = [(p[0], -p[1]) for p in polar if len(p) == 2]

    # Calculate size of a bounding box
    polar_min = [a for a in map(min, zip(*polar))]
    polar_max = [a for a in map(max, zip(*polar))]
    polar_size = [polar_max[0]-polar_min[0], polar_max[1]-polar_min[1]]
    print(polar_min)
    print(polar_size)

    dwg = svgwrite.Drawing(arguments['<outfile>'], size=('170mm', '130mm'), viewBox=('0 0 170 130'))
    grp = svgwrite.container.Group(transform='translate({},{})'.format(*offset))
    dwg.add(grp)

    # Initial move, add the lines, the close
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in polar])+'Z'

    # Add the path to the drawing and save
    polar_path = svgwrite.path.Path(d=path_cmd, fill='none', stroke="#FF0000", stroke_width=.25);
    grp.add(polar_path);

    # Add a bounding box
    bounds_rect = svgwrite.shapes.Rect(insert=polar_min, size=polar_size, fill='none', stroke="#0000FF", stroke_width=.25)
    grp.add(bounds_rect)

    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    ProfilePlot(arguments)
