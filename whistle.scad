use <fillets.scad>

$fn = 24;  

length = 65;
width = 45;
height = 25;
rounding_radius = 2;

mouthpiece_size = [10, 12, 2.5];

ww_length = mouthpiece_size[0] + 9;
ww_width  = mouthpiece_size[1] - 2;
ww_height = mouthpiece_size[2];


fi_length = mouthpiece_size[0] + 7;
fi_width  = mouthpiece_size[1] - 2;
fi_height = mouthpiece_size[2];
fi_inset = 4;

// Uncomment basic or supported version
whistle();
//whistle_with_supports_at_45();
//whistle_with_supports_at_90();

module whistle_with_supports_at_90()
{
    z_offset = rounding_radius + height*sqrt(2)/2;
    translate([0, 0, rounding_radius])
        rotate([90,0,0])
            whistle();
    
    // add a t-shaped supports for mouthpiece
    support_position = height-mouthpiece_size[2];
    support_height = (width - mouthpiece_size[1])/2 ;
//    translate([-10,-support_position,0])
//        cube([6,.25,support_height]);
//    translate([-10,-support_position-4,0])
//        cube([6,6,.25]);

    //support_position1 = height;
    //translate([-10,-support_position1,0])
//        cube([6,.25,support_height]);
    t_support_x([-10,-support_position,0], 6, support_height);
    t_support_x([-10,-height,0], 6, support_height);
}


module whistle_with_supports_at_45 ()
{
    z_offset = rounding_radius + height*sqrt(2)/2;
    translate([0, 0, z_offset])
        rotate([135,0,0])
            whistle();

    // add a t-shaped support for mouthpiece
    support_position = (height+(width-mouthpiece_size[1])/2) * sqrt(2)/2;
    support_height = (width - mouthpiece_size[1])/2 * sqrt(2)/2;
    t_support_x([-10,-support_position,0], 4, support_height);

    // stabilize the body
    t_support_x([0, 6-height*sqrt(2)/2, 0], length, 6);
    t_support_x([0, -6-height*sqrt(2)/2, 0], length, 6);

    // support the upper edge of hole
    fp_z = (width+fi_width+fi_inset)/2*sqrt(2)/2;
    fp_y = -(height*sqrt(2)/2 + (width+fi_width+fi_inset)/2*sqrt(2)/2);
    t_support_x([0, fp_y, 0], fi_length, fp_z);
}

// make a t-shaped support structure along x-axis
module t_support_x(pos, l, h)
{
    translate(pos) {
        cube([l,.25, h]);
        translate([0, -2, 0])
            cube([l, 4,.25]);
    }
}

// A hollow box with a windway and fipple
module whistle() {
    
    difference() {
        body();
        cube([length, width, height]); // main interior
        
        // Cutout Windway
        translate([
            -(mouthpiece_size[0]+rounding_radius+1), 
            (width - ww_width)/2, 
            height - ww_height
        ]) 
            cube([ww_length, ww_width, ww_height]);
        
        // Cutout for fipple block
        fipple_block();
    }
    
    // form fipple as a seperate piece
    fipple();
    
}


module fipple_block() {
    w = fi_width + fi_inset;
    translate([0, 0, height - fi_height])
        cube([fi_length, width, fi_height + rounding_radius]);
}


module fipple() {
    // Still some magic numbers here for tweeking fipple size
    difference (){
        fipple_block();
        translate([2.8, (width - fi_width)/2, height - 2.75]) {
            rotate([0,-22,0])
                cube([18, fi_width, 6]); // fipple - top cut
            rotate([0,17,0])
                cube([18, fi_width, 3]); // fipple - inside cut
        }
        // make sure airway is clear
        translate([0, (width - fi_width)/2, height - 2.75])
            cube([5, fi_width, 10]);
    }
}


// A rounded box with a mouthpiece
module body () {
    fillet(r=rounding_radius, steps=$fn/4) {
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


module rounded_box(size, radius) {
    minkowski()     {
        cube(size);
        sphere(r=radius);
    }
}

