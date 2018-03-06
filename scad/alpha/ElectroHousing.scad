

//$fa = 6;
//$fs = 0.4;

outer_shell_height=12;
bottom_inset=2;

electro_housing();

module electro_housing(){
    difference() {
        union () {
            // fixing lugs
            difference() {
                cylinder(d=66, h=outer_shell_height-bottom_inset);
                for (i=[0:4]) {
                    rotate([0,0,i*72]) translate([24,0,-1]) cylinder(h=outer_shell_height+2, d=22);
                }
                translate([0,0,-1]) cylinder(d=46, h=outer_shell_height+2);
            }
                   
            // digispark lugs
            translate([0,0,0]) 
                intersection() {
                    translate([20,-12,0]) cube([30,24,30]);
                    difference() {
                        cylinder(d=66, h=outer_shell_height-bottom_inset-2);
                        translate([0,0,-1]) cylinder(d=49, h=outer_shell_height-bottom_inset);
                        
                        // M3 Mounting Holes
                        translate([27,-6.75,0]) cylinder(d=3.4, h=30);
                        translate([27,6.75,0]) cylinder(d=3.4, h=30);
                    }
                }
       
            // Main Shell
            difference(){
                union() {
                    cylinder(d=66, h=outer_shell_height-1);
                    cylinder(d=64, h=outer_shell_height);
                }
                translate([0,0,-1]) cylinder(d=62, h=outer_shell_height+2);
            }
            
            
            //knurling
            difference(){
                cylinder(d=68,h=10);
                for (i = [0:31]){
                    rotate([0,0,i * (360/31)])
                        translate([68/2,0,-1])
                            cylinder(d=3, h=12);
                }
                translate([0,0,-1]) cylinder(d=65,h=12); 
            } 
        }
        
        // M3 captive digispark nut traps
        translate([25,-6.75,outer_shell_height-bottom_inset-9]) cube([10,5.6,2.6], center=true);
        translate([25,6.75,outer_shell_height-bottom_inset-9]) cube([10,5.6,2.6], center=true);
        translate([27,-6.75,outer_shell_height-bottom_inset-9+0.2]) cube([3.4,5.6,2.6], center=true);
        translate([27,6.75,outer_shell_height-bottom_inset-9+0.2]) cube([3.4,5.6,2.6], center=true);
        
        // 4 depth for usb entry port, 9mm width
        translate([20,-4.5,outer_shell_height-bottom_inset-5]) cube([16,9,4]);
        
        // 4 depth for usb entry port, 9mm width (wider port is 12x7)
        translate([30,-6,outer_shell_height-bottom_inset-7]) cube([16,12,7]);
        
        for (i=[0:4]) {
            // outer mounting holes
            rotate([0,0,i*72]) translate([-27.5,0,0]) cylinder(h=outer_shell_height, d=3.4);
            
            // upper nut traps
            rotate([0,0,i*72]) translate([-26.5,0,outer_shell_height-bottom_inset-2.6]) cube([10,5.6,2.6], center=true);
            rotate([0,0,i*72]) translate([-27.5,0,outer_shell_height-bottom_inset-2.4]) cube([3.4,5.6,2.6], center=true);
            
            // lower nut traps
            rotate([0,0,i*72]) translate([-26.5,0,2.6]) cube([10,5.6,2.6], center=true);
            rotate([0,0,i*72]) translate([-27.5,0,2.8]) cube([3.4,5.6,2.6], center=true);
        }
    }
}