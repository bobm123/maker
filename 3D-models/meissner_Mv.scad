// Construction of a Meissner tetrahedron by modification
// of the Reuleaux tetrahedron to form a surface of 
// constant width. Note, this proceedure forms the 1nd type of 
// Meissner body, Mv, by rounding the edges that join a vertex
// as opposed to the 2nd type Mf formed by rounding the edges 
// surrounding a face. See:
// http://www.mi.uni-koeln.de/mi/Forschung/Kawohl/kawohl/pub100.pdf
//
// Step 1: Define a tetrahedron with its base centered on the 
// origin of the x-y plane
//
// Step 2: Form a Reuleaux tetrahedron by offseting 4
// spheres of radius 1 to the verticies and finding their 
// intersection.
//
// Step 3: Trim the verted by subtracting extension of the 3 faces
// that meet at a vertex
//
// Step 4: Form the spindle spheroids that will become the
// new base edges by rotating a section of a unit circle
// with chord length 1. These also need to be trimmed by the 
// same face extension used in step 3
//
// step 5: Combine step 3 & 4 to form the Meissner tetrahedron
//

// ensures a smooth surface at 'unit' scales
$fn = 96;

// For 3D printing
/*
intersection() {
    union() {
        rotate([90,0,0]) translate([0,0,-sqrt(2/3)*5]) meissner_Mv(25.4);
        rotate([-90,0,0]) translate([25.4,0,-sqrt(2/3)*5]) meissner_Mv(25.4);
    }
    translate(25.4*[0,0,1.5]) cube(25.4*[3,3,3], center = true);
}
*/

// Step by step illustration
tetrahedron(8);
translate([10,0,0]) reuleaux(8);
translate([20,0,0]) trimmed_reuleaux_Mv(8);
translate([30,0,0]) rounded_edges(8);
translate([40,0,0]) meissner_Mv(8);


// The basic shape
//meissner_Mv(25.4);


module face_extensions(s)
{
    for (az = [0:2]) {
        rotate([0,0,180+az*120]) {
            translate(s*[1/sqrt(3),0,0]) rotate([0,-atan(2*sqrt(2))/2,0])linear_extrude(height=s*2, center=true) {
                polygon(s*[[0,0],[sqrt(3/4),1/2],[sqrt(3/4),-1/2]]);
            }
        }
    }

}


module meissner_Mv(s=1)
{
    trimmed_reuleaux_Mv(s);
    intersection() {
        rounded_edges(s);
        face_extensions(s);
    }
}


module trimmed_reuleaux_Mv (s) {
    difference() {
        reuleaux(s);
        face_extensions(s);
    }
}


module rounded_edges(s) {
    intersection() {
        translate(s*[0,0,sqrt(2/3)] ) for (az = [0:2]) {
            rotate([0,-atan(2*sqrt(2))/2,az*120+180]) {
                spheroid_edge(s);
            }
        }
        face_extensions(s);
    }
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
    translate(s*[0,0,-1/2]) rotate_extrude() {
        difference() {
            translate([-s*sqrt(3/4),0]) circle(r=s);
            translate([-s,0,0]) square(s*[2,2], center=true);
        }
    }
}
