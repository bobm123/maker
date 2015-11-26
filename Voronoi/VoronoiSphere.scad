use <voronoi3d.scad>

voronoi_sphere();

module voronoi_sphere(nuclei=true, thickness=4, round=4, nuclei=true) {
  n=25;
  seed=42;
  min=-100;
  max=100;
  point_set = [for (i = [0 : 1 : n]) rands(min, max, 3, seed+i)];
  echo(point_set);
  difference() {
    sphere(r=150, $fn=96);
  voronoi3d(points=point_set, L=200, thickness=thickness, round=round);
    sphere(r=150-2*thickness, $fn=96);
  }
  if(nuclei) {
    for (p=point_set) {
      translate(p) sphere(r=6);
    }
  }
}
