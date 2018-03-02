// Standard encoder dimensions
$fa = 6;
$fs = 0.4;

translate([0,60,0]) encoder_and_board();

translate([60,60,0]) encoder();

translate([-60,60,0]) encoder_board();

module encoder_and_board(){
    union(){
        encoder();
        translate([0,0,-7-3.8]) encoder_board(); 
    } 
}

module encoder_board(){
    translate([-14.2,-9.7,0]) cube([28.4,19.4,3.8]);    
}

module encoder(){
    difference(){
        union(){
            cylinder(d=7, h=7);
            cylinder(d=4, h=16);
            translate([0,0,10]) cylinder(d=6, h=10);
            translate([-6,-6,-7]) cube([12,12,7]);
        }
        // Keyway slot
        translate([0,0,20-5.5]) cube([1,12,11], center=true);  
    }
}