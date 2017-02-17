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
//use <profiles/flatplate.scad>;   // Rounded flat plate
//use <profiles/curvedplate.scad>; // Curved plate
use <profiles/undercamber.scad>;   // Concave section
//use <profiles/tlar.scad>;        // "That looks about right"

// Defines a ratchet freewheeler
use <ratchet.scad>;

// Inch to mm conversion factor
mm = 25.4;

// Number of radial slices to use when generating
// use 10 for fast renders and test, higher to print
slices = 100;

// Basic propeller dimensions
prop_diameter = 5.25 * mm;
pitch = 5.25 * mm;
max_chord = .75 * mm;
shaft_dia = 1/16 * mm;
hub_dia = 3/16 * mm;


// Blade angle as a function of radius
function pitch_angle(r) = atan(pitch/(2*PI*r));

// Defines a double taper. Interpolates value for scaling
// the blade width at the given radius. Hub (r=0.00) has
// a width or 45% of max_chord, 100% chord is at 1/3 of the
// blade length (r=0.33), and the tip chord (r=1.00) is 
// 85% 0f max_chord. 
function get_blade_width(r) = lookup(r, [
    [ 0.00, 0.45 ],
    [ 0.33, 1.00 ],
    [ 0.99, 0.9 ],
    [ 1.00, 0.85 ]
]);


module propeller(n=2) {
    echo("Hub angle (deg)", pitch_angle(hub_dia/2));
    echo("Tip angle (deg)", pitch_angle(prop_diameter/2));

    difference() {
        union() {
            // Prop blades
            for (bi = [0:n-1]) {
                rotate([0,0,bi*(360/n)]) blade();
            }

            // Hub
            translate([0,0,max_chord*get_blade_width(.1)/2])
                ratchet(1.5, hub_dia/2, shaft_dia/2);
            cylinder(d=hub_dia, 
                     h=max_chord*get_blade_width(.1), 
                     center=true, $fn=48);
        }
        // Shaft
        cylinder(d=shaft_dia, 
                 h=max_chord*get_blade_width(1)+1, 
                 center=true, $fn=48);
    }
}

// Assembles a series of blade segments into a complete blade
// Since th blade 'grows' along the Z-azis, it must be rotated
// down to the x-axis.
module blade() {
    rotate([-90,0,0]) 
        rotate([0,90,0]) for (i=[.01:slices]) {
            p_section(i);
    }
}

// Forms the i-th segment of the propeller blade with a 
// convex hull between the airfoild shape at i and i+1.
// The airfoils are scaled and rotate as a function of
// their position along the blade radius.
module p_section(i)
{
    ri = (prop_diameter / 2) / slices;
    alpha = pitch_angle(ri*i);
    alpha1= pitch_angle(ri*(i+1));

    si = get_blade_width((i)/slices);
    si_1 = get_blade_width((i+1)/slices);

    stitch (
        profile_points(),
        transform_matrix(ri*i,alpha,max_chord*[si,1],[0,0]),
        transform_matrix(ri*(i+1),alpha1,max_chord*[si_1,1],[0,0]));
}


/*
First approach with alt_extrude()

// Forms the i-th segment of the propeller blade with a 
// convex hull between the airfoild shape at i and i+1.
// The airfoils are scaled and rotate as a function of
// their position along the blade radius.
module p_section(i)
{
    ri = (prop_diameter*mm / 2) / slices;
    alpha = atan(pdf/(i/slices)); 
    alpha1= atan(pdf/((i+1)/slices));

    translate([0,0,ri*i])
        hull() {
        rotate([0,0,alpha])
            scale([get_blade_width(i/slices),1,1])
                xsection(max_chord);
        rotate([0,0,alpha1])
            scale([get_blade_width((i+1)/slices),1,1])
                translate([0,0,ri]) xsection(max_chord);
        }
}


// Extrudes a thin section of the imported profile so the 
// hull() operator can be applied to the 2D pattern. Also
// Orients the 
module xsection(chord = 1)
{
//    linear_extrude(height=.01, center = true) 
//        scale([1,1]*chord)
//            profile();

    alt_extrude(profile_points(), .01, 0, s=[1,1]*chord);
}
*/
