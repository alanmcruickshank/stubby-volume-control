
//$fa = 6;
//$fs = 0.4;

light_ring_spacer();

module light_ring_spacer(){
    difference() {
        union () {
            // gearbox lugs
            difference() {
                cylinder(d=66, h=1);
                for (i=[0:4]) {
                    rotate([0,0,i*72]) translate([24,0,-1]) cylinder(h=4, d=22);
                }
                translate([0,0,-1]) cylinder(d=42, h=7);
            }

            // Main Shell
            difference(){
                cylinder(d=66, h=3);
                translate([0,0,-1]) cylinder(d=62, h=5);
            }
        }

        for (i=[0:4]) {
            // outer mounting holes (far enough from edge and from upper nuts to not collide
            rotate([0,0,i*72]) translate([-27.5,0,-1]) cylinder(h=6, d=3.4);
        }
    }
}