use <fillets.scad>

$fn = 24;  

length = 75;
width = 35;
height = 22;
rounding_radius = 2;


mouthpiece_size = [10, 12, 2.5];

// Uncomment basic or supported version
//whistle();
whistle_with_supports();


// Prepared for printing
module whistle_with_supports()
{
    // Rotate on edge and move up - Pythagoras FTW
    z_offset = rounding_radius + height*sqrt(2)/2;
    translate([0, 0, z_offset])
        rotate([135,0,0])
            whistle();

    // add a t-shaped support for mouthpiece
    support_position = (height+(width-mouthpiece_size[1])/2) * sqrt(2)/2;
    support_height = (width - mouthpiece_size[1])/2 * sqrt(2)/2;
    translate([-10,-support_position,0])
        cube([6,.25,support_height]);
    translate([-10,-support_position-2,0])
        cube([6,4,.25]);

    // TODO: add some support for upper edge of fipple
}


// A hollow box with a windway and fipple
module whistle() {
    
    difference() {
        body();
        cube([length,width,height-.5]); // main interior
        windway_and_fipple();
    }
}


// Cutout for the windway through the mouthpiece and fipple
module windway_and_fipple()
{
    ww_length = mouthpiece_size[0] + 9;
    ww_width  = mouthpiece_size[1];
    ww_height = mouthpiece_size[2];
    # translate([
            -(mouthpiece_size[0]+rounding_radius+1), 
            (width - ww_width)/2, 
            height - ww_height
        ]) 
        cube([ww_length, ww_width, ww_height]);
    
    // Still some magic numbers here for tweeking fipple
    # translate([2.8, (width - ww_width)/2, height - 2.2]) {
        rotate([0,-20,0])
            cube([15, ww_width, 5]); // fipple - top cut
        rotate([0,17,0])
            cube([15, ww_width, 3]); // fipple - inside cut
    }
}




// A rounded box with a mouthpiece
module body () 
{
    fillet_rounding = rounding_radius;
    fillet(r=fillet_rounding,steps=$fn/4) {
        // The main body
        rounded_box([length, width, height], rounding_radius);
        
        // The mouthpiece centered and flush with top
        translate([
                -(mouthpiece_size[0]), 
                width/2 - (mouthpiece_size[1])/2, 
                (height - mouthpiece_size[2])
            ]) 
            rounded_box(mouthpiece_size, rounding_radius);
    }
}


module rounded_box(size, radius)
{
    x = size[0];
    y = size[1];
    
    minkowski()
    {
        cube(size=[x,y,size[2]]);
        sphere(r=radius);
    }
}

