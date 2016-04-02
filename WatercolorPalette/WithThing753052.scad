use <MintyInserts.scad>

import("altoids_tin_watercolor_palette.stl");

special_cup_size = [20.0, 16, 10.0];
color("White")
    translate([-12.5, -14, 3]) 
        rounded_interior_cup(special_cup_size, rr=0);