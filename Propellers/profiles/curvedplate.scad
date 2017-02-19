
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.
fudge = 0.1;

profile();

function profile_points() = 1/60 * [[29.966645,0.310106],[22.708674,-1.022631],[15.239797,-1.977064],[7.632082,-2.553115],[-0.042401,-2.750706],[-7.711584,-2.569758],[-15.303399,-2.010192],[-22.745775,-1.071930],[-29.966645,0.245106],[-29.966645,2.750706],[-22.696458,1.585523],[-15.232059,0.712487],[-7.639130,0.151981],[0.016645,-0.075616],[7.669583,0.050077],[15.254001,0.549441],[22.704216,1.442857],[29.954545,2.750706]];

module profile()
{
    polygon(profile_points());
}


