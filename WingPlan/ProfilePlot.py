#! /usr/bin/python
"""
Profile Plot
Usage:
  ProfilePlot.py <infile>
  ProfilePlot.py <infile> <outfile>

"""
import sys
import svgwrite
from docopt import docopt
from math import copysign


def read_polars(infile, chord):

    #Skips (and prints) airoil name
    print(infile.readline())
    polars = [[chord*float(c) for c in line.split()] for line in infile]
    polars = [(p[0], p[1]) for p in polars if len(p) == 2]

    return polars


def direction(p0, p1):
    '''
    Indicates if the series of points is moving to the left right.
    returns -1 if p0 is to the left of p1, otherwise returns 1
    '''
    return copysign(1, p0[0] - p1[0])


# TODO: Clean this up. determine upper and lower
def split_path(polars):
    di = direction(polars[0], polars[1])
    surface0 = [(polars[0][0], polars[0][1])]
    surface1 = []
    for i in range(1, len(polars)):
        if di == direction(polars[i-1], polars[i]):
            surface0.append(polars[i])
            surface1 = [polars[i]] #leaves duplicate of the last point
        else:
            surface1.append(polars[i])
    surface1.append((polars[0][0], polars[0][1]))

    surface0 = sorted(surface0, key=lambda x: x[0])
    surface1 = sorted(surface1, key=lambda x: x[0])

    return [surface0, surface1]


def to_cartesian(grp):
    '''Converts a container group to cartesian coordinates by inverting the y-axis'''
    xform = grp.attribs.get('transform', '') + 'scale(1, -1)'
    grp.attribs['transform'] = xform


def interpolate(curve, xpos, offset = (0,0)):
    '''
    Finds the y value of the curve at x and returns
    them as a tuple with and optional offset.
    '''
    for i in range(0, len(curve)-1):
        p0 = curve[i]
        p1 = curve[i+1]
        if p0[0] <= xpos and xpos <= p1[0]:
            break # found the correct interval

    if p0[0] == p1[0]:
        # point found on a segment with infinit slope
        return (xpos, (p0[1]+p1[1])/2.0)

    m = ((p1[1]-p0[1])/(p1[0]-p0[0]))
    ypos = m*(xpos-p0[0])+p0[1]
    return(xpos-offset[0], ypos-offset[1])


def profile_plot(arguments, chord=100, offset=(10,100)):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    polars = read_polars(infile, chord)
    (upper, lower) = split_path(polars)

    # Calculate size of a bounding box
    polar_min = [a for a in map(min, zip(*polars))]
    polar_max = [a for a in map(max, zip(*polars))]
    polar_size = [polar_max[0]-polar_min[0], polar_max[1]-polar_min[1]]

    svg_extras = {'fill': 'none', 'stroke_width': .25}
    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny', size=('170mm', '130mm'), viewBox=('0 0 170 130'))
    grp = svgwrite.container.Group(transform='translate({},{})'.format(*offset))
    dwg.add(grp)

    # Initial move, add the lines, the close. Plot upper in red
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in upper])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#FF0000", **svg_extras);
    grp.add(polar_path);

    # Plot lower in green
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in lower])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#007F00", **svg_extras);
    grp.add(polar_path);

    # Add a bounding box
    bounds_rect = svgwrite.shapes.Rect(insert=polar_min, size=polar_size, stroke="#0000FF", **svg_extras)
    grp.add(bounds_rect)

    # mm to inch
    mm = 25.4
    # Add a 1/4" x 1/4" leading edge
    le_pos = interpolate (lower, (chord*0.0), (0, 0))
    le_rect = svgwrite.shapes.Rect(insert=polar_min, size=(mm/4, mm/4), stroke="#00FFFF", **svg_extras)
    grp.add(le_rect)

    # Add a 3/8" x 1/8" trailing edge
    te_pos = interpolate (lower, (chord*1.0)-3*mm/8, (0, 0))
    te_rect = svgwrite.shapes.Rect(insert=te_pos, size=(3*mm/8, mm/8), stroke="#00FFFF", **svg_extras)
    grp.add(te_rect)

    # Add a 1/8" x 1/4" main spar
    sp_pos = interpolate (upper, (chord *.33), (0, mm/4))
    sp_rect = svgwrite.shapes.Rect(insert=sp_pos, size=(mm/8, mm/4), stroke="#00FFFF", **svg_extras)
    grp.add(sp_rect)

    to_cartesian(grp)
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    profile_plot(arguments)
