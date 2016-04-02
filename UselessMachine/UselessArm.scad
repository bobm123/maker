$fn = 24;

difference() {
    linear_extrude(3) {
        translate([1.75,0,0]) circle(r=8, $fn=48);
        difference() {
            translate([3,16,0]) circle(r=24, $fn=96);
            translate([0,20,0]) circle(r=18, $fn=96);
            translate([-30,-16,0]) square([30,60]);
        }
    }

    translate([0, 0, 1.5]) {
        linear_extrude(2) {
            hull() {
                circle(r=2.85);
                translate([15, 0, 0]) circle(r=2.25);
            }
            circle(r=3.75);
        }
    }
    #cylinder(h=4, r1=1.5, r2 = 1.5);
}

 linear_extrude(6) {
    translate([0, 37, 0]) square([5,3]);
}