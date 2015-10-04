// Design of a 10:1 motor winder for small rubber powerd
// model planes. Designed so all the part fit on a small
// 10x10x10cm 3D printer.

use <fillets.scad>
use <GearSet_10to1.scad>
use <No6_Hardware.scad>

IN_TO_MM = 25.4;
$fn = 24;

// Each gear's pitch diameter
gear9_dia = 15;
gear27_dia = 45;
gear30_dia = 50;

// a little exatra spacing to account for printing
gear_slop = .5;

// Clearence around the gears for the case
case_clearence = 4;

// increase sizes around hardware for printing inaccuracies
tolerance = 0.1;

// Diameter of the 1/8" shaft hardware
shaft_dia = (1/8 * IN_TO_MM) + tolerance;

// Display Transparency (alpha)
alpha = 1;

// Place the screw around the case shell 
screw1_pos = [(gear9_dia+gear30_dia)/4+8, gear27_dia/4 +(gear9_dia+gear27_dia)/4+5.6, 0];
screw2_pos = [(gear9_dia+gear30_dia)/4-2.5, -(gear27_dia+gear30_dia)/4-2.05, 0];
screw3_pos = [-(gear9_dia+gear27_dia)/4+1.7, (gear9_dia+gear27_dia+gear27_dia)/4, 0];

// Each Gear's position, this defines the basic case size 
mid_gear_pos = [0, 0, 0,];
input_gear_pos = [gear_slop + (gear30_dia+gear9_dia)/2, 0, 0];
drive_gear_pos = [0, gear_slop + (gear27_dia+gear9_dia)/2, 0];

// View the complete assembly (don't print this)
rotate([90, 0, -90]) assembly_drawing();

// Prints the test block / bending jig
//translate([50, -50, 0]) test_block_stl();

// Working view of case bottom
//rotate([180, 0, 0]) case_bottom_stl();

// Working view of case top
//rotate([0, 0, 0]) case_top_stl();

// Re-oriented drive pin for printing
//rotate([90, 135, 0]) drive_pin_stl();

// Some work on the cank knob assembly..
//rotate([180, 0, 0]) crank_knob_stl();
//translate([0, 0, 18]) rotate([180, 0, 0]) crank_pin_stl();
//crank_arm_stl();

// Winder Assembly Drawing
module assembly_drawing() {
    //translate([0, 0, 14]) case_top_stl();
    translate([0, 0, 1]) drive_train();
    //translate([0, 0, -3]) case_bottom_stl();
    //translate([0, 0, -4]) case_spacers();
    translate(input_gear_pos) {
        translate([0, 0, -24]) crank_arm_stl();
        translate([-75, 0, -29.5]) crank_knob_stl();
        //translate([-75, 0, -48]) crank_pin_stl();
        translate([0, 0, -24]) drive_pin_stl(); 
    }
}


// prints a 36x18x24 mm block with a few holes to 
// determine if any extra tolerance in needed. Also
// can be used as a bending jig for the winder hook
module test_block_stl() {
    difference () {
        union () {
            cube([36, 18, 24]);
            translate([9, 9, 24]) cylinder(h=6, r1=9, r2=9);
        }
        
        // screw hole
        #translate([28, -.05, 12]) 
            rotate([-90, 0, 0]) screw_and_nut(18.1, tol = tolerance);
        
        // offset pin
        #translate([18+1.5*shaft_dia, 9, 0]) 
            cylinder(h=30, r1=shaft_dia/2, r2=shaft_dia/2, $fn=24);
        
        // centered pin
        #translate([9, 9, -.5]) 
            cylinder(h=31, r1=shaft_dia/2, r2=shaft_dia/2, $fn=24);
        
        // vertical slot
        #translate([22,8.5,0]) cube([15, 1, 30]);
    }
}


module crankshaft_core(tol = 0.0) {
    translate([0, 0, -3.1])
        linear_extrude (40.1)
            rotate([0, 0, 45]) square(8+tol, center=true);
    translate([0, 0, 10])
        cylinder(14, 8*sqrt(2)/2+tol, 8+tol);
    
}


module drive_pin_stl() {
    rotate([0, 0, 45])
        difference() {
            rotate([0,0,-45])
                crankshaft_core();

            linear_extrude(30)
                translate([8,0,0])
                    square([8,14], center=true);
            #translate([0, 0, 18])
                cylinder(25, shaft_dia/2, shaft_dia/2);
        }

}


