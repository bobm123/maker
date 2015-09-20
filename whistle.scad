use <fillets.scad>

$fn = 24;

sides = 20;
rounding_radius = 2;


// prepare for printing

// Rotate on edge and move up
translate([0, 0, 16])
    rotate([135,0,0])
        whistle();

// add a t-shaped support for mouthpiece        
translate([-8,-18.5,0])
    cube([4,.25,4.5]);
translate([-8,-20.5,0])
    cube([4,4,.25]);


// TODO: add some support for upper edge of fipple

// A hollow box with a windway and fipple
module whistle() {
    
    difference() {
        body();
        #cube([sides,sides,sides]); // main interior
        translate([-11, 6.25, 18.25]) 
            cube([15,6.5,2]);  // windway
        translate([2, 6.25, 19.25]) 
            rotate([0,-10,0])
                cube([15, 6.5, 5]); // the fipple
    }
}


// A rounded box with a mouthpiece
module body () 
{
    fillet(r=rounding_radius,steps=6) {
    rounded_box([sides,sides,sides], rounding_radius);
    translate([-8, 6, 17.5]) 
        rounded_box([10, 8, 2.5], rounding_radius);
    }
}


module rounded_box(size, radius)
{
    x = size[0] - radius/2;
    y = size[1] - radius/2;
    
    minkowski()
    {
        cube(size=[x,y,size[2]]);
        sphere(r=radius);
    }
}

