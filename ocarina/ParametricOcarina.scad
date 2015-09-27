use <whistle.scad>

O_length = 75;
O_width = 45;
O_height = 22;

// Finger hole locations
fingers = [
    [24, 12, O_height],
    [38, 15, O_height],
    [53, 14, O_height],
    [68, 11, O_height],
    
    [24, O_width-12, O_height],
    [38, O_width-15, O_height],
    [53, O_width-14, O_height],
    [68, O_width-11, O_height]
];

// Thumb holess
thumbs = [
    [35, 13, 0],
    [35, O_width-13, 0],
];


// Basic model
//ocarina(75, 45, 24);


//debug
/*
difference()
{
    ocarina(75, 45, 24);
    translate([0,-2.9,0])
        cube([75, 3, 24]);
}
*/

// prepped for prining
add_supports_at_90(O_length, O_width, O_height) {
    ocarina(O_length, O_width, O_height);
}


module ocarina(length, width, height)
{
    bottom_holes(thumbs, 2, 2, false) {
        top_holes(fingers, 2, 2, false) {
            whistle(length, width, height);
        }
    }
}

// Generate the model
/*
add_supports_at_45(75, 45, 24) {
    bottom_holes(thumbs, 3, 2, true) {
        top_holes(fingers, 3, 6, true) {
            whistle(75, 45, 24);
        }
    }
}
*/

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
            #cutout(p, thickness, radius, top=false);
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
            #cutout(p, thickness, radius);
        }
    }    
}


// Hole Cutouts
module cutout(p, t, r, top=true)
{
    if(top) {
        #translate([0,0,-.6])
        translate (p) {
            cylinder(t-.5, r+t*.5, r);
            cylinder(t+1, .25, .25);
        }
    }
    else {
        #translate([0,0,.6])
        translate (p) {
        rotate([180, 0, 0]) {
            cylinder(t-.5, r+t*.5, r);
            cylinder(t+1, .25, .25);
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
                    circle(6.5);
                    circle(5);
                }
            }
        }
    }
}