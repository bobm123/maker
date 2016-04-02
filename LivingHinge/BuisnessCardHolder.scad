
translate([0,70]) top_cover();
spacer();
translate([100,0]) spacer();
translate([100,70]) cover();
module logo() 
{
    translate([-20.5, -20])
        import("KatyLogoV2.dxf");
    difference() {
        circle(r=35/2);
        circle(r=34/2);
    }       
}


module top_cover()
{
    difference() {
        cover();
        translate(25.4*[(3.5)/2, (2)/2]) logo();
    }
 
}

module cover()
{
    scale(25.4)  
        difference() {
            minkowski() {
                square([3.5, 2]);
                circle(r=1/8, $fn=24);
            }
            translate([3.5+1/8, (2)/2]) circle(r=1/2, $fn=48);
        }
}


module spacer()
{
    scale(25.4) {
        difference() {
            minkowski() {
                square([3.5, 2]);
                circle(r=1/8, $fn=24);
            }
            #translate([0,0]) square([3.5+1/8,2]);
        }
    }
}