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
    #translate([SERVO_DEPTH/2, SERVO_HEIGHT+1, (SERVO_WIDTH-8.9)]) 
        cube(1.01*[SERVO_DEPTH, 2, 7], center = true);
    translate([24, SERVO_WIDTH/2, 2]) rotate([0, 0, 45]) MotorMount1811();

}


module MotorMount() {
    linear_extrude(2) {
        difference() {
            minkowski() {
                square([MOUNTING_PLATE+SERVO_DEPTH, SERVO_WIDTH]);
                circle(2, $fn=24);
            }
            square([SERVO_DEPTH, SERVO_WIDTH]);
        }
    }

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

    translate([SERVO_DEPTH+2, SERVO_WIDTH, 2]) 
        rotate([90, 0, 0]) 
            linear_extrude(SERVO_HEIGHT)
                polygon([[0,0], [0,3], [3,0]]);
}