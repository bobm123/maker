STOL=.1;
SERVO_WIDTH = 23.5+STOL;
SERVO_HEIGHT=23.5+STOL;
SERVO_DEPTH=12.3+STOL;

ROUNDING = 2;

linear_extrude(height=7)
{
    difference() {
        minkowski() {
            square([SERVO_DEPTH, SERVO_WIDTH]);
            circle(ROUNDING, $fn=24);
        }
        square([SERVO_DEPTH, SERVO_WIDTH]);
    }
}