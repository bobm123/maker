use <No6_Hardware.scad>

mm = 25.4;

fwd_incidence = 1;
z_thickness = 7.5;
y_thickness = 2.4;
tail_boom = 4;
wall = 2.4;

translate([0, 24, 0]) aft_diheadral_brace();
translate([0, 18, 0]) aft_wing_joiner();
translate([0, 6, 0]) fwd_diheadral_brace();
translate([0, 0, 0]) fwd_wing_joiner();
translate([-20, -12, 0]) stab_joiner();
translate([20, -12, 0]) stab_joiner();

module stab_joiner() {
    connecting_ring(4);
    stab_platform();
    mirror([1,0,0]) stab_platform();
}

module stab_platform() {
    sc = 2;
    w = 1.2;

    translate([-tail_boom/2, 0, 0]) {
        rotate([0, 0, 36.86]) 
            translate([-wall/2, (5*sc)/2-w/2, 4/2]) 
                cube([w, (5*sc), 4], center=true);
        translate([-3, (4*sc)-wall/2, 4/2]) 
                cube([6+tail_boom, w, 4], center=true);
    }
}

module connecting_ring(z_length=z_thickness) {

   translate([0,-(tail_boom+wall)/2,(z_length)/2]) 
        difference() {
            cube([(tail_boom+wall), (tail_boom+wall), z_length], center=true);
            cube([tail_boom, tail_boom, z_length], center=true);
        }
}

module arm(length, angle, offset=0)
{
    difference () {
        translate([0,offset,0])
            linear_extrude(height=z_thickness)
                rotate([0,0,angle])
                    square([length,y_thickness]);

        #screw_holes(length/2, angle);
    }
}

module screw_holes(length=12, angle=10) {
rotate([0,0,angle]) 
    translate([length,y_thickness+.01,z_thickness/2]) 
        rotate([90,0,0]) 
            machine_screw6(1/4*mm);
}

module aft_wing_joiner() {
    #arm(20, 10, -y_thickness);
    mirror([1,0,0]) arm(20, 10, -y_thickness);
    translate([0, 1.2-y_thickness, 0]) connecting_ring();
}

module aft_diheadral_brace() {
    arm(20, 10, 0);
    mirror([1,0,0]) arm(20, 10, 0);
}

module fwd_wing_joiner() {
    arm(30, 10, -y_thickness);
    mirror([1,0,0]) arm(30, 10, -y_thickness);
    translate([0, 0, 0]) { // [0,-1,0] for 1 mm fwd incidence?
        translate([0, -y_thickness/2, 0]) connecting_ring();
        translate([0,-1.2, z_thickness/2])
            cube([tail_boom+wall, 2.4, z_thickness], center=true);
    }
}

module fwd_diheadral_brace() {
    arm(30, 10, 0);
    mirror([1,0,0]) arm(30, 10, 0);
}

module diheadral_brace() {
    difference() {
    translate([0,0,0]) linear_extrude(height=7.2)  {
        rotate([0,0,10]) square([24,2.4]);
        rotate([0,0,-10]) translate([-24,0,0]) square([24,2.4]);
    }
    screw_holes();
    }
}