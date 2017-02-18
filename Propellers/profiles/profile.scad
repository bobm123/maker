
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.
fudge = 0.1;

module poly_path6(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[-18.849438,-5.846500],[-25.020296,-5.656378],[-31.175482,-5.006917],[-34.214440,-4.456194],[-37.210171,-3.726148],[-40.149571,-2.795282],[-43.019538,-1.642100],[-44.434396,-0.864579],[-45.783460,0.047444],[-46.785772,1.055592],[-47.069095,1.583721],[-47.160371,2.121490],[-46.996308,2.807604],[-46.648113,3.348944],[-46.154828,3.767527],[-45.555497,4.085372],[-44.194863,4.506917],[-42.878555,4.789720],[-39.281768,5.230490],[-35.674161,5.529804],[-28.436457,5.810590],[-13.940872,5.846500],[47.160371,5.844500],[47.160371,4.050020],[39.905496,2.475636],[22.313222,-0.973038],[11.596348,-2.802821],[0.642069,-4.384282],[-9.767298,-5.478457],[-14.523166,-5.768135],[-18.849438,-5.846380]]);
  }
}

poly_path6(0.10000000149011612);
