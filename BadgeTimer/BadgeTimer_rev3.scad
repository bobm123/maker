mm = 25.4;
tol = .15; //Tolerance for hole cleanrences
$fn = 48;

//assembly();
print_layout();

shaft_r = .5*(1/8)*mm;

cavity_r = 3;
cavity_h = 5;
flange_r = 8;
lever_h = 5;
base_t = 1.2;

module print_layout()
{
    translate([0, 0, 0]) case();
    translate([7, 11, 0]) cap();
    translate([-7,14,0]) rotate([0,0,30]) lever();
}

module assembly()
{
    rotate([90, 0, 0]) {
        translate([0, 0, 35]) rotate([180, 0, 0]) cap();
        color("gray") {
            translate([0, 0, 10]) difference () {
                translate([0,0,0]) cylinder(h=10, r=shaft_r+tol);
                translate([0,0,-.1]) cylinder(h=10.2, r=shaft_r-.5);
            }
            translate([0, 0, 22]) cube([1, 4, 5], center = true);
        }
        translate([0, 0,-1.5]) case();
        rotate([0, 0, -120]) translate([0,0,-10]) rotate([0, 180, 0]) lever();
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
            translate([ 0,0,1.7*sqrt(3)/2]) rotate([0,90,0]) rotate([0,0,30]) cylinder(r=1.7, h=14, $fn=6); 
/*
            translate([ 0,0,1.1]) rotate([45,0,0]) cube([14, 2, 2]); 
            translate([ 0,0,2.6]) rotate([0,90,0]) cylinder(h=12, r=1.5);
            translate([12,0,2.6]) sphere(r=1.5, center=true);
*/
        }
        translate([0,0,-1]) cylinder(h=15, r=shaft_r+tol*.75);

        for (a=[30:60:360]) {
            rotate([0,0,a]) translate([flange_r/2+.6,0,-1]) rotate([0,0,30])cylinder(h=10, r=1.8, $fn=6);
        }

    }
}

module cap()
{
    difference() {
        translate([0,0, 0]) cylinder(h=cavity_h+base_t+.8, r=cavity_r+2);
        translate([0,0, .81]) cylinder(h=cavity_h+base_t, r=cavity_r+1+tol);
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
            translate([0, 0, base_t]) cylinder(h=cavity_h+base_t, r=cavity_r+1);
            hull() {
                cylinder(h=base_t, r=cavity_r+3);
                translate([ 10, 0, 0]) cylinder(h=base_t, r=3);
                translate([-10, 0, 0]) cylinder(h=base_t, r=3);
            }
        }
        translate([0, 0, 2*base_t+.1]) cylinder(h=cavity_h, r=cavity_r);
        translate([ 10, 0, -.02]) screw();
        translate([-10, 0, -.02]) screw();
        translate([0,0,-1]) cylinder(h=8, r=shaft_r+tol);
    }
}

