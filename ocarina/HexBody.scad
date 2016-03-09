$fn = 24; 

//length, width, height
rounded_box([45, 32, 23], 2);

module rounded_box(size, radius) {
    minkowski()     {
        basic_shape(size);
        sphere(r=radius);
    }
}


module basic_shape(size) {
    //cube(size);
    translate([0, -size[2]/2, size[2]/2]) rotate([0, 90, 0]) linear_extrude(height=size[0]) hull() {
        rotate([0, 0, 45])
            square(size[2]/sqrt(2));
        translate([0, size[1], 0]) 
            rotate([0, 0, 45])
                square(size[2]/sqrt(2));
    }
}