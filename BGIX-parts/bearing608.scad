/*
The most common bearing size is the “608.” Characterized by an 8mm core, a 22mm outer diameter and a 7mm width, these bearings are the industry standard and match up with nearly every skate wheel out there.
*/
bearing608();

module bearing608()
{
    difference () {
        cylinder(r=22/2,h=7, $fn=48);
        translate([0,0,-.05]) cylinder(r=8/2,h=7.1, $fn=48);
    }
}