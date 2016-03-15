SPACER = 2;


laser_box(50, 30, 20, 5, 25.4*(1/16));

//box_joint(50, 5, 2, true);
//translate([0, 5]) box_joint(50, 5, 2, false);

module laser_box(length, width, height, fingers, material)
{
    translate([0, 0, 0])
        bottom(length, width, fingers, material);
    translate([length+SPACER, 0, 0]) 
        side1(height, width, fingers, material);
    translate([length+SPACER+height+SPACER, 0, 0])
        side2(length, height, fingers, material);
}

module bottom(length, width, fingers, material) {
    difference () {
        square([length, width]);
        box_joint(length, fingers, material, false);
        translate([0, width-material])
            box_joint(length, fingers, material, false);
        rotate([0, 0, 90]) {
            translate([0, -material])
                box_joint(width, fingers, material, true);
            translate([0, -length])
                box_joint(width, fingers, material, true);
        }
    }
}

module side1(height, width, fingers, material) {
    difference () {
        square([height, width]);
        box_joint(height, fingers, material, true);
        translate([0, width-material])
            box_joint(height, fingers, material, true);
        rotate([0, 0, 90]) {
            translate([0, -material])
                box_joint(width, fingers, material, false);
            translate([0, -height])
                box_joint(width, fingers, material, false);
        }
    }  
}

module side2(length, width, fingers, material) {
    difference () {
        square([length, width]);
        box_joint(length, fingers, material, true);
        translate([0, width-material])
            box_joint(length, fingers, material, true);
        rotate([0, 0, 90]) {
            translate([0, -material])
                box_joint(width, fingers, material, false);
            translate([0, -length])
                box_joint(width, fingers, material, false);
        }
    }
}
module box_joint(jlen, flen, thick, show_a)
{
    if (show_a) {
        union() {
            //square([jlen, thick]);
            side_a(jlen, flen, thick);
        }
    }
    else {
        difference() {
            square([jlen, thick]);
            side_a(jlen, flen, thick);
        }
    }
}

module side_a(jlen, flen, thick)
{
    //start_offset = (jlen - floor(jlen / flen) * flen)/2;
    start_offset = flen*1.5;
    for (n = [0:1: (jlen-start_offset)/(2*flen)-1]) {
        os = start_offset +n*2*flen;
        translate([os, 0]) 
            square([flen, thick]);
    }
}