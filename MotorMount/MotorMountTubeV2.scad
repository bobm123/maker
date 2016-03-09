use <Servo9g.scad>
use <MotorMount1811.scad>
use <No6_Hardware.scad>

STOL=.1;
SERVO_WIDTH = 23.5+STOL;
SERVO_HEIGHT=23.5+STOL;
SERVO_DEPTH=12.3+STOL;

MOUNT_WIDTH=32.5;
MOUNT_HEIGHT= 2.5;
MOUNT_DEPTH=12.3;
MOUNT_OFFSET=15.8;

OUTPUT_HEIGHT = 5;
ROUNDING = 2;

OFFSET = 6;
RAD = 1.5;

IN_TO_MM = 25.4;

motor_mount();
//cradle();

module cradle() {
    difference () {
        union () {
            translate([0, 0, SERVO_WIDTH-14]) {
                linear_extrude(height = 14) {
                    difference() {
                        translate([-9, -5, 0]) square([20,38]);
                        translate([-6.5, -2.5, 0]) square([20,32]);
                    }
                }
            }
            #translate([SERVO_DEPTH/2, -7.95, SERVO_WIDTH-SERVO_DEPTH/2])
                rotate([-90, 0, 0]) {
                    cylinder(h=5, r1 = 2.5, r2 = 4.5, $fn=48);
                }
        }
        translate([SERVO_DEPTH/2, -8.95, SERVO_WIDTH-SERVO_DEPTH/2])
            rotate([-90, 0, 0]) {
                cylinder(h=45, r1 = 1.4, r2 = 1.4, $fn=48);
            }
        motor_mount();
        translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT])
            rotate([0,90,90]) servo9g();
    translate([-6.5, 29, 17]) cube([16.25, 2, 7]);
    }
}


module motor_mount()
{
    difference() {
        union () {
            linear_extrude(height = SERVO_WIDTH)
                MountProfile();
            translate([SERVO_DEPTH/2, -2, SERVO_WIDTH-SERVO_DEPTH/2]) 
                rotate([90, 0, 0])
                    cylinder(h=3, r1 = 3, r2 = 0, $fn=48);
            translate([SERVO_DEPTH+MOUNT_HEIGHT+13.25, SERVO_WIDTH/2-4, 0]) cube([9,8,20]);
        }
        translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT])
            rotate([0,90,90]) servo9g();
        translate([0, SERVO_HEIGHT-.5, SERVO_WIDTH-SERVO_DEPTH/2]) 
            cube([SERVO_DEPTH, ROUNDING+1, 7]);
        translate([SERVO_DEPTH+2, 0, 12])
            cube([25, 25, 15]);
        translate([SERVO_DEPTH+MOUNT_HEIGHT+13, SERVO_WIDTH/2-.5, 0]) cube([9.5 ,1 ,20]);
        translate([SERVO_DEPTH+MOUNT_HEIGHT+16.75, SERVO_WIDTH/2-4.25, 6.5]) 
            rotate([-90,30,0]) screw_and_nut(11, tol=0.0);
        translate([SERVO_DEPTH/2, -4.95, SERVO_WIDTH-SERVO_DEPTH/2]) 
            rotate([-90, 0, 0])
                cylinder(h=3, r1 = 3, r2 = 0, $fn=48);

    }
}


module MountProfile() {

    // Servo Case
    difference() {
        minkowski() {
            square([SERVO_DEPTH, SERVO_WIDTH]);
            circle(ROUNDING, $fn=24);
        }
        square([SERVO_DEPTH, SERVO_WIDTH]);
    }

    // Shaft Support
    ext=.75;
    translate([SERVO_DEPTH+2, SERVO_WIDTH/2-3.5, 0]) {
        difference() {
            translate([0, -ext, 0]) square([OFFSET, 5+RAD+2*ext]);
            hull() {
                translate([RAD, -ext, 0])
                    circle(RAD, $fn=24);
                translate([OFFSET-RAD+ext/2, -ext, 0])
                    circle(RAD+.5, $fn=24);
            }
            hull() {
                translate([RAD, OUTPUT_HEIGHT+.5+RAD+ext, 0]) 
                    circle(RAD, $fn=24);
                translate([OFFSET-RAD+ext/2, OUTPUT_HEIGHT+.5+RAD+ext, 0]) 
                    circle(RAD+.5, $fn=24);
            }
        }
    }

    // Shaft Enclosure
    translate([25, SERVO_WIDTH/2, 0]) {
        difference() {
            circle(r=10.5/2, $fn=48);
            circle(r=6/2, $fn=48);
        }
    }
}
