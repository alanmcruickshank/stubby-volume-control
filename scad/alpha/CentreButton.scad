
//$fa = 6;
//$fs = 0.4;

centre_button();

module centre_button(){
    union() {
        difference(){
            union () {
                // toleranced so that it slides
                cylinder (d=24.6, h=5);
            }
            translate([0,0,1.5]) cylinder (d=23, h=5);
            translate([0,0,-1]) cylinder (d=22, h=3);
        }
        
        difference(){
            cylinder (d=10, h=5);
            translate([0,0,5]) cube ([5.2,10,2] , center=true);
            translate([0,0,-1]) cylinder (d=6, h=4);
            cylinder (d=3.3, h=5);
        }
        
        // fins
        for (i = [0:4]) {
            // inner
            rotate([0,0, (i * 72)]) translate([4.5,-1.5,0]) cube([7,3,1.5]);
            // outer
            rotate([0,0, (i * 72)]) translate([12,-1.5, 3.5]) cube([2,3,1.5]);
        }
    }
}
