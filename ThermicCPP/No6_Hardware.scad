// A small module defining some #6 hardware shapes
// Use solid=true to get the ouerall size of a cutout
// Use tol = .1 (or similar) to allow for printer inaccuracy
// 
IN_TO_MM = 25.4;

screw_and_nut(3/4 * IN_TO_MM, tol=0.0);
//hex_nut6_slot(10);

diameter6      = IN_TO_MM * 9 / 64;
nut6_outer_dia = IN_TO_MM * 23 / 64;
nut6_thickness = IN_TO_MM * 7 / 64;
head_height6 = IN_TO_MM * 0.083;
head_dia6    = IN_TO_MM * 0.262;


module screw_and_nut(length, tol=0.0) {
    translate ([0, 0, length-(nut6_thickness+tol)]) 
        hex_nut6(tol=tol, solid=false);
    machine_screw6(length, tol=tol);
}

    
module hex_nut6(tol = 0, solid = false) {
    linear_extrude (nut6_thickness+tol) {
        difference () {
            circle(tol + nut6_outer_dia/2, $fn = 6);
            if (!solid)
                circle(diameter6/2, $fn = 24);
        }

    }
}


module machine_screw6(length, tol=0)
{
    union() {
        translate([0, 0, tol]) {
            cylinder(head_height6, tol+head_dia6/2, tol+diameter6/2, $fn=24);
            cylinder(length-tol, tol+diameter6/2, tol+diameter6/2, $fn=24);
        }
        cylinder(tol+.01, tol+head_dia6/2, tol+head_dia6/2, $fn=24);
    }
}


module hex_nut6_slot(length, tol = 0) {
    linear_extrude (nut6_thickness+tol) {
        circle(tol + nut6_outer_dia/2, $fn = 6);
        translate([-(tol + nut6_outer_dia/2), 0, 0])
            square([tol + nut6_outer_dia, length]);
    }
}

