/*!
 * laser_box.scad <https://github.com/bobm123/maker>
 *
 * Copyright (c) 2016 Robert Marchese.
 * Licensed under the MIT license.
 *
 * OpenSCAD modules to generate a parts for a laser cut
 * box given the outside dimentsion, number of fingers
 * for the box joints and thickness of the material
 *
 */

KERF = .1;
SPACER = 2+KERF;


// Example of 50mm x 30mm x 1", made from 1/16" thick matertial
laser_box(50, 30, 25.4*1, 11, 25.4*(1/16));


module laser_box(length, width, height, fingers, material)
{
    finger_width = height / fingers;
    translate([0, 0, 0])
        bottom(length, width, fingers, KERF, material);

    translate([length+SPACER, 0, 0]) 
        side1(width, height, fingers, KERF, material);
    translate([length+SPACER+width+SPACER, 0, 0])
        side2(length, height, fingers, KERF, material);

}


module box_joint(jlen, fcount, thick, kerf, show_a)
{
    flen = jlen / fcount;
    rotate([0, 0, 90])
    if (show_a) {
        side_a(jlen, flen, thick, kerf, (1+fcount)%2);
    }
    else {
        side_b(jlen, flen, thick, kerf, fcount%2);
    }
}


module side_a(jlen, flen, thick, kerf, even=1)
{
    os_initial = 0;
    intersection() {
        square([jlen+kerf, thick]);
        for (n = [0:1:(jlen)/(2*flen)-even]) {
            os = os_initial + n*2*flen;
            translate([os, 0]) 
                square([flen+kerf, thick]);
        }
    }
}


module side_b(jlen, flen, thick, kerf, odd=1)
{
    os_initial = flen;
    intersection() {
        square([jlen+kerf, thick]);
        for (n = [0:1:(jlen)/(2*flen)-odd]) {
            os = os_initial + n*2*flen;
            translate([os, 0]) 
                square([flen+kerf, thick]);
        }
    }
}


module bottom(length, width, fingers, kerf, material) {
    // flat bottom for now
    square([length+kerf, width+kerf]);
}


module side1(width, height, fingers, kerf, material) {
    translate([material, 0])
        square([width-(2*material-kerf), height+kerf]);
    translate([material, 0,])
        box_joint(height, fingers, material, kerf, true);
    translate([width+kerf, 0])
        box_joint(height, fingers, material, kerf, true);
}


module side2(length, height, fingers, kerf, material) {
    translate([material, 0])
        square([length-(2*material-kerf), height+kerf]);
    translate([material, 0,])
        box_joint(height, fingers, material, kerf, false);
    translate([length+kerf, 0])
        box_joint(height, fingers, material, kerf, false);
}
