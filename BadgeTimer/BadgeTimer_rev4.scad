mm = 25.4;
tol = .15; //Tolerance for hole cleanrences
$fn = 48;

print_layout();

shaft_r = .5*(1/8)*mm;

cavity_r = 4;
cavity_h = 6;
flange_r = 6;
lever_h = 7;
base_t = 1.2;
paddle_t = 2.8;
paddle_shaft = lever_h+base_t+1;

module print_layout()
{
    translate([0, 0, 0]) case();
    translate([6, 11, 0]) cap();
    translate([-5,20,0]) lever();
    translate([0,-10, 1.2]) paddle();
}

module paddle()
{

    translate([0, 0, 0]) 
        rotate([45, 0, 0]) 
            cube([paddle_shaft, paddle_t*.707, paddle_t*.707], center=true);
    
    translate([(paddle_shaft+base_t)/2, 0, 0])
        rotate([0,90,0])
            cylinder(r=paddle_t/2, h=base_t, center=true);

    translate([(paddle_shaft+cavity_h)/2+base_t, 0, 0]) 
        cube([cavity_h, 2*cavity_r-3, paddle_t], center=true);
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
        translate([0,0,lever_h/2]) 
            cube([paddle_t*.707+tol, paddle_t*.707+tol, lever_h+.02], center=true);
    }
}

module cap()
{
    difference() {
        translate([0,0, 0]) cylinder(h=cavity_h+base_t, r=cavity_r+1.6);
        translate([0,0, base_t+.01]) cylinder(h=cavity_h, r=cavity_r+.6+tol);
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
        translate([0, 0, base_t+.01]) cylinder(h=cavity_h, r=cavity_r);
        translate([ 9, 0, -.02]) screw();
        translate([-9, 0, -.02]) screw();
        translate([0,0,-1]) cylinder(h=8, r=paddle_t/2+tol);
    }
}

