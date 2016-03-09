
$fn = 48;

rr = 1;

O_length = 80;
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


difference() {
    translate([0, 0, O_height-rr])
        cube([O_length, O_width, 2*rr]);
    for(p=fingers) {
        translate(p)
            cylinder(h=3, r1=3+rr, r2=3+rr, , center=true);
    }
}
for(p=fingers) {
    translate(p)
        rotate_extrude()
            translate([3+rr, 0, 0])  circle(rr);
}