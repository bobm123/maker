use <whistle.scad>

// Finger hole locations
fingers = [
    [25, 15, 20],
    [37, 15, 20],
    [49, 14, 20],
    [61, 12, 20],
    [25, 30, 20],
    [37, 30, 20],
    [49, 31, 20],
    [61, 33, 20]
];

// Thumb holess
thumbs = [
    [35, 13, 0],
    [35, 32, 0],
];


// Generate the model
add_supports_at_45(75, 45, 24) {
    bottom_holes(thumbs, 3, 2, true) {
        top_holes(fingers, 3, 6, true) {
            whistle(75, 45, 24);
        }
    }
}


module bottom_holes(positions, radius, thickness, bring=false) {
    difference() {
        union() {
            children(0);
            for(p=positions) {
                if(bring) {
                    translate([0,0,-.5])
                        ring(p, -thickness);
                }
            }
        }
        for(p=positions) {
            translate([0,0,.1])
            translate (p) {
                rotate([0, 180, 0]) {
                cylinder(thickness-.5, radius+thickness, radius);
                cylinder(thickness+1, 1, 1);
                }
            }        
        }
    }
}


module top_holes(positions, radius, thickness, bring=false) {
    difference() {
        union() {
            children(0);
            for(p=positions) {
                if(bring) {
                    ring(p, thickness);
                }
            }
        }
        for(p=positions) {
            translate (p) {
                cylinder(thickness-.5, radius+thickness, radius);
                cylinder(thickness, 1, 1);
            }        
        }
    }    
}


// Generate a thin tactile ring
module ring(p, t) {
    translate (p) {
        translate ([0, 0, t]) {
            linear_extrude(height = .5) {
                difference () {
                    circle(6);
                    circle(4);
                }
            }
        }
    }
}