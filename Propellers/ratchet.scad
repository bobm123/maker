
N=48;

ratchet();

module ratchet(h=2, r0 = 3, r1 = 1) {
    for (i=[0:N]) {
        hull() {
            ratchet_slice(i, h, r0, r1); 
            ratchet_slice(i+1, h, r0, r1);
        }
    }
}

module ratchet_slice(si, max_h, r0, r1) {
    rotate([0,0,-si*(360/N)]) 
        translate([r1,0,0]) 
        linear_extrude(height=si*(max_h/N)) 
            square([r0-r1,.01]);
}