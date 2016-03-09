$fn = 48;


MotorMount1811();

rounding = .5;

// actually this is more like 1mm, but thicker for cutout
flange_height = 3; 

//cylinder(h=2, r1=20.9/2, r2=20.9/2);


module MotorMount1811() {
    difference() {
        base();
        holes();
    }
    for (a=[0:90:360]) {
        rotate([0, 0, a]) 
            translate([15.5/2, 0, -4])
                cylinder(h=4, r1=1.1, r2=1.1);
    }

}


module base() {
    translate([0, 0, rounding]) {
        minkowski() {
            union() {
                cylinder(h=7.25-rounding/2, r1=5-rounding/2, r2=5-rounding/2);
                intersection() {
                    translate([0, 0, flange_height/2]) {
                        cube([5.2-rounding/2, 20.9-rounding/2, flange_height], center = true);
                        cube([20.9-rounding/2, 5.2-rounding/2, flange_height], center = true);
                    }
                    cylinder(h=2, r1=(20.9-rounding)/2, r2=(20.9-rounding)/2, $fn=48);

                }
            }
            sphere(r=rounding, $fn=12);
        }
    }
}


module holes () {
    translate([0, 0, -.5]) {
        cylinder (h=9, r1 = 3, r2 = 3);
        for (a=[0:90:360]) {
            rotate([0, 0, a]) 
                translate([15.5/2, 0, 0])
                    cylinder(h=6, r1=1.1, r2=1.1);
        }
    }
}