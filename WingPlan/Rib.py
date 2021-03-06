
from math import copysign, sin, cos, pi
import pyclipper

class Rib:
    '''A class to define a rib for a model airplane plan given
    the airfoil shape (profile) and chord length. Has a method
    for defining spars, including leading and trailing edge 
    peices'''
    spars = []

    SCALING_FACTOR = 1000
    clipper = pyclipper.Pyclipper()

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
        self.bounds_path =  self.rect2path(self.profile_min, self.profile_size)

    def direction(self, p0, p1):
        '''
        Indicates if the series of points is moving to the left right.
        returns -1 if p0 is to the left of p1, otherwise returns 1
        '''
        return copysign(1, p0[0] - p1[0])

    def translate(self, points, offset):
        '''shifts a set of points by the given offset'''
        points = [(p[0]+offset[0], p[1]+offset[1]) for p in points]
        return points
        
    def rotate(self, points, angle):
        '''Rotates a set of points by the given angle'''
        # Convert to radians,  clockwise positive
        angle = -2 * pi * angle / 360.0
        mat = [[cos(angle), -sin(angle)],[sin(angle), cos(angle)]]
        return [self.mat_mult(mat, p) for p in points]

    def mat_mult(self, A, x):
        '''Multiplies a 2x2 matrix and a vector of length 2'''
        return(A[0][0]*x[0]+A[0][1]*x[1], A[1][0]*x[0]+A[1][1]*x[1]) 

    def add_diamond_le(self, surface, size, x_adjust=1.0):
        '''
        Adds a diamond shaped LE to the list of spars

        Positional arguments:
        surface -- the upper or lower surface, but could be another reference
        size -- size of leading edge (assumed to be square)

        Keyword arguments:
        x_adjust -- nudge the diamond shape forward so it captures the profile's shape
                    with a minimum of sanding. Usually a value between 0 and .1
        '''

        #position = self.interpolate (surface, self.profile_min[0], (-size*x_adjust, 0))
        position = (self.profile_min[0]+size*.707*x_adjust, 2+self.profile_min[1]+size*.707)

        spar_path = self.rect2path((-size/2.0, -size/2.0), (size, size))
        spar_path = self.rotate(spar_path, 45)
        spar_path = self.translate(spar_path, position)
        self.spars.append(spar_path)


    def add_spar(self, surface, size, percent_chord, align=(0,0), pinned=False):
        '''
        Adds a spar to the list. Leading and trailing edges can also be 
        defined as spars with appropriate pinnned and align settings.
        
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
        position = self.interpolate (surface, x_location, x_offset)
        if pinned:
            position = (position[0], self.profile_min[1])
        self.spars.append(self.rect2path(position, size))

    def rect2path(self, pos, size):
        '''
        returns a set of coordiantes for the given rectangle
        of pos = (x,y) and size=(width, height)
        '''
        path = [
            (pos[0],         pos[1]),
            (pos[0]+size[0], pos[1]),
            (pos[0]+size[0], pos[1]+size[1]),
            (pos[0],         pos[1]+size[1])
        ]
        return path


    def interpolate(self, curve, xpos, offset = (0,0)):
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
            # point found on a segment with infinite slope
            return (xpos, (p0[1]+p1[1])/2.0)

        m = ((p1[1]-p0[1])/(p1[0]-p0[0]))
        ypos = m*(xpos-p0[0])+p0[1]
        return(xpos-offset[0], ypos-offset[1])


    def basic_rib(self, le_size, te_size, sp_size, to_mm=1):
        '''
        defines a classic balsa model plane rib pattern with solid leading
        and tailing edges and one main spar at 33% of the chord.
        '''

        # Apply conversion to the spars sizes
        le_size = [to_mm * x for x in le_size]
        te_size = [to_mm * x for x in te_size]
        sp_size = [to_mm * x for x in sp_size]

        #  add_spar( surface, size, percent, aligment, pinned)
        #self.add_spar(self.lower, le_size, 0.00, (0,0), True)  # LE
        self.add_spar(self.upper, sp_size, 0.27, (0,1), False) # Spar
        self.add_spar(self.upper, te_size, 1.00, (1,0), True)  # TE

        # Optionally make LE a diamond
        self.add_diamond_le(self.upper, le_size[0], .5)

        # Add the profile to the clipper
        self.clipper.AddPath(pyclipper.scale_to_clipper(self.profile, self.SCALING_FACTOR), pyclipper.PT_SUBJECT, True)

        # The second operand is a list of spars
        self.clipper.AddPaths(pyclipper.scale_to_clipper(self.spars, self.SCALING_FACTOR), pyclipper.PT_CLIP, True)

        # Subtract the spar cutouts from the profile 
        rib_path = self.clipper.Execute(pyclipper.CT_DIFFERENCE, pyclipper.PFT_EVENODD, pyclipper.PFT_EVENODD)

        return(pyclipper.scale_from_clipper(rib_path, self.SCALING_FACTOR))


