//# Copyright (C) 2017 Robert Marchese
//
// An alternative to the standard linear extrusion operation.
//
// A list of 2D coordinates is transformed by the given parametes 
// and moved to the z=h plane. The original and transformed set of 
// points are used to generate a polyhedron.
//
// This program is available under the Creative Commons 
// Attribution-ShareAlike License; additional terms may apply. 
// 
// References:
// https://en.wikipedia.org/wiki/Transformation_matrix#Affine_transformations
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
//

// Examples
// Test points form a little house shape centered on [0,0]
points = [[-5,-5],[5,-5],[5,5],[0,7],[-5,5]];


//translate([-15,0,0]) polygon(points);

// height 10, no other transforms
//alt_extrude(points, 10);
stretch (
    points,
    transform_matrix(0, 0, [.2,2],[0,5]),
    transform_matrix(10, -10, [.2,1.5], [0,5]));
stretch (
    points,
    transform_matrix(10, -10, [.2,1.5], [0,5]),
    transform_matrix(20, -20, [.2,1.25], [0,5]));
stretch (
    points,
    transform_matrix(20, -20, [.2,1.25], [0,5]),
    transform_matrix(30, -30, [.2,1.125], [0,5]));
rotate([0,0,45]) translate([0,-0,0]) cube([1,1,80], center=true);

// height 10, top surface scaled to half size
translate([15,0,0]) alt_extrude(points, 10, 0, [.5,.5]);

// height 15, rotated 45 deg counter clockwise
translate([30,0,0]) alt_extrude(points, 15, -45, [1, 1]);

// height 10, rotated 20 deg and scaled 75% in X, 125% in Y
translate([45,0,0]) alt_extrude(points, 10, 20, [.75,1.25]);

// height 10, skewed left x=3 and down 2
translate([60,0,0]) alt_extrude(points, 10, 0, [1,1], [3,-2]);
// Examples
//

// Dot product of two vectors of length 3.
function dot(a, b) = a[0]*b[0]+a[1]*b[1]+a[2]*b[2];

// Generates a transfrom matrix from the given paramers
// h - the Z-axis value the polygon is moved to
// a - rotation angle
// s - scale factors, a vector [Sx, Sy]
// t - translation value, a vector [Tx, amd Ty]
// Returns a 3x3 matrix for the Rotation, Scale and 
// Translation (in that order)
/*
function transform_matrix(h=0, a=0, s=[1,1], t=[0,0]) = 
    [[s[0]*cos(a), -s[1]*sin(a), t[0]],
     [s[0]*sin(a),  s[1]*cos(a), t[1]],
     [          0,            0, h]];
*/
function transform_matrix(h=0, a=0, s=[1,1], t=[0,0]) =
    [[s[0]*cos(a), -s[1]*sin(a), t[0]*s[0]*cos(a)-t[1]*s[1]*sin(a)],
     [s[0]*sin(a),  s[1]*cos(a), t[0]*s[0]*sin(a)+t[1]*s[1]*cos(a)],
     [          0,            0, h]];

// Stiches together two sets of 2D polygon points seperated to for a 
// polyhedron. The two sets of points are generated by extending the
// original set into 3D (by adding a 3D coordinate, Z=1) and then
// transforming them with the two matricies, m0 and m1. 
module stretch(p2d, m0, m1) {
    n = len(p2d);

    p = [ for(i=[0:n-1]) [p2d[i][0], p2d[i][1], 1] ];

    p0 = [for(i=[0:n-1]) [dot(p[i],m0[0]), dot(p[i],m0[1]), dot(p[i],m0[2])] ];
    p1 = [for(i=[0:n-1]) [dot(p[i],m1[0]), dot(p[i],m1[1]), dot(p[i],m1[2])] ];

    bottom = [[for(i=[0:n-1]) i]];
    top    = [[for(i=[2*n-1:-1:n]) i%(2*n)]];
    sides  = [ for (i=[0:n-1]) [(0+i)%n+n,(1+i)%n+n,(1+i)%n,(0+i)%n]];
    all_faces = concat(bottom, top, sides);

    polyhedron(concat(p0, p1), all_faces);
}


// Form a polygon from the points p. The bottom surfaces is
// and n-gon defined by p while the top surface is generated
// from these by applying transforms given in the parameters
// 
//  p - The set of points forming the base of the polyhedron
//  h - The height of the polyhedron
//  ang-Rotation of the top surface around [0,0]
//  s - A vector length 2 defining the scale factors for x and Y
//  t - A vector defining the translation distance. Note, this
//      transform is applied after all of the others.
//
module alt_extrude(p, h=1, ang=0, s=[1,1], t=[0,0]) {
    stretch (
        p,
        transform_matrix(),
        transform_matrix(h+1, ang, s, t));
/*
    n = len(p);

    // Generate the transform matrix for top surface. Could be
    // 2x2, but the last column defines a skew tanslation. 
    M =[[s[0]*cos(ang), -s[1]*sin(ang), t[0]],
        [s[0]*sin(ang),  s[1]*cos(ang), t[1]],
        [            0,              0, 1]];

    // Extend coords for bottom to 3D, using z=1 (see Affine
    // Transforms reference above)
    p0 = [ for(i=[0:n-1]) [p[i][0], p[i][1], 1] ];

    // Apply transform matrix to x and y values of p0. Z value is
    // overwritten since it would be ignored for this 2D transform
    // and it is convenient to do it here.
    p1 = [for(i=[0:n-1]) [dot(p0[i],M[0]), dot(p0[i],M[1]), h+1] ];

    // Each faces is defined by a list of vertcies taken from
    // p0 and p1. The top and bottoms are all the p0 and p1
    // taken in clockwise order when looking at the final polyhedron
    // from outside. The others are two points from p0 and the 
    // corresponding 2 from p1.
    bottom = [[for(i=[0:n-1]) i]];
    top   = [[for(i=[2*n-1:-1:n]) i%(2*n)]];
    sides = [ for (i=[0:n-1]) [(0+i)%n+n,(1+i)%n+n,(1+i)%n,(0+i)%n]];
    all_faces = concat(bottom, top, sides);

    // Generate the polyhedron and translate down 1 unit to compensate
    // for offset used to expand 2D points into 3D
    translate([0,0,-1]) polyhedron(concat(p0, p1), all_faces);
*/
}
