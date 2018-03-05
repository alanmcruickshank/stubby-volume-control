use <common/fixings.scad>

use <alpha/Gears.scad>
use <alpha/UnderCarrier.scad>
use <alpha/GearCarrier.scad>

use <alpha/CentreButton.scad>
use <alpha/EncoderGrip.scad>

//$fa = 6;
//$fs = 0.4;

gearbox_assembly();


module gearbox_assembly(){
    union() {
        // Gears
        translate ([0,0,5]) upper_sun_gear();
        lower_sun_gear();
        volume_ring_gear();
        
        // Planet Gears & Fixings
        // NB Rotation not adjusted of planet gears
        for (i = [0:4]) {
            rotate([0,0,i*73.3]) translate ([(25.2778+17.5)/2,0,0]) volume_planet_gear();
            rotate([0,0,i*73.3]) translate ([(25.2778+17.5)/2,0,12]) m3_bolt(18);
            rotate([0,0,i*73.3]) translate ([(25.2778+17.5)/2,0,-3.9+1.4]) mirror([0,0,1]) rotate([0,0,90]) m3_nyloc();
        }
        
        // Carriers
        translate([0,0,-3.9]) under_carrier();
        translate([0,0,10]) upper_carrier();
        
        // Central Gear Mounting Bolts
        for (i = [0:4]) {
            rotate([0,0,i*72]) translate ([8,0,10]) m3_bolt(18);
        }
        
        // Button Assembly
        translate([0,0,16]) button_assembly();
    }
}


module button_assembly(){
    union(){
        rotate([180,0,0]) centre_button();
        translate([0,0,-3]) m3_bolt(5);
        translate([0,0,-(11.5+4)]) encoder_grip();
        translate([0,0,-7.5]) m3_nut();
    }
}