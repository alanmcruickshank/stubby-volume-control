
//$fa = 6;
//$fs = 0.4;

encoder_grip();

module encoder_grip(){
    union(){
        difference(){
            union() {
                cylinder(d=10, h=11.5);
            }
            
            // grip the encoder
            cylinder(d=6.4, h=8);
            
            // chamfer for encoder
            cylinder(d1=8, d2=6.45, h=2);
            
            // screw hole
            cylinder(d=3.3, h=14);
            
            // key way
            translate([2.5,-6,11]) cube([12,12,12]);
            translate([-2.5-12,-6,11]) cube([12,12,12]);
            
            // captive nut
            translate([0,0,9]) cube([12,5.5,2.8], center=true);
            translate([0,0,9.5]) cube([3.3,5.5,2.5], center=true);
            
        }

        // encoder keyway
        translate([0,0,3.8]) cube([9,0.6,7.6], center=true);
    }
}