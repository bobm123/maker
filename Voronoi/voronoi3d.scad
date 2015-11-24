// (c)2015 Bob Marchese <bobm123@gmail.com>
// Based on work by Felipe Sanches <juca@members.fsf.org>
// licensed under the terms of the GNU GPL version 3 (or later)

/*point_set = [
  [-39, 27, -86], [57, -77, 11], [93, -21, 9], [75, -9, -36], [26, -73, -19], 
  [31, -44, 97], [31, 4, 69], [-58, -73, -95], [68, -85, 38], [76, -20, -34], 
  [-80, -84, 18], [54, -32, -88], [90, 49, 49], [31, -68, -43], [77, -95, -3], 
  [28, 53, 21], [-16, -91, -89], [9, 53, 24], [18, -82, 14], [-38, -57, 71]
];
*/


voronoi_sphere();
//voronoi3d(points=point_set, L=200, thickness=6, round=6);
//random_voronoi3d(L=200, thickness=6, round=6);


function normalize(v) = v/(distance(v));
function distance(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);


module voronoi_sphere(nuclei=true, thickness=4, round=4, nuclei=true) {
  difference() {
    sphere(r=150, center=true, $fn=96);
    random_voronoi3d(points=point_set, L=200, thickness=6, round=6);
    sphere(r=142, center=true, $fn=96);
  }
  if(nuclei) {
    for (p=point_set) {
      translate(p) sphere(r=6, $fn=20);
    }
  }
}


module random_voronoi3d(n=25, L=100, thickness=2, round=6, min=-100, max=100, seed=42) {
    
  point_set = [for (i = [0 : 1 : n]) rands(min, max, 3, seed+i)];
  voronoi3d(point_set, L, thickness, round);
}


module voronoi3d(points, L=150, thickness=2, round=6){
  for (p=points) {
    color(rands(0,1,3), .75) 
    minkowski() {
      intersection_for(p1=points){
        if (p!=p1){
          azmuth = atan2(p[1]-p1[1], p[0]-p1[0]);
          elevation = atan2(p1[2]-p[2], distance(p-p1)); 
          translate((p+p1)/2 - normalize(p1-p) * (thickness+round)) {
            rotate([0, elevation, azmuth])
            translate([0,-L, -L])
            cube([L, 2*L, 2*L]);
          }
        }
      }
      sphere(r=round, $fn=20);
    }
  }
}
