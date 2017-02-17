
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
    1/100 * [[-14.082286,-7.242610],[-7.096628,-7.016637],[0.675635,-6.444259],[8.782751,-5.626185],[16.772966,-4.663124],[30.595688,-2.704882],[38.529782,-1.375210],[42.428496,-0.539545],[46.082809,0.564432],[47.597247,1.259525],[48.785302,2.072679],[49.558546,3.020889],[49.828552,4.121150],[49.580327,5.198386],[48.945079,5.994674],[48.052295,6.552337],[47.031467,6.913699],[45.123630,7.216814],[44.257482,7.242610],[-44.955986,7.242610],[-45.723079,7.163525],[-47.407613,6.771596],[-48.304823,6.385811],[-49.084476,5.834809],[-49.630932,5.089589],[-49.828552,4.121150],[-49.604547,3.191805],[-48.977493,2.234962],[-47.976326,1.262772],[-46.629981,0.287389],[-44.967392,-0.679034],[-43.017496,-1.624344],[-38.371518,-3.403015],[-32.923528,-4.951400],[-26.905006,-6.172277],[-20.547432,-6.968421],[-14.082286,-7.242610]];

module profile()
{
    polygon(profile_points());
}