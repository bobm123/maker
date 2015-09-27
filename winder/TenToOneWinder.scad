// Design of a 10:1 rubber motor winder.
// Intended so all the part fit on a 10 x 10 x 10 cm 
// 3D printer.

// TODO: 
// - Decouple some of the design cutouts from the assembly 
// view. Make sure can generate an exploded view without 
// breaking the parts.
// - Gear details: thickness, grub screws and magnets
// - Define shell spacers
// - Check diameter of hardware
// - Hex nut and screw head cutouts for case parts.
//

use <GearSet_10to1.scad>
use <fillets.scad>

$fn = 24;

// Each gear's pitch diameter
gear9_dia = 15;
gear27_dia = 45;
gear30_dia = 50;

// a little exatra spacing to account for printing
gear_slop = .5;

// Clearence around the gears for the case
case_clearence = 4;

// Diameter of the 1/8" shaft hardware
shaft_dia = 1.580;

// Display Transparency (alpha)
alpha = 1;

// Place the screw around the case shell 
screw1_pos = [(gear9_dia+gear30_dia)/4+14, gear27_dia/4 +(gear9_dia+gear27_dia)/4 +3, 0];
screw2_pos = [(gear9_dia+gear30_dia)/4+.5, -(gear27_dia+gear30_dia)/4-2, 0];
screw3_pos = [-(gear9_dia+gear27_dia)/4+1.5, (gear9_dia+gear27_dia+gear27_dia)/4+.5, 0];


// Each Gears position, defines the case size 
input_gear_pos = [gear_slop+(gear30_dia+gear9_dia)/2, 0, 0];
mid_gear_pos = [0, 0, 0,];
drive_gear_pos = [0, gear_slop+(gear27_dia+gear9_dia)/2, 0];


assembly_drawing();


// Winder Assembly Drawing
module assembly_drawing() {
    difference () {
        union() {
            drive_train();
            translate([0, 0, 11]) case_top();
            translate([0, 0, -3]) case_bottom();
            translate([0, 0, -24]) crank_arm();
            translate([-75, 0, -29.5]) crank_knob();
            translate([-75, 0, -47])  crank_pin();            
            translate([0, 0, -24]) drive_pin(); 
            
            // for debug reference
            //case_shell();
        }
        place_shafts();
    }
}


module crankshaft_core() {
    translate([0, 0, -3.1])
        linear_extrude (40.1)
            rotate([0, 0, 45]) square(8, center=true);
    translate([0, 0, 10])
        cylinder(13, 8*sqrt(2)/2, 8);
    
}


 module drive_pin() {
    translate(input_gear_pos) {
        rotate([0, 0, 45])
            difference() {
                rotate([0,0,-45])
                    crankshaft_core();

                linear_extrude(30)
                    translate([8,0,0])
                        square([8,14], center=true);
            }
    }
}


module crank_arm() {
    translate(input_gear_pos) {
        difference () {
            union() {
                minkowski() {
                   linear_extrude (8) {
                        circle(8);
                        translate([-75, 0, 0]) circle(8);
                        translate([-75, -5, 0]) square([75,10]);
                    }
                    sphere(2);
                }
                translate([0, 0, -3]) {
                    linear_extrude (1) {
                        circle(8);
                        translate([-75, 0, 0]) circle(7);
                    }
                }
                translate([-8.8, -4.2, -3])
                    linear_extrude (1)
                        scale([.625,1,1])
                            rotate([0,180,0])
                                import("MaxLogo.dxf");
            }
            crankshaft_core();
            translate([-75, 0, -4]) 
                linear_extrude (28)
                    circle(1.5);
            translate([-75, 0, 8]) 
                linear_extrude (2)
                    circle(3.2, $fn=6);
        }
    }
    
}


module crank_knob() {
    translate(input_gear_pos)
        rotate([180, 0, 0])
            difference () {
                minkowski() {
                    linear_extrude (16)
                        intersection() {
                            square ([12,6], center=true);
                            circle(6);
                        }
                    sphere(2);
                }
                translate([0, 0, 12]) cylinder(6, 3.5, 3.5);
                translate([0, 0, -2]) cylinder(20, 2.1, 2.1);
            }
}


module crank_pin()
{
    translate(input_gear_pos)
        difference () {
            union() {
                translate([0, 0, 0]) cylinder(4, 3, 3);
                translate([0, 0, 0]) cylinder(20, 2, 2);
            }
            translate([0, 0, 0]) cylinder(20, 1.5, 1.5);
        }
}


module case_top() {
    color("Blue", 1) {
        fillet(r=2,steps=6) {
            minkowski() {
                case_shell();
                rounding_upper(2);
            }
            translate([0, 0, 3.9])
                translate(drive_gear_pos) cylinder(15, 6, 4);
        }
    }
}


module case_bottom() {
    color("Blue", 1) {
        difference () {
            fillet(r=2,steps=6) {
                minkowski() {
                    case_shell();
                    rounding_lower(2);
                }
                translate([0, 0, -10.9])
                    translate(input_gear_pos) cylinder(9, 8, 8);
            }
            translate([0, 0, -21])
                translate(input_gear_pos)
                    crankshaft_core();
        }
    }
}


module rounding_lower(rr) {
    difference() {
        sphere(rr);
        translate([-rr, -rr, 0])
            cube([rr*2,rr*2,rr]);
    }
}


module rounding_upper(rr) {
    difference() {
        sphere(rr);
        translate([-rr, -rr, -rr]) cube([rr*2,rr*2,rr]);
    }
}


module case_shell() {
    linear_extrude(2) {
        hull() {
            translate(input_gear_pos) circle(case_clearence+gear30_dia/2, $fn=48);
            translate(mid_gear_pos) circle(case_clearence+gear27_dia/2, $fn=48);
            translate(drive_gear_pos) circle(case_clearence+gear9_dia/2);
        }
    }
}


module place_shafts() {
    // Gear Axels
    #translate([0, 0, -7.5]) {
        translate([0, 0, -20])
            translate(input_gear_pos) cylinder(55, shaft_dia/2, shaft_dia/2);
        translate(mid_gear_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
        translate(drive_gear_pos) cylinder(40, shaft_dia/2, shaft_dia/2);
    }
    
    // Screw positions
    #translate([0, 0, -7.5]) {
        translate(screw1_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
        translate(screw2_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
        translate(screw3_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
    }
}


module drive_train()
{
    mid_gear();
    translate(input_gear_pos)
        rotate([0, 0, 90])
            imput_gear();
    translate(drive_gear_pos)
        drive_gear();
}


module mid_gear() {
    color("Goldenrod", alpha) {
        linear_extrude(5)
            gear27();
        translate([0,0,5])
            linear_extrude(5)
                gear9();
    }
}


module imput_gear() {
    color("Gold", alpha) {
        translate([0,0,5])
            linear_extrude(5)
                gear30();
        cylinder(5, 15/2, 15/2);
    }
}

module drive_gear() {
    color("Sienna", alpha) {
        linear_extrude(5)
            gear9();
        translate([0,0,5])
            cylinder(5, 17.51/2, 17.51/2);
    }
}