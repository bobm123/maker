
use <hinge_no1.scad>;

in = 25.4;

hinge_width=6*in / 15;
hinge_height = 3.14*1.5*in / 3;

difference() {
    square([6,12]*in);
    #translate([0, 3]*in) hinge_no1(hinge_width, hinge_height);
}