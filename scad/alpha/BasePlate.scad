

//$fa = 6;
//$fs = 0.4;

base_plate();

module base_plate(){
    difference() {
        union () {
            // Main Shell
            cylinder(d=61, h=3);
            cylinder(d=58, h=4);
        }
        
        for (i=[0:4]) {
            // outer mounting holes
            rotate([0,0,i*72]) translate([-27.5,0,-1]) cylinder(h=10, d=3.4);
            rotate([0,0,i*72]) translate([-27.5,0,1]) cylinder(h=10, d=6.5);
            
            // foot pads
            rotate([0,0,i*72]) translate([22.5,0,2]) cylinder(h=10, d=10);
            
            // weight save holes
            rotate([0,0,i*72]) translate([-15,0,-1]) cylinder(h=10, d=14);
            
            // digispark mounts (x5)
            // M3 Mounting Holes
            rotate([0,0,i*72]) translate([27,-6.75,-1]) cylinder(d=6.5, h=30);
            rotate([0,0,i*72]) translate([27,6.75,-1]) cylinder(d=6.5, h=30);
        }
        
        // weight save holes
        translate([0,0,-1]) cylinder(h=10, d=10);
        translate([0,0,2]) cylinder(d=32, h=4);

    }
}