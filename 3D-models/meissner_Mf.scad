// Construction of a Meissner tetrahedron by modification
// of the Reuleaux tetrahedron to form a surface of 
// constant width. Note, this proceedure forms the 2nd type of 
// Meissner body, Mf, by rounding the edges surrounding a face
// as opposed to the first type Mv formed by rounding the edges 
// of a vertex. See:
// http://www.mi.uni-koeln.de/mi/Forschung/Kawohl/kawohl/pub100.pdf
//
// Step 1: Define a tetrahedron with its base centered on the 
// origin of the x-y plane
//
// Step 2: Form a Reuleaux tetrahedron by offseting 4
// spheres of radius 1 to the verticies and finding their 
// intersection.
//
// Step 3: Trim the edges to the base at the x-y plane and
// the extention the other three planes of the enclose
// tetrahedron. #union() in trimmed_reuleaux() visualize this.
//
// Step 4: Form the spindle spheroids that will become the
// new base edges by rotating a section of a unit circle
// with chord length 1.
//
// step 5: Combine step 3 & 4 to form the Meissner tetrahedron
//

// ensures a smooth surface at 'unit' scales
$fn = 96;

// For 3D printing
/*intersection() {
    union() {
        translate([0,0,-sqrt(2/3)*5]) meissner(10);
        rotate([180,0,0]) translate([10,0,-sqrt(2/3)*5]) meissner(10);
    }
    translate([-15,-15,0]) cube([30,30,30]);
}
*/

// Step by step illustration
tetrahedron(8);
translate([10,0,0]) reuleaux(8);
translate([20,0,0]) trimmed_reuleaux(8);
translate([30,0,0]) base_edges(8);
translate([40,0,0]) meissner(8);

// The basic shape
//meissner(8);

module meissner(s=1) {
    base_edges(s);
    trimmed_reuleaux(s);
}

// Vertices of a tetrahedron with its base centered on origin
tetrahedron_vert = [
    [0, 0, sqrt(2/3)],
    [1/(2*sqrt(3)), 1/2, 0],
    [1/(2*sqrt(3)),-1/2, 0],
    [ -1/sqrt(3), 0, 0]
];
tetrahedron_face = [[0,1,2],[0,2,3],[0,3,1],[3,2,1]];

module tetrahedron(s=1) {
    polyhedron(s*tetrahedron_vert,tetrahedron_face);
}

module reuleaux (s) {
    intersection_for(v = tetrahedron_vert) {
        translate(s*v) sphere(r=s);
    }
}

module trimmed_reuleaux (s) {
    intersection () {
        union() {
            cylinder(r=s/sqrt(3), h=s*sqrt(2/3));
            translate([0,0,-s*sqrt(2/3)]) tetrahedron(2*s);
        }
        reuleaux(s);
    }
}

module spheroid_edge(s) {
translate([s/(2*sqrt(3)),0,0]) rotate([90,0,0]) 
    rotate_extrude() {
        difference() {
            translate([-s*sqrt(3/4),0]) circle(r=s);
            translate([-s,0,0]) square(s*[2,2], center=true);
        }
    }
}

module base_edges(s) {
    for (az = [0:2]) {
        rotate([0,0,az*120]) {
            spheroid_edge(s);
        }
    }
}