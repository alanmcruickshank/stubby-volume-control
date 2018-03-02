/// Planetary gear carrier

//$fa = 6;
//$fs = 0.4;

upper_carrier();

module upper_carrier(){
    difference (){
        union () {
            //outer contact race
            difference() {
                cylinder (d=66, h=3);
                translate([0,0,-1]) cylinder (d=60, h=5);
            }
            
            // inner contact race
            difference() {
                cylinder (d=28, h=5);
                translate([0,0,-1])  cylinder (d=25, h=7);
                for (i = [0:4]) {
                    // outer notches for centre button
                    rotate([0,0, (i * 72)]) translate([12,-1.7, 0]) cube([2,3.4,3.5]);
                }
            }
            
            // gear holder
            difference() {
                translate([0,0,1]) cylinder (r=21.2+3.5, h=3);
                translate([0,0,0]) cylinder (r=21.2-3.5, h=5);
            }
                        
            // gear mounts
            for (i = [0, 73.3, 2*73.3, 3*73.3, 4*73.3]) {
                rotate([0,0,i]) translate([21.2,0,0]) cylinder(d=6, h=3);
            }
            
            // fins
            for (i = [0:4]) {
                rotate([0,0, (i * 72) - ((360 - (4*73.3))/2)]) translate([0,0,1]) rotate([90,0,0]) linear_extrude(height=3, center=true) polygon([[13,2.5],[13,0],[32,0],[32,1],[14,4]]) ;
            }
        }
        // gear mounts
        for (i = [0:4]) {
            rotate([0,0,i*73.3]) translate([21.2,0,0]) cylinder(d=3.3, h=3);
            rotate([0,0,i*73.3]) translate([21.2,0,2]) cylinder(d=6, h=3);
        }
    }
}