// Common Fixings Library

//$fa = 6;
//$fs = 0.4;

m3_nyloc();
translate([10,0,0]) m3_bolt();
translate([10,10,0]) m3_washer();
translate([10,-10,0]) m3_nyloc();
translate([10,20,0]) m3_nut();

module m3_washer(){
    difference(){
        cylinder(d=7, h=0.5);
        translate([0,0,-0.2]) cylinder(d=3.2, h=1);
        }
}

module m3_bolt(l=10){
    difference(){
        union(){
            cylinder(d=5.7, h=3);
            translate([0,0,-l]) cylinder(d=3, h=l);
            }
        translate([0,0,1.5]) cylinder(d=3.4, h=3, $fn=6);
        }
}

module m3_nyloc(){
    difference(){
        union(){
            cylinder(d=6.1, h=2.6, $fn=6);
            cylinder(d=5.3, h=4);
            }
        cylinder(d=3.4, h=6);
        }
}

module m3_nut(){
    difference(){
        union(){
            cylinder(d=6.1, h=2.4, $fn=6);
            }
        cylinder(d=3.4, h=6);
        }
}