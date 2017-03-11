OFFSET = 6;
RAD = 1.5;

difference() {
    translate([0, 0, 0]) square([OFFSET, 4+RAD]);
    hull() {
        #translate([RAD, 0, 0]) circle(2, $fn=24);
        #translate([OFFSET-RAD, 0, 0]) circle(2, $fn=24);
    }
    hull() {
        #translate([RAD, 4+RAD, 0]) circle(2, $fn=24);
        #translate([OFFSET-RAD, 4+RAD, 0]) circle(2, $fn=24);
    }
}