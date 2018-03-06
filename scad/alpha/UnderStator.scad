
//$fa = 6;
//$fs = 0.4;

under_stator();

module under_stator() {
    difference() {
        union () {
            cylinder(d=20, h=9);
            cylinder(d=22, h=6);
            
            cylinder(d=34, h=2.75);
            difference() {
                cylinder(d=66, h=1.5);
                for (i=[0:4]) {
                    rotate([0,0,i*72]) translate([24,0,-1]) cylinder(h=6, d=22);
                }
            }
            difference(){
                cylinder(d=66, h=5.5);
                translate([0,0,-1]) cylinder(d=62, h=7.5);
            }
        }
        
        translate([0,0,6]) cylinder(d=11, h=8);
        
        // encoder nut housing
        translate([0,0,-1]) cylinder(d=12, h=6, $fn=6);
        
        // encoder nut housing
        translate([0,0,5]) rotate([0,0,36]) cylinder(d=12, h=5, $fn=5);
        
        for (i=[0:4]) {
            rotate([0,0,i*72]) translate([8,0,-1]) cylinder(h=12, d=3.4);
            rotate([0,0,i*72]) translate([8,0,4.05]) cube([12,5.6,2.6], center=true);
            rotate([0,0,i*72]) translate([8,0,4.25]) cube([3.4,5.6,2.6], center=true);
            // outer mounting holes (far enough from edge and from upper nuts to not collide
            rotate([0,0,i*72]) translate([-27.5,0,-1]) cylinder(h=6, d=3.4);
        }
        
        for (i=[0:9]) {
            rotate([0,0,i*36]) translate([-14,0,-1]) cylinder(h=6, d=3.4);
        }
    }
}