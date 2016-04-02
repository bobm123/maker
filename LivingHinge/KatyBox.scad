// A living hinge box for Katy's portfolio
use <hinge_no1.scad>;

in = 25.4;

// 12" x 6" flap + 9" sides + 2*1.5"rad curves, 
sheet_size = [12, 1+2*9+3.14*1.5*2];

// each hinge element (group of 3) is 15 x 3 mm
hinge_width = 12*in / 15;
hinge_height = 3.14*1.5*in / 3;

// layout of all the parts
rotate([0,0,-90]) {
    shell();
    translate([-2, 12+2*1.5]*in) side();
    translate([-2, 0]*in) side();
}


module logo() 
{
    translate([-20.5, -20])
        import("KatyLogoV2.dxf");
    difference() {
        circle(r=35/2);
        circle(r=34/2);
    }       
}
        

module side()
{
    hull() {
        translate([0, 1.5]*in) circle(r=1.5*in);
        translate([0, 9+1.5]*in) circle(r=1.5*in);
    }
}


module shell() {
    difference() {
        hull () {
            square(sheet_size*in);
            translate([2.5,2*9+3.14*1.5*2+5.5]*in) circle(r=35/2);
        }
        #translate([0, 9]*in) 
            hinge_no1(hinge_width, hinge_height);
        #translate([0,18+3.14*1.5]*in)
            hinge_no1(hinge_width, hinge_height);
        #translate([9.5, 2.5]*in) logo();
        //debug to make interior visible
        //translate([5,5])square(sheet_size*in-[10,10]);
    }

}