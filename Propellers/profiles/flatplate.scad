
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.
fudge = 0.1;

profile();

function profile_points() =
    1/100 * [[-44.606736,-4.867710],[44.606732,-4.867710],[45.433555,-4.805335],[46.281049,-4.636670],[47.252567,-4.295734],[48.224085,-3.722063],[49.071579,-2.855193],[49.671026,-1.634660],[49.898402,0.000000],[49.671026,1.634666],[49.071579,2.855202],[48.224085,3.722072],[47.252567,4.295741],[46.281049,4.636675],[45.433555,4.805338],[44.606732,4.867710],[-44.606736,4.867710],[-45.439313,4.790808],[-46.291841,4.609432],[-47.267913,4.256996],[-48.242067,3.676668],[-49.088841,2.811614],[-49.682774,1.605002],[-49.898402,0.000000],[-49.659277,-1.605051],[-49.054316,-2.811685],[-48.206103,-3.676742],[-47.237224,-4.257060],[-46.270263,-4.609477],[-45.427804,-4.790832],[-44.606736,-4.867710]];

module profile()
{
    polygon(profile_points());
}
