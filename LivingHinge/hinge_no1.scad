

module hinge_no1(maxi, maxj)
{
    for (j=[0:1:20]) {
        for (i=[0:1:30]) {
            translate([15*i,3*j]) hing_cutout();
            translate([15*i+5,3*j+1]) hing_cutout();
            translate([15*i+10,3*j+2]) hing_cutout();
        }
    }
}


module hing_cutout()
{
    rotate([0, 0,-6]) polygon([[-4,0],[0,.15],[4,0],[0,-.15]]);
}