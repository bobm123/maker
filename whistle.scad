use <fillets.scad>

$fn = 24;

sides = 20;
length = 75;
rounding_radius = 2;


// Uncomment basic or supported version
//whistle();
whistle_with_supports();


// Prepared for printing
module whistle_with_supports()
{
    // Rotate on edge and move up
    translate([0, 0, rounding_radius+sides*sqrt(2)/2])
        rotate([135,0,0])
            whistle();

    // add a t-shaped support for mouthpiece        
    translate([-8,-18.5,0])
        cube([4,.25,4.5]);
    translate([-8,-20.5,0])
        cube([4,4,.25]);

    // TODO: add some support for upper edge of fipple
}


// A hollow box with a windway and fipple
module whistle() {
    
    difference() {
        body();
        cube([length,sides,sides-.5]); // main interior
        translate([-11, 6.25, 18.25]) 
            cube([15,6.5,2]);  // windway
        translate([2, 6.25, 17.8]) {
            rotate([0,-20,0])
                cube([15, 6.5, 5]); // the fipple
            rotate([0,17,0])
                cube([15, 6.5, 3]); // the fipple
        }
    }
}


// A rounded box with a mouthpiece
module body () 
{
    fillet(r=rounding_radius,steps=6) {
    rounded_box([length,sides,sides], rounding_radius);
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

