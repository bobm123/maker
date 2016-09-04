mm = 25.4;
tol = .15; //Tolerance for hole cleanrences
$fn = 48;

//assembly();
print_layout();

shaft_r = .5*(1/8)*mm;

cavity_r = 2.6;
cavity_h = 6;
flange_r = 6;
lever_h = 7;
base_t = 1.2;

module print_layout()
{
    translate([0, 0, 0]) case();
    translate([6, 10, 0]) cap();
    translate([-5,18,0]) lever();
}

module assembly()
{
    rotate([90, 0, 0]) {
        color("yellow") translate([0, 0, 23]) cap();
        color("gray") {
            translate([0, 0, 7]) difference () {
                translate([0,0,0]) cylinder(h=10, r=shaft_r+tol);
                translate([0,0,-.1]) cylinder(h=10.2, r=shaft_r-.5);
            }
            translate([0, 0, 19]) cube([1, 4, 4], center = true);
        }
        color("red") translate([0, 0,-1.5]) case();
        color("blue") rotate([0, 0, -120]) translate([0,0,-15]) rotate([0, 180, 0]) lever();
    }
}
module lever()
{
    difference() {
        union () {
            translate([ 0,0,0]) cylinder(h=.5, r=flange_r);
            translate([ 0,0,.5]) cylinder(h=1, r1=flange_r, r2=flange_r-1);
            translate([ 0,0,0]) cylinder(h=lever_h, r=flange_r-1);
            translate([ 0,0,lever_h-1.5]) cylinder(h=1, r1 =flange_r-1, r2=flange_r);
            translate([ 0,0,lever_h-.5]) cylinder(h=.5, r=flange_r);
            translate([ 0,0, 3*.707])rotate([45,0,0]) hull() {
                translate([ 0,0,0]) cube(3, center=true);
                translate([15,0,0]) sphere(r=3*.707, center=true);
            }
        }
        translate([0,0,-1]) cylinder(h=15, r=shaft_r+tol);
    }
}

module cap()
{
    difference() {
        translate([0,0, 0]) cylinder(h=cavity_h+.8, r=cavity_r+2);
        translate([0,0, .81]) cylinder(h=cavity_h, r=cavity_r+1+tol);
    }
}


module screw()
{
    cylinder(h=5, r=1);
    cylinder(h=1, r1=2, r2=1);

}

module case() {
    difference() {
        union() {
            translate([0, 0, base_t]) cylinder(h=cavity_h, r=cavity_r+1);
            hull() {
                cylinder(h=base_t, r=flange_r);
                translate([ 9, 0, 0]) cylinder(h=base_t, r=3);
                translate([-9, 0, 0]) cylinder(h=base_t, r=3);
            }
        }
        translate([0, 0, 3.1]) cylinder(h=cavity_h, r=cavity_r);
        translate([ 9, 0, -.02]) screw();
        translate([-9, 0, -.02]) screw();
        translate([0,0,-1]) cylinder(h=8, r=shaft_r+tol);
    }
}

