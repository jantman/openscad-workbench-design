module short_horizontal_plate()
{
    include <../config.scad>
    plate_length = table_width / 4;
    echo(str("BOM ITEM: short_horizontal_plate length=", plate_length, " material=", strut_timber_depth, "x", strut_timber_height));
    render() { // see note in README about rendering
        difference() {
            cube([plate_length,strut_timber_depth,strut_timber_height],false);

            // Left cutout
            translate([0,leg_timber_width/2,0])
            {
                cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
            }
            // Left top cutout
            translate([0,0,strut_timber_height/2]){
                cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
            }
            // Right cutout
            translate([plate_length-leg_timber_width,leg_timber_width/2,0])
            {
                cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
            }
            // Right top cutout
            translate([plate_length-(leg_timber_width/2),0,strut_timber_height/2]){
                cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
            }
        }
    }
}
