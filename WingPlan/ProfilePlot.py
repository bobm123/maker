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
from math import copysign, sin, cos, pi



def read_profile(infile):
    '''
    Reads contents a 
    '''
    #Skips (and prints) airoil name
    print(infile.readline())
    polars = [[float(c) for c in line.split()] for line in infile]
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

    
def translate(polars, offset):
    polars = [(p[0]+offset[0], p[1]+offset[1]) for p in polars]
    return polars

    
def rotate(polars, angle):
    # Convert to radians,  clockwise positive
    angle = -2 * pi * angle / 360.0
    mat = [[cos(angle), -sin(angle)],[sin(angle), cos(angle)]]
    return [mat_mult(mat, p) for p in polars]
    

def mat_mult(A, x):
    return(A[0][0]*x[0]+A[0][1]*x[1], A[1][0]*x[0]+A[1][1]*x[1]) 


class Rib:
    spars = []

    def __init__(self, profile, chord = 1):
    
        self.profile = [(chord*p[0], chord*p[1]) for p in profile]

        # Calculate size of a bounding box
        self.bounds()

        self.profile = translate(self.profile, [-self.profile_size[0] / 2, 0])
        self.profile = rotate(self.profile, 1.0)

        # Update size of a bounding box
        self.bounds()

        # Seperate upper and lower surface curves
        self.split_path()

    def __str__(self):
        sstr = ''.join([str(s) for s in self.spars])
        return 'upper: {}\nlower: {}\nspars:{}\n'.format(self.upper, self.lower, sstr)

    def bounds(self):
        self.profile_min = [a for a in map(min, zip(*self.profile))]
        self.profile_max = [a for a in map(max, zip(*self.profile))]
        self.profile_size = [self.profile_max[0]-self.profile_min[0], self.profile_max[1]-self.profile_min[1]]

    def split_path(self):
        di = direction(self.profile[0], self.profile[1])
        surface0 = [(self.profile[0][0], self.profile[0][1])]
        surface1 = []
        for i in range(1, len(self.profile)):
            if di == direction(self.profile[i-1], self.profile[i]):
                surface0.append(self.profile[i])
                surface1 = [self.profile[i]] #leaves duplicate of the last point
            else:
                surface1.append(self.profile[i])
        surface1.append((self.profile[0][0], self.profile[0][1]))

        # TODO: determine upper and lower by relative position
        self.upper = sorted(surface0, key=lambda x: x[0])
        self.lower = sorted(surface1, key=lambda x: x[0])

    def add_spar(self, surface, size, percent_chord, align=(0,0), pinned=False):

        x_offset = [a*s for a,s in zip(align,size)]

        x_location = self.profile_min[0]+self.profile_size[0] * percent_chord
        position = interpolate (surface, x_location, x_offset)

        if pinned:
            position = (position[0], self.profile_min[1])

        self.spars.append((position, size))
        


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


def profile_plot(arguments, chord=100, offset=(0,0)):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    profile = read_profile(infile)
    r1 = Rib(profile, 100)

    #  add_spar( surface, size, percent, aligment, pinned)
    mm = 25.4
    r1.add_spar(r1.lower, (mm/4, mm/4), 0.00, (0,0), True)    #LE
    r1.add_spar(r1.upper, (mm/8, mm/4), 0.33, (0,1), False)  #Spar 
    r1.add_spar(r1.upper, (mm/2, mm/8), 1.00, (1,0), False)    #TE

    svg_extras = {'fill': 'none', 'stroke_width': .25}
    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny', size=('170mm', '130mm'), viewBox=('0 0 170 130'))
    grp = svgwrite.container.Group(transform='translate({},{})'.format(*offset))
    dwg.add(grp)

    # Initial move, add the lines, the close. Plot upper in red
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in r1.upper])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#FF0000", **svg_extras);
    grp.add(polar_path);

    # Plot lower in green
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in r1.lower])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#007F00", **svg_extras);
    grp.add(polar_path);

    # Add a bounding box
    bounds_rect = svgwrite.shapes.Rect(insert=r1.profile_min, size=r1.profile_size, stroke="#0000FF", **svg_extras)
    grp.add(bounds_rect)

    for spar in r1.spars:
        sp_rect = svgwrite.shapes.Rect(insert=spar[0], size=spar[1], stroke="#00FFFF", **svg_extras)
        grp.add(sp_rect)

    to_cartesian(grp)
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    profile_plot(arguments)
