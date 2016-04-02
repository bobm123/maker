
basic_cup_size = [19.0, 15.25, 14.0];
xl_cup_size = [19.0, 6*15.25, 14.0];

toolTray();

//translate([19/2, 0]) xlCup();

translate([0.5*19, 0.5*15.25 ]) basicCup();
translate([0.5*19, 1.5*15.25]) basicCup();
translate([0.5*19, 2.5*15.25 ]) basicCup();
translate([1.5*19, 0.5*15.25 ]) basicCup();
translate([1.5*19, 1.5*15.25]) basicCup();
translate([1.5*19, 2.5*15.25 ]) basicCup();

translate([.5*19, 15.25*3.5 ]) spongeCup();

module basicCup() {
    rounded_interior_cup(basic_cup_size);
}

module spongeCup() {
    rounded_interior_cup([2*19.0, 2*15.25, 14.0]);
}

module xlCup() {
    rounded_interior_cup(xl_cup_size);
}

module toolTray() {
    difference() {
        rounded_floor(0.0);
        translate([0, 0, 1.0]) rounded_floor(1.0);
    }
}


module rounded_interior_cup(outer_dim=basic_cup_size, tk=1.0, rr=1.5)
{
    difference() {
        inside_dim = outer_dim - 2*(tk+rr)*[1,1,0];
        round_vertical_box(outer_dim, tk+rr);
        translate((tk + rr) * [1,1,1]) {
            minkowski() {
                cube (inside_dim);
                sphere (r=rr, $fn=48);
            }
        }
    }
}


module round_vertical_box(odim, rr=1) {
    linear_extrude(height=odim[2])
        translate([rr,rr]) minkowski() {
            square([odim[0]-2*rr, odim[1]-2*rr]);
            circle(rr, $fn=48);
        }
}


module rounded_floor(tk=1.0) {
    $fn=48;
    linear_extrude(height=14) {
        translate([0, 19/2]) circle(r=19/2-tk);
        translate([0,6*15.25-19/2]) circle(r=19/2-tk);
        translate([-19/2+tk, 19/2]) square([19/2-tk, 6*15.25-19]);
        translate([0, tk]) square([19/2-tk, 6*15.25-tk*2]);
    }   
}

