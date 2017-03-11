use <BaseBrushless1811.scad>

$fn=24;
mm=25.4;
tol=.3;

rod_dia = 1/8*mm;
control_rod = .5*(3/64)*mm+tol;

rod_rad = rod_dia/2 + tol;
wall = 2.5;
shift_offset = wall+5;
flair=11;

case_height = 21.3;

translate([10,0,0]) rotate([0,0,180]) {
    part_a();
}
part_b();


module control_arm () {

    translate([-(shift_offset),-(case_height/2+control_rod),-case_height/2]) {
        difference() {
            cylinder(r=control_rod+1.6,h=3);
            cylinder(r=control_rod,h=3);
        }
    }
}


module support() {
    for(a=[30:60:360])
    {
        rotate([0,0,a]) 
            translate([rod_rad+.5*wall,0,0]) 
                cube([wall-.1,.4,case_height], center=true);
    }
}

module part_b ()
{
    difference ()
    {
        shell();
        holes_b();
        translate([-(shift_offset+wall/2),0,0]) 
            rotate([0,-90,0]) rotate([0,0,45]) 
                #DrillPattern1811();

    }
    difference ()
    {
        support();
        translate([-shift_offset+wall/2,-flair/2, (case_height/3-tol/2)*.5])
            cube([20,flair,case_height/3+tol]);
    }
    control_arm();
}

module part_a ()
{
    difference ()
    {
        shell();
        holes_a();
        rotate([0,90,0]) for(a=[45:90:360]) {
    #rotate([0,0,a]) 
        translate([(case_height-2*wall)*sqrt(2)/2,0,-8])
            cylinder(r=1, h=5, center=true);
}

    }
    support();
}

module shell()
{
    hull() {
            cylinder(r=rod_rad+wall,h=case_height, center=true);
            translate([-(shift_offset),0,0]) 
                cube([wall,flair,case_height],center=true);
    }

    translate([-(shift_offset), 0]) 
        cube([wall,case_height,case_height],center=true);
}

module holes_a()
{
    cylinder(r=rod_rad, h=case_height+1, center=true);
    translate([-shift_offset+wall/2,-flair/2,-(case_height/3+tol)/2])
        cube([20,flair,case_height/3+tol]);
}

module holes_b()
{
    cylinder(r=rod_rad, h=case_height+1, center=true);
    translate([-shift_offset+wall/2,-flair/2,-(case_height/3+tol/2)*1.5])
        cube([20,flair,case_height/3+tol]);
    translate([-shift_offset+wall/2,-flair/2, (case_height/3-tol/2)*.5])
        cube([20,flair,case_height/3+tol]);
}