// (c)2015 Bob Marchese <bobm123@gmail.com>
// Based on work by Felipe Sanches <juca@members.fsf.org>
// licensed under the terms of the GNU GPL version 3 (or later)
use <voronoi3d.scad>

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
/* debug point generator
points=random_points(3, 3, 3, 20, 5);
echo(points);
for (p=points) {
  translate(p) sphere(r=2, $fn=20);
}
*/
translate([0, 50, 75]) rotate([180, 0, 0]) {
  lamp(t=2, w=50, h=75, hi=55, wi=24);
  color("Yellow", .05) {
    translate([0, .75, 0]) cube([50, .5, 75]);
    translate([.75, 0, 0]) cube([.50, 50, 75]);
    translate([0, 48.75, 0]) cube([50, .5, 75]);
    translate([48.75, 0, 0]) cube([.50, 50, 75]);
  }
}

module lamp(t=2, w=50, h=65, hi=55, wi=20) {
  frame(t, w, h, hi, wi);
  difference () {
    cube([w, w, h]);
    translate([4.5, 4.5, 0]) voronoi3d(random_points(3, 3, 5, 16, 9, seed=15), L=50, thickness=.5, round=.5);
    translate([1+(w-wi)/2, 1+(w-wi)/2, 1+h-hi]) cube([wi-2, wi-2, hi]);
    #translate([w/2, w/2, 21]) rotate([0, 180, 45]) cylinder(h=10, r1=12*1.41, r2=3, $fn=4);
  }
  translate([w/2, w/2, 20]) rotate([0, 180, 45]) difference() {
    cylinder(h=10, r1=12*1.41, r2=3, $fn=4);
    cylinder(h=9, r1=11*1.41, r2=2, $fn=4);
  }
  difference() {
    translate([(w-wi)/2, (w-wi)/2, h-hi]) cube([wi, wi, hi]);
    translate([1+(w-wi)/2, 1+(w-wi)/2, h-hi]) cube([wi-2, wi-2, hi+5]);
  }
}

module frame(t=2, w=50, h=65, hi=55, wi=25) {
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
