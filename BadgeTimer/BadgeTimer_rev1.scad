mm = 25.4;
tol = .1; //Tolerance for hole cleanrences
$fn = 48;

//assembly();
print_layout();

shaft_r = .5*(1/8)*mm;

module print_layout()
{
    translate([0, 0, 0]) case();
    translate([0,11,0]) plug();
    rotate([0, 180, 0]) translate([0,22,-3]) cap();
    translate([0,36,0]) lever();
}

module assembly()
{
    translate([0, 0, 0]) case();
    translate([0,0,2]) plug();
    translate([0,0,5.1]) cap();
    translate([0,0,6.2]) lever();
}

module lever()
{
    difference() {
        union () {
            translate([ 0,0,0]) cylinder(h=.5, r=6);
            translate([ 0,0,.5]) cylinder(h=1, r1=6, r2=4.75);
            translate([ 0,0,0]) cylinder(h=3, r=4.75);
            translate([ 0,0,2]) cylinder(h=1, r1 = 4.75, r2=6);
            translate([ 0,0,3]) cylinder(h=.5, r=6);
            hull() {
                translate([ 0,0,0]) cylinder(h=3.5, r=1.75);
                translate([15,0,0]) cylinder(h=3.5, r=1.75);
            }
        }
        translate([0,0,-1]) cylinder(h=15, r=shaft_r+tol);
    }
}

module cap()
{
    difference() {
        translate([0,0,0]) cylinder(h=3, r=6);
        translate([0,0,-.1]) cylinder(h=2, r=5.35);
        translate([0,0,-1]) cylinder(h=15, r=shaft_r+tol);
    }
}

module case() {
    difference() {
        union() {
            cylinder(h=7, r=5.25);
            cylinder(h=5, r=6);
            linear_extrude(height=1.5)
                minkowski()
                {
                    square([18, 5], center=true);
                    circle(r=1.5);
                }
        }
        translate([0,0,1.5]) cylinder(h=6, r=4.5);
        translate([ 8, 0, -2]) cylinder(h=10, r=1);
        translate([-8, 0, -2]) cylinder(h=10, r=1);
        translate([0,0,-.01]) cylinder(h=10, r=shaft_r+tol);
    }
}

module plug() {
    difference() {
        cylinder(h=5.3, r=3.25);
        translate([0,0,-1]) cylinder(h=10, r=shaft_r+tol);
    }
}