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
import pyclipper


def read_profile(infile):
    '''
    Reads contents a 
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

    
class Rib:
    '''A class to define a rib for a model airplane plan given
    the airfoil shape (profile) and chord length. Has a method
    for defining spars, including leading and trailing edge 
    peices'''
    spars = []

    def __init__(self, profile, chord = 1, angle = 0.0):
    
        self.profile = [(chord*p[0], chord*p[1]) for p in profile]
 
        # Calculate size of a bounding box
        self.bounds()

        self.profile = self.translate(self.profile, [-self.profile_size[0] / 2, 0])
        self.profile = self.rotate(self.profile, angle)

        # Update size of a bounding box
        self.bounds()

        # Seperate upper and lower surface curves
        self.split_path()

    def __str__(self):
        sstr = ''.join([str(s) for s in self.spars])
        return 'upper: {}\nlower: {}\nspars:{}\n'.format(self.upper, self.lower, sstr)

    def split_path(self):
        di = self.direction(self.profile[0], self.profile[1])
        surface0 = [(self.profile[0][0], self.profile[0][1])]
        surface1 = []
        for i in range(1, len(self.profile)):
            if di == self.direction(self.profile[i-1], self.profile[i]):
                surface0.append(self.profile[i])
                surface1 = [self.profile[i]] #leaves duplicate of the last point
            else:
                surface1.append(self.profile[i])
        surface1.append((self.profile[0][0], self.profile[0][1]))

        # TODO: determine upper and lower by relative position
        self.upper = sorted(surface0, key=lambda x: x[0])
        self.lower = sorted(surface1, key=lambda x: x[0])
        
    def bounds(self):
        '''Determines the bounds of the profile and sets the min and 
        max coordinates and its bounding box'''
        self.profile_min = [a for a in map(min, zip(*self.profile))]
        self.profile_max = [a for a in map(max, zip(*self.profile))]
        self.profile_size = [self.profile_max[0]-self.profile_min[0], self.profile_max[1]-self.profile_min[1]]

    def direction(self, p0, p1):
        '''
        Indicates if the series of points is moving to the left right.
        returns -1 if p0 is to the left of p1, otherwise returns 1
        '''
        return copysign(1, p0[0] - p1[0])

    def translate(self, polars, offset):
        '''shifts a set of points by the given offset'''
        polars = [(p[0]+offset[0], p[1]+offset[1]) for p in polars]
        return polars
        
    def rotate(self, polars, angle):
        '''Rotates a set of points by the given angle'''
        # Convert to radians,  clockwise positive
        angle = -2 * pi * angle / 360.0
        mat = [[cos(angle), -sin(angle)],[sin(angle), cos(angle)]]
        return [self.mat_mult(mat, p) for p in polars]

    def mat_mult(self, A, x):
        '''Multiplies a 2x2 matrix and a vector of length 2'''
        return(A[0][0]*x[0]+A[0][1]*x[1], A[1][0]*x[0]+A[1][1]*x[1]) 

    def add_spar(self, surface, size, percent_chord, align=(0,0), pinned=False):
        '''Adds a spar to the list. Leading and trailing edges are
        also spars with appropriate parameters.
        
        Positional arguments:
        surface -- the upper or lower surface, but could be another reference
        size -- a len 2 list of the spars cross section size
        percent_chord -- distance from LE as a percentage of the chord

        Keyword arguments:
        align -- length 2 list of values 0 or 1 that indicates which corner of 
                 the spar's cross section is placed on the surface. 
                 [0,0] (default) places at the spar's lower left
                 [1,0] places at the spar's lower right
                 [0,1] places at the spar's upper left
                 [1,1] places at the spar's upper right
        pinned -- forces the spar to the lower surface, pinning it to the
                  building board.
        '''

        x_offset = [a*s for a,s in zip(align, size)]

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


def profile_plot(arguments, chord=100, offset=(60, 20)):
    infile = open(arguments['<infile>'], 'r')
    if not arguments['<outfile>']:
        arguments['<outfile>'] = arguments['<infile>']+'.svg'

    profile = read_profile(infile)
    r1 = Rib(profile, 100, 2.1)

    #  add_spar( surface, size, percent, aligment, pinned)
    mm = 25.4
    r1.add_spar(r1.lower, (mm/4, mm/4), 0.00, (0,0), True)    #LE
    r1.add_spar(r1.upper, (mm/8, mm/4), 0.33, (0,1), False)  #Spar 
    r1.add_spar(r1.upper, (mm/2, mm/8), 1.00, (1,0), False)    #TE

    svg_extras = {'fill': 'none', 'stroke_width': .25}
    dwg = svgwrite.Drawing(arguments['<outfile>'], profile='tiny', size=('170mm', '130mm'), viewBox=('0 0 170 130'))

    ###########################################
    # Original drawing group
    grp = svgwrite.container.Group(transform='translate({},{})'.format(*offset))
    dwg.add(grp)

    # Initial move, add the lines, the close. Plot upper in red
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in r1.upper])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#FF0000", **svg_extras);
    grp.add(polar_path);

    # Plot lower in green
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in r1.lower])
    polar_path = svgwrite.path.Path(d=path_cmd, stroke="#00FF00", **svg_extras);
    grp.add(polar_path);

    # Draw the spars
    for spar in r1.spars:
        sp_rect = svgwrite.shapes.Rect(insert=spar[0], size=spar[1], stroke="#00FFFF", **svg_extras)
        grp.add(sp_rect)

    # Add a bounding box
    bounds_rect = svgwrite.shapes.Rect(insert=r1.profile_min, size=r1.profile_size, stroke="#7f7f7f", **svg_extras)
    grp.add(bounds_rect)

    ###########################################
    # Add another group for clipper experiments
    clipper_grp = svgwrite.container.Group(transform='translate({},{})'.format(60, 40))
    dwg.add(clipper_grp)

    # Add the original bounding box as a path 
    #TODO: make this a function, will need it again
    bounds_path = [
        #[r1.profile_min[0],0], # cuts off
        #[r1.profile_max[0],0], #  the lower half
        [r1.profile_min[0],r1.profile_min[1]],
        [r1.profile_max[0],r1.profile_min[1]],
        [r1.profile_max[0],r1.profile_max[1]],
        [r1.profile_min[0],r1.profile_max[1]]
    ]
    path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in bounds_path])+'Z'
    bounds = svgwrite.path.Path(d=path_cmd, stroke="#7f7f7f", **svg_extras);
    clipper_grp.add(bounds);

    # Make a clipper object
    SCALING_FACTOR = 1000
    pc = pyclipper.Pyclipper()

    # Add a list of paths and it will 'join' them
    #full_path = [r1.upper, r1.lower]
    #pc.AddPaths(pyclipper.scale_to_clipper(full_path, SCALING_FACTOR), pyclipper.PT_SUBJECT, True)

    # or just use the profile
    pc.AddPath(pyclipper.scale_to_clipper(r1.profile, SCALING_FACTOR), pyclipper.PT_SUBJECT, True)

    # for now, clip inside the bounding box
    pc.AddPath(pyclipper.scale_to_clipper(bounds_path, SCALING_FACTOR), pyclipper.PT_CLIP, True)

    # Find the intersection of the profile and its bounding box (shoudl still be the profile
    solution = pc.Execute(pyclipper.CT_INTERSECTION, pyclipper.PFT_EVENODD, pyclipper.PFT_EVENODD)

    # Add the clipped path to the clipper group
    for s in pyclipper.scale_from_clipper(solution, SCALING_FACTOR):
        path_cmd = 'M'+'L'.join(["{} {}".format(*p) for p in s])+'Z'
        polar_path = svgwrite.path.Path(d=path_cmd, stroke="#ff7f00", **svg_extras);
        clipper_grp.add(polar_path);

    # Warning, points will be re-ordered
    #print(pyclipper.scale_from_clipper(solution, SCALING_FACTOR))

    # Flip the y-axis on both groups and save the drawing file
    to_cartesian(grp)
    to_cartesian(clipper_grp)
    dwg.save()


if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Profile Plot 0.0')
    profile_plot(arguments)