module crank_arm_stl() {
    difference () {
        union() {
            minkowski() {
               linear_extrude (6) {
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
        crankshaft_core(tol=tolerance);
        translate([-75, 0, -23]) machine_screw6(33, tol=tolerance);
        #translate([-75, 0, 5.25]) hex_nut6(tol=tolerance);
    }
}


module crank_knob_stl() {
    translate([0, 0, -2]) {
        rotate([180, 0, 90]) {
            difference () {
                union () {
                    minkowski() {
                        linear_extrude (20)
                            intersection() {
                                square ([26,12], center=true);
                                circle(13);
                            }
                        sphere(1);
                    }
                    translate([0, 0, -4]) cylinder(4, 7, 7);
                }
                translate([-20, 45.75, 10]) 
                    rotate([0, 90, 0]) cylinder(40, 40, 40, $fn = 96);
                translate([-20, -45.75, 10]) 
                    rotate([0, 90, 0]) cylinder(40, 40, 40, $fn = 96);
                translate([0, 0, 10]) cylinder(14, 5, 5);
                translate([0, 0, -6]) cylinder(32, 3.5, 3.5);
                //translate([-10, 0, 0]) cube([20,10,30]);
            }
            //Inside supports
            //translate([-4.5, -.5, 12]) cube([9, 1, 13]);
            //translate([-.5, -4.5, 12]) cube([1, 9, 13]);
            //Outside supports
            translate([6, -5, -4]) cube([6, 1, 3]);
            translate([7.5, -.5, -4]) cube([5, 1, 3]);
            translate([6, 4, -4]) cube([6, 1, 3]);
            
            translate([-12, -5, -4]) cube([6, 1, 3]);
            translate([-12.5, -.5, -4]) cube([5, 1, 3]);
            translate([-12, 4, -4]) cube([6, 1, 3]);
        }
    }
}


module crank_pin_stl()
{
    translate([0, 0, 2]) 
    difference () {
        union() {
            cylinder(3, 4.5, 4.5);
            cylinder(20, 3, 3);
        }
        machine_screw6(33, tol=tolerance);
    }
}


module case_top_stl() {
    color("Blue", 1) {
        difference () {
            fillet(r=2,steps=6) {
                minkowski() {
                    case_shell();
                    rounding_upper(2);
                }
                translate([0, 0, 3.9])
                    translate(drive_gear_pos) cylinder(15, 6, 4);
            }
            // Shaft Positions
            translate(drive_gear_pos) cylinder(40, shaft_dia/2, shaft_dia/2);
            translate(input_gear_pos) cylinder(55, shaft_dia/2, shaft_dia/2);
            translate(mid_gear_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
            
            // Screw positions
            #translate([0, 0, 5]) {
                translate(screw1_pos) rotate([180, 0, 0]) machine_screw6(21, tol=tolerance);
                translate(screw2_pos) rotate([180, 0, 0]) machine_screw6(21, tol=tolerance);
                translate(screw3_pos) rotate([180, 0, 0]) machine_screw6(21, tol=tolerance);
            }    
        }
    }
}


module case_bottom_stl() {
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
                    crankshaft_core(tol=tolerance);
            
            // Gear Axels
            translate([0, 0, -7.5]) {
                translate(mid_gear_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
                translate(drive_gear_pos) cylinder(40, shaft_dia/2, shaft_dia/2);
            }
            translate([0, 0, -2]) {
                translate(screw1_pos) {
                    #rotate([0, 0, -20]) hex_nut6(tol = .1, solid=true);
                    translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw6(25);
                }
                translate(screw2_pos) {
                    #rotate([0, 0, -4.25]) hex_nut6(tol = .1, solid=true);
                    translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw6(25);
                }
                translate(screw3_pos) {
                    #hex_nut6(tol = .1, solid=true);
                    translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw6(25);
                }
            }
        }
    }
}


module case_spacers () {
    translate(screw1_pos) spacer_tube_stl();
    translate(screw2_pos) spacer_tube_stl();
    translate(screw3_pos) spacer_tube_stl();
}


module spacer_tube_stl() {
    color("Blue", 1) {
        difference ()  {
            translate([0, 0, 4]) cylinder(14, 4, 4);
            machine_screw6(22);
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
    linear_extrude(3) {
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
        translate(drive_gear_pos) cylinder(42, shaft_dia/2, shaft_dia/2);
    }
}


module drive_train()
{
    //rotate([0, 0, 60]) mid_gear_stl();
    translate(input_gear_pos) rotate([0, 0, 90]) input_gear_stl();
    //translate(drive_gear_pos)  drive_gear_stl();
}


module mid_gear_stl() {
    color("Goldenrod", alpha) {
        difference() {
            union () {
                linear_extrude(5) gear27();
                translate([0,0,5]) linear_extrude(7) gear9();
            }
            #translate([0,0,-1])
                cylinder(14, shaft_dia/2, shaft_dia/2);
        }
    }
}


module input_gear_stl() {
    color("Gold", alpha) {
        difference () {
            union () {
                translate([0,0,6])
                    linear_extrude(6)
                        gear30();
                translate([0, 0, -1])
                    cylinder(7, 15/2, 15/2);
            }
            translate([0,0,-25])
                crankshaft_core(tol=tolerance);
            translate([15,0,8.25])
                cube(4.75, center=true);    
        }
    }
}


module drive_gear_stl() {
    color("Sienna", alpha) {
        difference () {
            union() {
                linear_extrude(6)
                    gear9();
                translate([0,0,6])
                    cylinder(6, 17.51/2, 17.51/2);
            }
            #translate([0,0,-1])
                cylinder(14, shaft_dia/2, shaft_dia/2);
            translate([0, shaft_dia/2, 9])
                rotate([-90, 180, 0]){
                    machine_screw6(10);
                    hex_nut6_slot(10);
                }
                
        }
    }
}