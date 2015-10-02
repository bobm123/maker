// A stockpicker toy. Use 'bear' and 'bull'
// variables to adjust for market sentimate

//test the dxp positions
//sell_text();
//buy_text();
//hold_text();

die_size = 44;
die_size2 = die_size / 2;
rounding = 5;


//StockPicker(bear=false, bull=false); // normal market
//StockPicker(bear=true,  bull=false); // bear market
//StockPicker(bear=false, bull=true);  // bull market
StockPicker(bear=true,  bull=true);  // battleground


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
        if (bull) {
            translate([die_size2, 0, 0]) 
                rotate([90, 0, 90]) buy_text();
        }
        else {
            translate([die_size2, 0, 0]) 
                rotate([90, 0, 90]) hold_text();
        }
        if (bear) {
            translate([-die_size2, 0, 0]) 
                rotate([90, 0, -90]) sell_text();
        }
        else {
            translate([-die_size2, 0, 0]) 
                rotate([90, 0, -90]) hold_text();
        }
    }
}

module buy_text() {
    translate([-11, -5, -2]) 
        linear_extrude(4) import("BUY.dxf");
}

module sell_text() {
    translate([-13, -5, -2]) 
        linear_extrude(4) import("SELL.dxf");
}

module hold_text() {
    translate([-17, -5, -2]) 
        linear_extrude(4) import("HOLD.dxf");
}