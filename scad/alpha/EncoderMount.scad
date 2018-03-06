

$fa = 6;
$fs = 0.4;

// distance of bottom of stator to bottom of grip = 10mm
// encoder fits into grip by 7.6mm

// => 17.6mm of the encoder is above the base of this

// top of encoder is 20mm from bottom of thread

// therefore thickness of 2.4

// thread is M7



difference() {
    union () {
        cylinder(d=34, h=2);
        // higher central mount
        cylinder(d=14, h=3.2);
    }
    
    cylinder(d=7.2, h=8);
    translate([0,0,1.4]) cylinder(d=9, h=8);
    
    //translate([0,-5,1.5]) cube([7, 10, 3], center=true);
    
    for (i=[0:9]) {
        rotate([0,0,(i*36) - 18]) translate([8,0,0]) cylinder(h=8, d=3.4);
    }
    
    for (i=[0,1,5,6]) {
        rotate([0,0,(i*36) - 18]) translate([-14,0,0]) cylinder(h=4, d=3.4);
        rotate([0,0,(i*36) - 18]) translate([-14,0,1]) rotate([0,0,90]) cylinder(d=7, h=4, $fn=6);
        // and again just to cut corners
        rotate([0,0,(i*36) - 18]) translate([-16,0,1]) rotate([0,0,90]) cylinder(d=7, h=4, $fn=6);
    }
    
    // cut the shape
    translate([-40,7,0]) cube([80,10,4]);
    mirror([0,1,0]) translate([-40,7,0]) cube([80,10,4]);
    
}