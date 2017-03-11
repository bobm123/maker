SERVO_WIDTH = 23.5;
SERVO_HEIGHT=23.5;
SERVO_DEPTH=12.3;
SERVO_OUTPUT=4.5;

MOUNT_WIDTH=32.5;
MOUNT_HEIGHT= 2.5;
MOUNT_DEPTH=12.3;
MOUNT_OFFSET=15.8;



servo9g();

module servo9g() {
    $fn=48;
   
    color("Blue")
    translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT]) {
        linear_extrude(SERVO_OUTPUT) {
            translate([(1+SERVO_DEPTH)/2,0, 0]) circle(4.5/2);
            circle(SERVO_DEPTH/2);
        }
    }
    color("White")
    translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT+SERVO_OUTPUT]) {
        linear_extrude(3) {
            circle(4.7/2);
        }
    }
    color("White")
    translate([SERVO_DEPTH/2, 0, SERVO_HEIGHT+SERVO_OUTPUT+1]) {
        linear_extrude(2) {
            circle(7/2);
            hull() {
                circle(5.4/2);
                translate([0, 14.5, 0]) circle(4/2);
            }

        }
    }
    color("Blue")
    translate([0, SERVO_DEPTH/2, 0]) 
        rotate([90,0,0]) 
            linear_extrude(SERVO_DEPTH) {
                square([SERVO_WIDTH, SERVO_HEIGHT]);
                translate([(SERVO_WIDTH-MOUNT_WIDTH)/2, MOUNT_OFFSET])
                    square([MOUNT_WIDTH, MOUNT_HEIGHT]);
            }
}