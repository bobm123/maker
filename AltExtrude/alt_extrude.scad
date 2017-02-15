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
// Test points are a set is a house shape cenetered on [0,0]
points = [[-5,-5],[5,-5],[5,5],[0,7],[-5,5]];

// height 10, no other transforms
alt_extrude(points, 10);

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

// Dot product of two vectors
function dot(a, b) = a[0]*b[0]+a[1]*b[1]+a[2]*b[2];


// Form a polygon from the points p. The bottom surfaces is
// and n-gon defined by p while the top surface is generated
// from these by applying transforms given in the parameters
// 
//  p - The set of points forming the base of the polyhedron
//  h - The height of the polyhedron
//  ang-Rotation of the top surface around [0,0]
//  s - A vector length 2 defining the scale factors for x and Y
//  t - A vector defining the translation distance
//
module alt_extrude(p, h=1, ang=0, s=[1,1], t=[0,0]) {

    n = len(p);

    // Generate the transform matrix for top surface. Could be
    // 2x2, but the last column could be used to define a skew
    // Translation. In that case the y-coord for p0 expansion
    // Must be 1 and h+1 used for p0. F
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
}


// TODO: Apply scale and rotate operations to points when generating
// pointsH. Could be done with 2x2 matrix multiplies then expand to 3D.
// Could H translation be performed at the same time? Possibly if
// expanded as with multmatrix (with a translate Z).

// Bottom Face
//points0 = [[0,0,0],[10,0,0],[10,10,0],[5,13,0],[0,10,0]];

// Top Face
//points6 = [[0,1,6],[10,1,6],[9,9,6],[5,13,6],[1,9,6]];

//N=len(points0);  // len of points and pointsH must be the same
//bottom = [[for(i=[0:N-1]) i]];
//top   = [[for(i=[2*N-1:-1:N]) i%(2*N)]];
//sides = [ for (i=[0:N-1]) [(0+i)%N+N,(1+i)%N+N,(1+i)%N,(0+i)%N]];
//all_faces = concat(bottom, top, sides);

//echo(all_faces);
//polyhedron(concat(points0, points6), all_faces);

// hadcoded values taken from example given here:
//https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
//face0 = [[0,0,0],[10,0,0],[10,10,0],[0,10,0]];
//face6 = [[0,1,6],[10,1,6],[9,9,6],[1,9,6]];
/*
CubeFaces = [
  [0,1,2,3],  // bottom
  [7,6,5,4],  // top

  [4,5,1,0],  // front
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
*/
