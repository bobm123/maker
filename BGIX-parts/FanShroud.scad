use <extruder_mount.scad>


hole_spacing=32;
hole_diameter=3.5;
fan_height = 10.5;
fan_diameter = 38;
wall=1.2;

yoffset=-4;
xoffset=17;
flage_height=14;

// From Paul's file
slop=.2;
m3_nut_rad = 6.01/2+slop;
m3_nut_height = 2.4;
m3_rad = 3/2+slop;
m3_cap_rad = 4.25;
fan_hole_sep = 32;
    
$fn = 60;

FanShroud();


module FanShroud(show_ref=false) {
    difference() {
        union () {
            nozzle();
            plate();
        }
        #translate([0,0,wall*.75])
                square_pattern(hole_spacing/2, hole_spacing/2)
                    rotate([0,0,30]) cylinder(r=7/2, h=4, $fn=6);
    }
    
    // Reference parts (for debug, don't print)
    if (show_ref) {
        rotate([180,0,0]) {

            translate([-56,0,-3])
            rotate([0,180,90]) 
                extruder_mount(offset=-3, mount_screw_rad=m3_rad, fan_mount=1);

        translate([0,0,0])
            fan_40mm();
        }
    }
}

module square_pattern(tx, ty)
{
    translate([ tx, ty]) children();
    translate([-tx, ty]) children();
    translate([-tx,-ty]) children();
    translate([ tx,-ty]) children();
}


module rnd_square(s, r)
{
    hull() square_pattern(s[0]/2-r, s[1]/2-r) circle(r=r);
}


module nozzle() 
{
    translate([0,0,wall]) difference()
    {
        union() {
            hull() {
            cylinder(r=(fan_diameter+wall+.25)/2,h=.01);
            translate([xoffset,yoffset,20]) 
                linear_extrude(height=.1) 
                    rnd_square([5+wall,10+wall],(wall+1)/2);
        }
        translate([xoffset,yoffset,20]) 
            linear_extrude(height=2) 
                rnd_square([5+wall,10+wall],(wall+1)/2);
        }
        hull() {
            translate([0,0,-.01]) 
                cylinder(r=fan_diameter/2,h=.01);
            translate([xoffset,yoffset,20+.01]) 
                linear_extrude(height=.1) 
                    rnd_square([5,10],1);
        }
        translate([xoffset,yoffset,20+.01]) 
            linear_extrude(height=3.1) 
                rnd_square([5,10],1);
    }
}

module plate()
{
    difference() {
    
        // Base Plate
        union() {
            translate([-flage_height/2,0,0]) 
                linear_extrude(height=wall) 
                    rnd_square(
                        [hole_spacing+flage_height+9, hole_spacing+9], 
                        hole_diameter/2+wall);
        }
        
        //Fan Mounting Holes
        translate([0,0,-.01]) square_pattern(hole_spacing/2, hole_spacing/2) 
            cylinder(r=hole_diameter/2,h=wall+.1);
        
        //Top Mounting Holes and Main Fan opening
        translate([-.5*hole_spacing-flage_height,16,-.01])
            cylinder(r=hole_diameter/2,h=wall+.02);
        translate([-.5*hole_spacing-flage_height,-16,-.01])
            cylinder(r=hole_diameter/2,h=wall+.02);
        translate([0,0,-.01])cylinder(r=fan_diameter/2,h=wall+.02);
    }
}


module fan_40mm() {
    difference () {
        fan_body();
        fan_holes();
    }
}


module fan_body () {
    hull() {
    translate(.5*hole_spacing*[1,1,0]) cylinder(r=hole_diameter/2+wall,h=fan_height);
    translate(.5*hole_spacing*[1,-1,0]) cylinder(r=hole_diameter/2+wall,h=fan_height);
    translate(.5*hole_spacing*[-1,1,0]) cylinder(r=hole_diameter/2+wall,h=fan_height);
    translate(.5*hole_spacing*[-1,-1,0]) cylinder(r=hole_diameter/2+wall,h=fan_height);
    }
}


module fan_holes() {
    translate(.5*hole_spacing*[1,1,0]) cylinder(r=hole_diameter/2,h=fan_height+.1);
    translate(.5*hole_spacing*[1,-1,]) cylinder(r=hole_diameter/2,h=fan_height+.1);
    translate(.5*hole_spacing*[-1,1,0]) cylinder(r=hole_diameter/2,h=fan_height+.1);
    translate(.5*hole_spacing*[-1,-1,0]) cylinder(r=hole_diameter/2,h=fan_height+.1);
    translate([0,0,-.01])cylinder(r=fan_diameter/2,h=fan_height+.02);
}