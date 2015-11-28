// (c)2015 Bob Marchese <bobm123@gmail.com>
//
// Yet another Voronoi style lamp. 
//
// Generates a set of Voronoi regions in 3-space
// with a small rounded gap between them, then
// subtract these from a cube and add a frame 
// and adds a space inside for a light source
use <voronoi3d.scad>

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

function random_points(n, m, h, s, d, seed) = grid(n, m, h, s, d) + offsets(n*m*h, d, seed);
//////////////////////////////////////////////////

//////////////////////////////////////////////////
// Orient the model for printing
//////////////////////////////////////////////////
translate([0, 50, 75]) rotate([180, 0, 0]) {
  lamp(t=2, w=50, h=75, wi=20, hi=55);
}
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Generate the lamp
//////////////////////////////////////////////////
module lamp(t=2, w=50, h=65, wi=17, hi=55) {
  frame(t, w, h, wi, hi);
  difference () {
    cube([w, w, h]);
    translate([4.5, 4.5, 0]) voronoi3d(random_points(3, 3, 5, 16, 9, seed=15), L=50, thickness=.5, round=.5);
    interior(w, h, wi, hi, solid=true);
  }
  interior(w, h, wi, hi, solid=false);

  // Add thin walls for support
  color("Yellow", .55) {
    translate([0, .75, 0]) cube([50, .5, 75]);
    translate([.75, 0, 0]) cube([.50, 50, 75]);
    translate([0, 48.75, 0]) cube([50, .5, 75]);
    translate([48.75, 0, 0]) cube([.50, 50, 75]);
  }
}
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Generate a obelisk shaped interior to hold a
// light source
//////////////////////////////////////////////////
module interior(w=50, h=65, wi=20, hi=55, solid=false) {
  difference() {
    union () {
      translate([(w-wi)/2, (w-wi)/2, h-hi]) cube([wi, wi, hi]);
      translate([w/2, w/2, 20]) rotate([0, 180, 45]) 
        cylinder(h=10, r1=wi*.707, r2=3, $fn=4);
    }
    if (!solid) {
      translate([1+(w-wi)/2, 1+(w-wi)/2, h-hi]) cube([wi-2, wi-2, hi]);
      translate([w/2, w/2, 20.1]) rotate([0, 180, 45])
        cylinder(h=9, r1=(wi-1)*.707, r2=2, $fn=4);
    }
  }
}
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Make the frame structure
//////////////////////////////////////////////////
module frame(t=2, w=50, h=65, wi=25, hi=55) {
  difference () {
    cube([w, w, h]);
    translate([-t, t, t]) cube([w, w, h-4]-2*[t, t, t]);
    translate([6, t, t]) cube([w, w, h-4]-2*[t, t, t]);
    translate([t, 6, t]) cube([w, w, h-4]-2*[t, t, t]);
    translate([t, -t, t]) cube([w, w, h-4]-2*[t, t, t]);
    translate([t,  t, -t]) cube([w, w, h]-2*[t, t, t]);
    translate([t,  t, 8]) cube([w, w, h]-2*[t, t, t]);
  }
}


