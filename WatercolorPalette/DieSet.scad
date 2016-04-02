$fn=48;

translate([25, 0, 0]) die();
mold();

module die() {
    profile();
    translate([0, 0, -5]) cube([20, 25, 10], center=true);
}


module mold() {
    rotate([0, 180, 0])
        difference() {
            translate([0, 0, 5]) cube([20, 25, 10], center=true);
            profile(1);
        }
}


module profile(tol=0) {
    intersection() {
        translate([0, 0, 5]) cube([15+tol,20+tol,10], center=true);
        translate([0, 0, 0]) scale([1.0,1.25,.25]) sphere(r=10);
    }
}