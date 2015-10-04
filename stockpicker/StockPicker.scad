// A stockpicker toy. Use 'bear' and 'bull'
// variables to adjust for market sentimate

//Test the text generators
//sell_text();
//buy_text();
//hold_text();

die_size = 44;
die_size2 = die_size / 2;
rounding = 4;


// Experimental! Orient on edge for printing
translate([0, 0, die_size2+rounding+8.5]) {
    rotate([45, 0, 0]) rotate([0, 90, 0]) {
        StockPicker(bear=false, bull=false); // normal market
        //StockPicker(bear=true,  bull=false); // bear market
        //StockPicker(bear=false, bull=true);  // bull market
        //StockPicker(bear=true,  bull=true);  // battleground
    }
}


// and add some supports
hull() {
    translate([die_size2-rounding, 0, 0]) cylinder(6.5, 6, 0);
    translate([rounding-die_size2, 0, 0]) cylinder(6.5, 6, 0);
}


module StockPicker(bear = false, bull = false) {
    difference () {
        translate([
                rounding-die_size2,
                rounding-die_size2,
                rounding-die_size2]) {
            minkowski() {
                cube(die_size - 2*rounding);
                sphere(rounding, $fn=24);
            }
        }
        translate([0, 0, die_size2]) 
            rotate([0, 0, 0]) buy_text();
        translate([0, 0, -die_size2]) 
            rotate([180, 0, 0]) buy_text();
        translate([0, die_size2, 0]) 
            rotate([-90, -90, 0]) sell_text();
        translate([0, -die_size2, 0]) 
            rotate([90, -90, 0]) sell_text();
        
        // Apply market sentiment
        translate([die_size2, 0, 0]) {
            if (bull) {
                rotate([90, 0, 90]) buy_text();
            }
            else {
                rotate([90, 0, 90]) hold_text();
            }
        }
        translate([-die_size2, 0, 0]) {
            if (bear) {
                rotate([90, 0, -90]) sell_text();
            }
            else {
                rotate([90, 0, -90]) hold_text();
            }
        }
    }
}


module 3D_Letter(l, height=2, size = 10, font="Helvetica") {
    translate([0, 0, -height/2])
        linear_extrude(height) {
            text(l, 
                size = size, 
                font = font, 
                halign = "center", 
                valign = "center", 
                $fn = 24);
  }
}


module buy_text() {
    3D_Letter("BUY", height = 4, size= 12, font = "Helvetica:style=Bold");
}


module sell_text() {
    rotate([0, 0, -45])
        3D_Letter("SELL", height = 4, size= 11, font = "Helvetica:style=Bold");
}


module hold_text() {
    rotate([0, 0, -45])
        3D_Letter("HOLD", height = 4, size= 11, font = "Helvetica:style=Bold");
}