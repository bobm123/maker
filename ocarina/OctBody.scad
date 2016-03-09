$fn = 24; 

//length, width, height
rounded_box([45, 32, 23], 2);
//basic_shape([45, 32, 23], 2);

module rounded_box(size, radius) {
    minkowski()     {
        basic_shape(size);
        sphere(r=radius);
    }
}


module basic_shape(size) {
    //cube(size);
    translate([0, -size[2]/3, size[2]/3]) rotate([0, 90, 0]) linear_extrude(height=size[0]) 
        profile_oct(size);
}


module profile_oct(size) {
    hull() {
        translate([-size[2]/2, size[2]/3, 0]) 
            square([size[2], size[1]]);
        translate([-size[2]/6, 0, 0]) 
            square([size[2]/3, size[2]/3]);
        translate([-size[2]/6, size[2]/3+size[1], 0]) 
            square([size[2]/3, size[2]/3]);
    }
}


module profile_hex(size) {
    hull() {
        rotate([0, 0, 45])
            square(size[2]/sqrt(2));
        translate([0, size[1], 0]) 
            rotate([0, 0, 45])
                square(size[2]/sqrt(2));
    }
}