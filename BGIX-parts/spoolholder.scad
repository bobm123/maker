
$fn=60;

inner_608 = 8/2;
outer_608 = 22/2;
heigt_608 = 7;
tol=.15;

spool_width = 80;

frame_side();
translate([100,44,0]) rotate([0,0,180]) frame_side();
translate([30,22,0]) roller();
translate([70,22,0]) roller();
translate([20,4,0]) pin();
translate([20,40,0]) pin();
translate([60,4,0]) pin();
translate([60,40,0]) pin();

//hub(7);
//bearing608();
//translate([30,25,0]) roller();
//translate([20,2,0]) pin();

module pin() 
{
    rad = inner_608+.5;

    difference() {
        union() {
            translate([0,0,rad*cos(30)]) rotate([90,0,90]) 
                cylinder(r=rad, h=20, $fn=6);
            translate([7,0,rad-.5]) rotate([90,0,90])
                cylinder(r=rad+1, h=2, $fn=24);
        }
        translate([5,-5,-10]) cube([10,10,10]);
    }
}

module roller ()
{
    difference() {
        cylinder(r=outer_608, h=spool_width);
        translate([0,0,-.01])
            cylinder(r=inner_608+.5+tol, h=12, $fn=6);
        translate([0,0,spool_width-12+.01])
            cylinder(r=inner_608+.5+tol, h=12, $fn=6);
    }
}

module frame_side ()
{
    thickness=7;
    
    hub(thickness);
    translate([100,0,0]) hub(thickness);
    translate([18,-15,0]) cube([64,10,thickness]);
}

module hub(thickness)
{
    offset=0;
    difference () {
        hull() {
            translate([-18,-15,0]) cube([36,10,thickness]);
            cylinder(r=15, h=thickness);
        }    
        translate([0,0,offset]) cylinder(r=outer_608+tol,h=7);
        cylinder(r=inner_608, h=30, center=true);
        translate([-.5,10,-.05]) cube([1,6,thickness+.1]);
    }
}

module bearing608()
{
    difference () {
        cylinder(r=outer_608,h=7, $fn=48);
        translate([0,0,-.05]) cylinder(r=inner_608,h=7.1, $fn=24);
    }
}