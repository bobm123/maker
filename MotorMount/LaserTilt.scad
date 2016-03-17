/*!
 * LaserTile.scad <https://github.com/bobm123/maker>
 *
 * Copyright (c) 2016 Robert Marchese.
 * Licensed under the MIT license.
 *
 * OpenSCAD modules to generate a tilt mount for small
 * outrunner motors.
 *
 */
use <laser_box.scad>;

KERF = .3;
SPACER = 4+KERF;

tilt_mount(27, 30, 26, 5, 25.4*(3/32));

module tilt_mount(length, width, height, fingers, material)
{
    //side plate
    difference() {
        translate([0, 0, 0]) {
            side1(length, height, fingers, KERF, material);
        }
    polygon([[0,height-4],
             [0,height+KERF],
             [length/2, height+KERF]]);
    polygon([[0,4],[0,0],[length-material, 0]]);
        translate([2+length/4, height/2, 0])
            circle(r=25.4*(1/32), center=true, $fn=48);
        translate([2+length/2, height-3, 0])
            circle(r=25.4*(1/64), center=true, $fn=48);  
    }
    
    // back plate
    translate([-(width+SPACER), height/fingers, 0])    
        side1(width, (height/fingers)*(fingers-2), fingers-2, KERF, material);

    // front plate
    translate([length+SPACER, 0, 0]) {
        difference() {
            side2(width, height, fingers, KERF, material);
            translate([width/2, 1.5, 0])
                #square([6,3], center=true);
            translate([width/2, height/2, 0]) {
                circle(r=3.5, center=true, $fn=48);
                for (a=[45:90:360]) rotate([0, 0, a]) {
                    translate([7, 0])
                        circle(r=1.1, center=true, $fn=48);
                    translate([14, 0])
                        circle(r=1.25, center=true, $fn=48);
                }
            }
        }
    }
}