// Rod end keepers and y-axis enstop switch holder

$fn=60;

rod_dia = 8;
screw_dia = 4;
screw_offset = 8;
wall = 1.5;
height = 6;
tol = .2;

switch_height=8;
width=22;
thick = 7;
wire = 5;


for (i=[0:2]){
    translate([20*i-10,20,0]) basic_rodend();
}
translate([25,0,0]) endstop_partB();
endstop_partA();

module basic_rodend(height=6) 
{
    difference() {
        base(height);
        holes(height+.1);
    }
}

module endstop_partB(height=3)
{
    difference() {
        translate([-(thick+rod_dia+wall),-width/2-wall,0]){
            difference() {
                hull() {
                    translate([2.5+thick,0,0]) cube([wall*2, width+wall*2,height]);
                    translate([thick+rod_dia+wall,width/2+wall,0])
                        cylinder (r=rod_dia/2, h=height);
                }
            }
            translate([2.5+thick,0,0]) cube([wall*2, width+wall*2,height+6]);
        }
        holes(switch_height+wall+.1);
    }
    basic_rodend(height);
}


module endstop_partA()
{
    
    difference() {
        translate([-(thick+rod_dia-1),-width/2-wall,0]){
            difference() {
                hull() {
                    cube([thick+wall*2, width+wall*2,switch_height+wall]);
                    translate([thick+rod_dia-1,width/2+wall,0])
                        cylinder (r=rod_dia/2, h=6);
                }
                translate([wall, wall, 0]) cube([thick, width,switch_height+wall+.1]);
            }
        }
            holes(switch_height+wall+.1);
    }
    basic_rodend();
}

module holes (h) {
    cylinder(h = h, r=rod_dia/2+tol);
    translate([screw_offset,0,0]) cylinder(h = h, r=screw_dia/2);
}

module base (h) {
    linear_extrude(height = h) hull () {
      circle(r=rod_dia/2+wall);
      translate([screw_offset,0,0]) circle(r=screw_dia/2+wall);
    }
}

module endstop_holder() {
    
    //endstop holder
    difference () {
        translate([-thick/2,0,switch_height/2+wall/2])
            hull () {
                cylinder(r=rod_dia/2+wall, h=4);
                cube([thick+wall*2, width+wall*2,switch_height+wall], center=true);
        }
        translate([-thick/2,0,switch_height/2+wall/2]) 
            cube([thick, width,switch_height+wall+.1], center=true);
        holes(6);
    }

    //retainer bump
    translate([-thick-wall/5,0,switch_height*3/4]) scale([1,1,2]) sphere(r=wall/2);
}