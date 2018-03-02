//$fa = 6;
//$fs = 0.4;

under_carrier();

module under_carrier(){
    full_height = 3.9;
    difference() {
        union() {
            //outer contact race
            difference() {
                cylinder (d=66, h=full_height);
                translate([0,0,-1]) cylinder (d=63, h=full_height+2);
            }
            
            //wings
            intersection() {
                translate([0,0,-1]) cylinder (d=65, h=3);
                union(){
                    for (i = [0:4]) {
                        rotate([0,0,i*73.3]) difference() {
                            translate([27.4,0,0]) cylinder (d=15, h=2);
                            rotate([0,0,20]) translate([27.4+4,0,-1]) cylinder (d=15, h=4);
                            rotate([0,0,-20]) translate([27.4+4,0,-1]) cylinder (d=15, h=4);
                        }
                    }
                }
            }
            
            translate([0,0,0]) cylinder (r=21.2+3.5, h=full_height-0.6);
            // gear mounts
            for (i = [0, 73.3, 2*73.3, 3*73.3, 4*73.3]) {
                rotate([0,0,i]) translate([21.2,0,0]) cylinder(d=6, h=full_height);
            }
        }
        translate([0,0,-1]) cylinder (r=21.2-4, h=6);
        // gear mounts
        for (i = [0:4]) {
            rotate([0,0,i*73.3]) translate([21.2,0,0]) cylinder(d=3.3, h=6);
            rotate([0,0,i*73.3]) translate([21.2,0,-1]) rotate([0,0,90]) cylinder(d=7, h=full_height-1.4+1, $fn=6);
        }
        
        // weight saving holes
        for (i = [0:4]) {
            rotate([0,0, (i * 72) - ((360 - (4*73.3))/2)]) translate([21.2,0,-1]) cylinder(d=3, h=6);
            rotate([0,0, (i * 72) - ((360 - (4*73.3))/2) + 15]) translate([21.2,0,-1]) cylinder(d=3, h=6);
            rotate([0,0, (i * 72) - ((360 - (4*73.3))/2) - 15]) translate([21.2,0,-1]) cylinder(d=3, h=6);
        }
    }
}

