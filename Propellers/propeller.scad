// Parameteric design for a helical pitch prop that may
// be useful for small rubber band powred model planes
//
// Dimensions given in mm. Pitch is the ideal distance
// the propeller moves forward during 1 revolution

// Examples
//
// Basic 2-bladed RH-pitch, "sleek streak" clone
color("FireBrick") propeller(2);
//
// 4-bladed RH-pitch
//propeller(4);
//
// 3-bladed LH-pitch
//mirror([1,0,0]) propeller(3);

// Alternate extruder
use <alt_extrude.scad>

// Uncomment one of these to get the prop's airfoil. While the
// the Actual Clark-Y airfoil looks the most promising, printing
// the thin trailing edge could be a problem. You might have
// better luck with the flat plate or T.L.A.R.
//use <profiles/clarky.scad>;      // Classic wing design
//use <profiles/clarky-mod.scad>;  // non-zero TE thickness
//use <profiles/flatplate.scad>;   // Rounded flat plate
use <profiles/curvedplate.scad>; // Curved plate
//use <profiles/undercambered.scad>; // Concave section
//use <profiles/tlar.scad>;        // "That looks about right"

/*
// R = (C^2 + 1/4) / 2C
// For 10%, R = 1.75
// camber (x, R) = sqrt(R^2 - x^2) - c(0)
function rad(c) = (c+.25) / (2*c);
function camber(x, c) = rad(c)-sqrt(pow(rad(c),2) - x*x);
function profile_points(w=1, c=.05, t=.05, n=10) =
    concat(
        [for(x=[-n/2:n/2]) [w*x/(n),  camber(w*x/(n),c)+t/2]],
        [for(x=[-n/2:n/2]) [w*x/(-n), camber(w*x/(-n),c)-t/2]]
    );
*/

// Defines a ratchet freewheeler
use <ratchet.scad>;

// Inch to mm conversion factor
mm = 25.4;

// Number of radial slices to use when generating
// use 10 for fast renders and test, higher to print
slices = 25;

// Makes the holes slightly larger
hole_tolerance = .1;

// Basic propeller dimensions
prop_diameter = 5.25 * mm;
//prop_diameter = 200;
pitch = 5.25 * mm;
max_chord = .65 * mm;
//max_chord = 30;
shaft_diameter = 1/16 * mm + hole_tolerance;
//hub_diameter = 3/16 * mm;
hub_diameter = 5;

// height of hub given by the root chord
hub_height = max_chord*blade_width(hub_diameter/prop_diameter);

// Blade angle as a function of radius
function pitch_angle(r) = atan(pitch/(2*PI*r));

// Defines a double taper. Interpolates value for scaling
// the blade width at the given radius. Hub (r=0.00) has
// a width or 45% of max_chord, 100% chord is at 1/3 of the
// blade length (r=0.33), and the tip chord (r=1.00) is
// 85% 0f max_chord.
function blade_width(r) = lookup(r, [
    [ 0, 0.45 ],
    [ 0.33, 1.00 ],
    [ 0.99, 0.9 ],
    [ 1.00, 0.85 ]
]);
/*
function blade_width(r) = 1/30*lookup(r, [
    [ 0.0, 8 ],
    [ 0.1, 10],
    [ 0.2, 14 ],
    [ 0.3, 19 ],
    [ 0.4, 23 ],
    [ 0.5, 26 ],
    [ 0.6, 29 ],
    [ 0.7, 30 ],
    [ 0.8, 28 ],
    [ 0.9, 22 ],
    [ 0.95, 16 ],
    [ 0.975,12 ],
    [ 1.00, 4 ]
]);
*/

// Defines the amount the blade profile is shifted before rotation
// on its pitch ange. A value of .5 produces straight leading edge,
// -.5 a straight trailing edge and a value of 0 (or in between)
// gives a double taper according to the blade_width() function.
function offset(r) = 0;



module propeller(n=2) {
    echo("Hub angle (deg)", pitch_angle(hub_diameter/2));
    echo("Tip angle (deg)", pitch_angle(prop_diameter/2));

    difference() {
        union() {
            // Proppeller blades
            for (bi = [0:n-1]) {
                rotate([0,0,bi*(360/n)]) blade();
            }

            // Hub
            translate([0,0,hub_height/2])
                ratchet(1.5, hub_diameter/2, shaft_diameter/2);
            cylinder(d=hub_diameter,
                     h=hub_height,
                     center=true, $fn=48);
        }
        // Shaft
        cylinder(d=shaft_diameter,
                 h=hub_height+5,
                 center=true, $fn=48);
    }
}

// Assembles a series of blade segments into a complete blade
// Since th blade 'grows' along the Z-azis, it must be rotated
// down to the X-axis.
module blade() {
    shift_z = max_chord*blade_width(hub_diameter/2)/2*offset(hub_diameter/2);
    translate([0,0,shift_z]) rotate([-90,0,0]) rotate([0,90,0])
    for (i=[0:slices-1]) {
        p_section(i);
    }
}

// Forms the i-th segment of the propeller blade as a
// polyhedron with faces stretched between the propeller
// cross section at i and i+1. The airfoils are scaled and rotate
// as a function of their position along the blade radius.
//
// TODO: base minimum r0 based on profile, for 1st station
// renders properly from stich()
module p_section(i)
{
    ri = ((prop_diameter-shaft_diameter) / 2) / slices;
    r0 = max(1,shaft_diameter/2);
    alpha = pitch_angle(ri*i);
    alpha1= pitch_angle(ri*(i+1));

    rp = i/slices;
    rp1=(i+1)/slices;
    si = max_chord*[blade_width(rp),1];
    si1= max_chord*[blade_width(rp1),1];

    ti  = [offset(rp),0];
    ti1 = [offset(rp1),0];

    stitch (
        profile_points(),
        transform_matrix(r0+ri*i,alpha,si,ti),
        transform_matrix(r0+ri*(i+1),alpha1,si1,ti1));
}
