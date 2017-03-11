use <LaserTilt.scad>;


length = 27;
width = 30;
height=26;

KERF = .3;
SPACER = 4+KERF;

thickness = 25.4*(1/16);


//color("tan") 
//    rotate([0,0,60]) translate([-2-length/4, -height/2])
//    side_plate(27, 30, 26, 5, thickness);
//color("yellow") 
//    rotate([0,0,0]) translate([-2-length/4, -height/2])
//    side_plate(27, 30, 26, 5, thickness);

difference() {
    linear_extrude(height=26, center=true) difference() {
        bracket_profile();
        circle(r=1.1, center=true, $fn=48);
    }
    #translate([-17,0,0]) rotate([0,90,0]) 
        for (t=[[-7,-7,0],[-7,7,0],[7,7,0],[7,-7,0]]) {
            translate(t) cylinder(h = 3, r1=2.5/2, r2=2.5/2, $fn=24);
            translate(t) translate([0,0,3]) cylinder(h = 25, r1=5/2, r2=4.2/2, $fn=24);
        }
}

module bracket_profile()
{
  circle(r=2.2, center=true, $fn=48);
  translate([-6.5,-1.5,0])   scale([25.4/90, -25.4/90, 1]) union()
  {
      polygon([[-36.441406,-52.168900],[-36.441406,-14.879900],[-29.353516,-14.879900],[-29.353516,-45.081100],[5.076172,-45.081100],[20.587891,-4.426800],[28.593750,40.786100],[21.076172,45.081100],[8.984375,45.081100],[-4.437500,41.485400],[-29.353516,27.299800],[-29.353516,2.112300],[-36.441406,2.112300],[-36.441406,31.418900],[-7.152344,48.094700],[8.050781,52.168900],[22.958984,52.168900],[36.441406,44.463900],[27.447266,-6.323200],[9.958984,-52.168900],[-36.441406,-52.168900]]);
  }
}
