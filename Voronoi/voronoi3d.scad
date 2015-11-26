// (c)2015 Bob Marchese <bobm123@gmail.com>
// Based on work by Felipe Sanches <juca@members.fsf.org>
// licensed under the terms of the GNU GPL version 3 (or later)

point_set=random_points(3, 3, 3, 13, 12, seed=42);

//voronoi3d(point_set, L=50, thickness=1, round=1);
CubicSection(point_set);

//////////////////////////////////////////////////
// Generate points on a rectangular lattice offset 
// by a random offset (x,y,z) value
//////////////////////////////////////////////////
function grid(n, m, h, s, d=0) = [
  for (i = [0 : 1 : n-1])
    for (j = [0 : 1 : m-1])
      for (k = [0 : 1 : h-1])
        s*[i, j, k]
];

function offsets(c, d, seed=42) = [
  for (i = [0 : 1 : c])
    rands(0, d, 3, seed+i)
];

function random_points(n, m, h, s, d, seed=42) = grid(n, m, h, s, d) + offsets(n*m*h, d, seed);
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Visualize a set of regions by subtracting the 
// area the define from a cube then show the 
// nuclei as small spheres
//////////////////////////////////////////////////
module CubicSection(points) { 
  difference () {
    translate(-5*[1,1,1]) cube([50, 50, 50]);
    voronoi3d(points, L=50, thickness=1, round=1);
  }
  for (p=points) {
    translate(p) sphere(r=1, $fn=20);
  }
}


//////////////////////////////////////////////////
// Helper functions to find length of a vector and
// a normalize (fined the unit vector that points 
// in same same diretion as v)
//////////////////////////////////////////////////
function normalize(v) = v/(distance(v));
function distance(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Find a set of regions such that each contains 
// a set of points that are closer to one of the 
// given points than to any other.
//////////////////////////////////////////////////
module voronoi3d(points, L=50, thickness=6, round=6){
  for (p=points) {
    color(rands(0,1,3), .95)
    minkowski() {
      intersection_for(p1=points){
        if (p!=p1) {
          azmuth = atan2(p[1]-p1[1], p[0]-p1[0]);
          elevation = atan2(p1[2]-p[2], distance(p-p1)); 
          translate((p+p1)/2 - normalize(p1-p) * (thickness+round)) {
            rotate([0, elevation, azmuth])
            translate([0,-L, -L])
            cube([L, 2*L, 2*L]);
          }
        }
      }
      sphere(r=round);
    }
  }
}
//////////////////////////////////////////////////
