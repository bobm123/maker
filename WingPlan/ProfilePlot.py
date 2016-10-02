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


from Rib import Rib


def read_profile(infile):
    '''
    Reads contents of an airfoil definition file such as the
    ones found here:
    http://m-selig.ae.illinois.edu/ads/coord_database.html
    
    TODO: Many have an airfoil name, followed by 2 values
    indicating number of points for upper and lower surface,
    then a list of upper serface points and finally the lower
    surface points.
    
    '''
    #Skips (and prints) airoil name
    print(infile.readline())
    polars = [[float(c) for c in line.split()] for line in infile]
    polars = [(p[0], p[1]) for p in polars if len(p) == 2]

    return polars


def to_cartesian(grp):
    '''Converts a container group to cartesian by inverting the y-axis'''
    xform = grp.attribs.get('transform', '') + 'scale(1, -1)'
    grp.attribs['transform'] = xform

    
def resize(drw, newsize):
    '''Resize the drawing'''
    drw.attribs['width'] = "{}mm".format(newsize[0])
    drw.attribs['height'] = "{}mm".format(newsize[1])
    drw.attribs['viewBox'] = "0 0 {} {}".format(newsize[0], newsize[1])


def addpath(path, grp, closed = False, color='#FF0000'):
    '''
    adds a polygon to an svg group 
    '''
    svg_extras = {'fill': 'none', 'stroke_width': .25}

    # Initial move, add then add each line segment, optionally close 
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in path])
    if closed:
        path_cmd += 'Z'
    svg_path = svgwrite.path.Path(d=path_cmd, stroke=color, **svg_extras)
    grp.add(svg_path)


def profile_plot(arguments):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    # Setup an SVG drawing with two groups
    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny', size=('100mm', '100mm'), viewBox=('0 0 100 100'))
    grp = svgwrite.container.Group(transform='translate({},{})'.format(60, 20))
    dwg.add(grp)
    rib_grp = svgwrite.container.Group(transform='translate({},{})'.format(60, 40))
    dwg.add(rib_grp)

    profile = read_profile(infile)

    # Generate a basic model plane rib (sizes given in inches)
    r1 = Rib(profile, 100, 2.1)
    to_mm = 25.4
    rib_pattern = r1.basic_rib((3/16., 3/16.), (1/2., 5/32.), (3/32., 1/4), to_mm)

    ###########################################
    # Show the profile with spar placement
    ###########################################

    # Add a bounding box
    addpath(r1.bounds_path, grp, closed=True, color='#7F7F7F')

    # Add arfoil
    addpath(r1.profile, grp, color='#FF7F00')

    # Draw the spars
    for spar in r1.spars:
        addpath(spar, grp, closed=True, color='#0000FF')

    ###########################################
    # Add another group for the rib pattern
    ###########################################

    # Draw the bounding box
    addpath(r1.bounds_path, rib_grp, closed=True, color='#7F7F7F')

    # Draw the rib pattern
    for r in rib_pattern:
        addpath(r, rib_grp, closed=True, color='#FF0000')

    # Flip the y-axis on both groups and save the drawing file
    to_cartesian(grp)
    to_cartesian(rib_grp)
    resize(dwg, (200, 100))
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    profile_plot(arguments)
