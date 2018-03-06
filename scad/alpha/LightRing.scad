

//$fa = 6;
//$fs = 0.4;

// NB: Print this in something translucent
light_ring();

module light_ring(){
    difference() {
        union () {
            // gearbox lugs
            difference() {
                cylinder(d=66, h=5);
                for (i=[0:4]) {
                    rotate([0,0,i*72]) translate([21,0,-1]) cylinder(h=7, d=20);
                }
                translate([0,0,-1]) cylinder(d=42, h=7);
                difference() {
                    translate([0,0,3]) difference(){
                        cylinder(d=68, h=4);
                        translate([0,0,-1]) cylinder(d=61, h=6);
                    }
                }
            }
        }
        
        for (i=[0:4]) {
            // outer mounting holes (far enough from edge and from upper nuts to not collide
            rotate([0,0,i*72]) translate([-27.5,0,0]) cylinder(h=6, d=3.4);
            // LED Mounting holes
            rotate([0,0,i*72]) translate([-20,0,2.5]) rotate([0,-90,0]) cylinder(h=6.5, d=5);
            // slots to stop LED mounting getting silly
            rotate([0,0,i*72]) translate([-20,0,2.5]) cube([12,1,7], center=true);
        }
    }
}