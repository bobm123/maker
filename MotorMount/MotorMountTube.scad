use <Servo9g.scad>
use <MotorMount1811.scad>

SERVO_WIDTH = 23.5;
SERVO_HEIGHT=23.5;
SERVO_DEPTH=12.3;

MOUNT_WIDTH=32.5;
MOUNT_HEIGHT= 2.5;
MOUNT_DEPTH=12.3;
MOUNT_OFFSET=15.8;

OUTPUT_HEIGHT = 4.5;


MOUNTING_PLATE = 20;

//%translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT-5.5]) 
//    rotate([0,90,90]) servo9g();

//cube ([4, SERVO_HEIGHT, 4]);


difference() {
    MotorMount();
    translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT-5.5]) 
        rotate([0,90,90]) scale(1.02) servo9g();
    translate([SERVO_DEPTH/2, SERVO_HEIGHT+1, (SERVO_WIDTH-8.9)]) 
        cube(1.01*[SERVO_DEPTH, 2, 7], center = true);
    #translate([SERVO_DEPTH+2, 0, 12])
        cube([20, 25, 15]);


    //translate([24, SERVO_WIDTH/2, 2]) rotate([0, 0, 45])      MotorMount1811();
}

module stalk() {
    OFFSET = 6.25;
    RAD = 1.5;

    difference() {
        translate([0, 0, 0]) square([OFFSET, 5+RAD]);
        hull() {
            translate([RAD, 0, 0]) circle(RAD, $fn=24);
            translate([OFFSET-RAD, 0, 0]) circle(2, $fn=24);
        }
        hull() {
            translate([RAD, 5.5+RAD, 0]) circle(RAD, $fn=24);
            translate([OFFSET-RAD, 5.5+RAD, 0]) circle(2, $fn=24);
        }
    }
}

module MotorMount() {
    translate([25, SERVO_WIDTH/2, 0]) {
        difference() {
            cylinder(h=18, r1=10/2, r2=10/2, $fn=48);
            cylinder(h=18, r1=6/2, r2=6/2, $fn=48);
        }
    }
    translate([SERVO_DEPTH+2, SERVO_WIDTH/2-3.5, 0]) 
        linear_extrude(height = 20) 
            stalk();
    linear_extrude(18) {
        difference() {
            minkowski() {
                square([SERVO_DEPTH, SERVO_WIDTH]);
                circle(2, $fn=24);
            }
            square([SERVO_DEPTH, SERVO_WIDTH]);
        }
    }

    translate([SERVO_DEPTH/2, -2, SERVO_WIDTH-11.5]) 
        rotate([90, 0, 0])
            cylinder(h=3, r1 = 3, r2 = 0, $fn=48);
}